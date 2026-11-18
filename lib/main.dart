import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'l10n/generated/app_localizations.dart';

void main() => runApp(const FruitLedgerApp());

extension LedgerLocalizations on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String get localeName => Localizations.localeOf(this).toLanguageTag();
}

class Sale {
  const Sale({
    this.id,
    required this.date,
    required this.fruit,
    required this.revenue,
    required this.pricePerKg,
    required this.quantityKg,
    required this.cost,
    required this.expenses,
    required this.note,
  });

  final int? id;
  final DateTime date;
  final String fruit;
  final double revenue;
  final double pricePerKg;
  final double quantityKg;
  final double cost;
  final double expenses;
  final String note;
  double get profit => revenue - cost - expenses;

  Map<String, Object?> toMap() => {
    'id': id,
    'date': DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
    'fruit': fruit,
    'revenue': revenue,
    'price_per_kg': pricePerKg,
    'quantity_kg': quantityKg,
    'cost': cost,
    'expenses': expenses,
    'note': note,
  };

  factory Sale.fromMap(Map<String, Object?> map) => Sale(
    id: map['id'] as int,
    date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    fruit: map['fruit'] as String,
    revenue: (map['revenue'] as num).toDouble(),
    pricePerKg: ((map['price_per_kg'] as num?) ?? (map['revenue'] as num))
        .toDouble(),
    quantityKg: ((map['quantity_kg'] as num?) ?? 1).toDouble(),
    cost: (map['cost'] as num).toDouble(),
    expenses: (map['expenses'] as num).toDouble(),
    note: map['note'] as String,
  );
}

class SaleStore {
  SaleStore._();
  static final SaleStore instance = SaleStore._();
  Database? _db;

  Future<Database> get database async => _db ??= await openDatabase(
    p.join(await getDatabasesPath(), 'fruit_ledger.db'),
    version: 2,
    onCreate: (db, version) => db.execute('''
          CREATE TABLE sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date INTEGER NOT NULL,
            fruit TEXT NOT NULL,
            revenue REAL NOT NULL,
            price_per_kg REAL NOT NULL DEFAULT 0,
            quantity_kg REAL NOT NULL DEFAULT 1,
            cost REAL NOT NULL,
            expenses REAL NOT NULL,
            note TEXT NOT NULL
          )
        '''),
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
          'ALTER TABLE sales ADD COLUMN price_per_kg REAL NOT NULL DEFAULT 0',
        );
        await db.execute(
          'ALTER TABLE sales ADD COLUMN quantity_kg REAL NOT NULL DEFAULT 1',
        );
        await db.execute(
          'UPDATE sales SET price_per_kg = revenue WHERE price_per_kg = 0',
        );
      }
    },
  );

  Future<List<Sale>> all() async {
    final rows = await (await database).query(
      'sales',
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(Sale.fromMap).toList();
  }

  Future<void> save(Sale sale) async {
    final db = await database;
    if (sale.id == null) {
      await db.insert('sales', sale.toMap()..remove('id'));
    } else {
      await db.update(
        'sales',
        sale.toMap()..remove('id'),
        where: 'id = ?',
        whereArgs: [sale.id],
      );
    }
  }

  Future<void> delete(int id) async =>
      (await database).delete('sales', where: 'id = ?', whereArgs: [id]);
}

class FruitLedgerApp extends StatefulWidget {
  const FruitLedgerApp({super.key});

  @override
  State<FruitLedgerApp> createState() => _FruitLedgerAppState();
}

class _FruitLedgerAppState extends State<FruitLedgerApp> {
  Locale _locale = const Locale('uz');

  @override
  void initState() {
    super.initState();
    _restoreLocale();
  }

  Future<void> _restoreLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCode = preferences.getString('app_language') ?? 'uz';
    if (mounted && (savedCode == 'uz' || savedCode == 'en')) {
      setState(() => _locale = Locale(savedCode));
    }
  }

  Future<void> _setLocale(String languageCode) async {
    setState(() => _locale = Locale(languageCode));
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app_language', languageCode);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Uy biznesi',
    locale: _locale,
    supportedLocales: const [Locale('uz'), Locale('en')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF26734D),
        surface: const Color(0xFFF7F8F5),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F8F5),
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE7EAE5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF26734D), width: 1.5),
        ),
      ),
    ),
    home: LedgerHome(onLocaleSelected: _setLocale),
  );
}

class LedgerHome extends StatefulWidget {
  const LedgerHome({super.key, required this.onLocaleSelected});
  final ValueChanged<String> onLocaleSelected;
  @override
  State<LedgerHome> createState() => _LedgerHomeState();
}

class _LedgerHomeState extends State<LedgerHome> {
  List<Sale> _sales = [];
  bool _loading = true;
  int _tab = 0;
  int _period = 0;
  DateTime _anchor = DateTime.now();

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final sales = await SaleStore.instance.all();
    if (mounted) {
      setState(() {
        _sales = sales;
        _loading = false;
      });
    }
  }

  Future<void> _edit([Sale? sale]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SaleForm(sale: sale),
    );
    if (saved == true) await _reload();
  }

  Future<void> _delete(Sale sale) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteEntryTitle),
        content: Text(context.l10n.deleteEntryMessage(sale.fruit)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (ok == true && sale.id != null) {
      await SaleStore.instance.delete(sale.id!);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final l10n = context.l10n;
    final todaySales = _sales.where((s) => sameDay(s.date, today)).toList();
    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _tab == 0
        ? _dashboard(todaySales)
        : _reports();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFE5F0E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/brand/grape_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  l10n.appSubtitle,
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: l10n.language,
            icon: const Icon(Icons.translate_rounded, color: Color(0xFF26734D)),
            onSelected: widget.onLocaleSelected,
            itemBuilder: (_) => [
              PopupMenuItem<String>(enabled: false, child: Text(l10n.language)),
              PopupMenuItem(value: 'uz', child: Text(l10n.languageUzbek)),
              PopupMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: body),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              onPressed: () => _edit(),
              icon: const Icon(Icons.add),
              label: Text(l10n.addEntry),
              backgroundColor: const Color(0xFF26734D),
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (v) => setState(() => _tab = v),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: l10n.today,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: l10n.reports,
          ),
        ],
      ),
    );
  }

  Widget _dashboard(List<Sale> rows) {
    final l10n = context.l10n;
    final revenue = sum(rows, (s) => s.revenue);
    final profit = sum(rows, (s) => s.profit);
    final expenses = sum(rows, (s) => s.cost + s.expenses);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: [
        Text(
          capitalizeFirst(
            DateFormat(
              'EEEE, d MMMM',
              context.localeName,
            ).format(DateTime.now()),
          ),
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1F6945), Color(0xFF328358)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Colors.white70,
                    size: 19,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    l10n.todayNetProfit,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .78),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                money(context, profit),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.7,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _heroMetric(l10n.sales, money(context, revenue)),
                  ),
                  Container(width: 1, height: 36, color: Colors.white24),
                  Expanded(
                    child: _heroMetric(
                      l10n.costsAndExpenses,
                      money(context, expenses),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        if (_sales.isNotEmpty) _miniWeek(),
        if (_sales.isNotEmpty) const SizedBox(height: 22),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                l10n.todaysActivity,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.entriesCount(rows.length),
                style: const TextStyle(
                  color: Color(0xFF26734D),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (rows.isEmpty) _emptyToday() else ...rows.map(_saleTile),
      ],
    );
  }

  Widget _heroMetric(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _emptyToday() => Container(
    padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
    decoration: _cardDecoration(),
    child: Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF2EB),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_basket_outlined,
            color: Color(0xFF26734D),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.noSalesTitle,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 5),
        Text(
          context.l10n.noSalesMessage,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    ),
  );

  Widget _miniWeek() {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final data = List.generate(7, (i) {
      final d = start.add(Duration(days: i));
      return (
        day: d,
        profit: sum(_sales.where((s) => sameDay(s.date, d)), (s) => s.profit),
      );
    });
    final weekProfit = data.fold<double>(0, (total, v) => total + v.profit);
    final maxValue = data.fold<double>(
      0,
      (m, v) => v.profit.abs() > m ? v.profit.abs() : m,
    );
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.thisWeek,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      context.l10n.netProfit,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  money(context, weekProfit),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: weekProfit >= 0
                        ? const Color(0xFF26734D)
                        : const Color(0xFFC24D3A),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 88,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((v) {
                final barHeight = maxValue == 0
                    ? 4.0
                    : (v.profit.abs() / maxValue * 48).clamp(4.0, 48.0);
                final active = sameDay(v.day, now);
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 18,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: v.profit < 0
                                  ? const Color(0xFFD77A68)
                                  : active
                                  ? const Color(0xFF328358)
                                  : const Color(0xFFDDE9DF),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        capitalizeFirst(
                          DateFormat('EE', context.localeName).format(v.day),
                        ),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 10,
                          color: active
                              ? const Color(0xFF26734D)
                              : Colors.black45,
                          fontWeight: active
                              ? FontWeight.w800
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reports() {
    final l10n = context.l10n;
    final start = periodStart(_anchor, _period);
    final end = periodEnd(_anchor, _period);
    final rows = _sales
        .where((s) => !s.date.isBefore(start) && s.date.isBefore(end))
        .toList();
    final revenue = sum(rows, (s) => s.revenue);
    final cost = sum(rows, (s) => s.cost);
    final expenses = sum(rows, (s) => s.expenses);
    final profit = revenue - cost - expenses;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text(
          l10n.reports,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(l10n.reportSubtitle, style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFECEFEA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _period = i;
                    _anchor = DateTime.now();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _period == i ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      [l10n.daily, l10n.weekly, l10n.monthly][i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _period == i
                            ? const Color(0xFF26734D)
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              IconButton(
                onPressed: () =>
                    setState(() => _anchor = shiftPeriod(_anchor, _period, -1)),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  periodLabel(_anchor, _period, context.localeName),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                onPressed: periodIsCurrent(_anchor, _period)
                    ? null
                    : () => setState(
                        () => _anchor = shiftPeriod(_anchor, _period, 1),
                      ),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.netProfit,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    money(context, profit),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: profit >= 0
                          ? const Color(0xFF26734D)
                          : const Color(0xFFC24D3A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Divider(height: 1),
              const SizedBox(height: 4),
              _reportLine(l10n.totalSales, revenue),
              _reportLine(l10n.fruitCost, cost),
              _reportLine(l10n.otherExpenses, expenses),
              const Divider(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.entriesRecorded,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  Text(
                    '${rows.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (revenue > 0) ...[
                const SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.profitMargin,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                    Text(
                      '${(profit / revenue * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.periodEntries,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
            ),
            Text(
              '${rows.length}',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (rows.isEmpty)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: _cardDecoration(),
            child: Text(
              l10n.noPeriodEntries,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
          )
        else
          ...rows.map(_saleTile),
      ],
    );
  }

  Widget _reportLine(String label, double value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
        Text(
          money(context, value),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Widget _saleTile(Sale sale) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _edit(sale),
        onLongPress: () => _delete(sale),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4ED),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.eco_outlined, color: Color(0xFF518564)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale.fruit,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      context.l10n.saleDetails(
                        DateFormat(
                          'd MMM',
                          context.localeName,
                        ).format(sale.date),
                        money(context, sale.revenue),
                      ),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                    if (sale.note.isNotEmpty)
                      Text(
                        sale.note,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    money(context, sale.profit),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: sale.profit >= 0
                          ? const Color(0xFF26734D)
                          : const Color(0xFFC24D3A),
                    ),
                  ),
                  Text(
                    context.l10n.profit,
                    style: TextStyle(fontSize: 10, color: Colors.black45),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: context.l10n.editEntryTitle,
                visualDensity: VisualDensity.compact,
                onPressed: () => _edit(sale),
                icon: const Icon(Icons.edit_outlined, size: 19),
                color: const Color(0xFF26734D),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class SaleForm extends StatefulWidget {
  const SaleForm({super.key, this.sale});
  final Sale? sale;
  @override
  State<SaleForm> createState() => _SaleFormState();
}

class _SaleFormState extends State<SaleForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _fruit;
  late final TextEditingController _pricePerKg;
  late final TextEditingController _expenses;
  late final TextEditingController _note;
  late DateTime _date;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.sale;
    _fruit = TextEditingController(text: s?.fruit ?? '');
    _pricePerKg = TextEditingController(
      text: s == null ? '' : compact(s.pricePerKg),
    );
    _expenses = TextEditingController(
      text: s == null ? '0' : compact(s.expenses),
    );
    _note = TextEditingController(text: s?.note ?? '');
    _date = s?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _fruit.dispose();
    _pricePerKg.dispose();
    _expenses.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final confirmed = await showDialog<double>(
      context: context,
      builder: (_) => ConfirmReceivedDialog(
        fruit: _fruit.text.trim(),
        pricePerKg: number(_pricePerKg.text),
        initialQuantityKg: widget.sale?.quantityKg,
      ),
    );
    if (confirmed == null || !mounted) return;
    setState(() => _saving = true);
    try {
      final totalReceived = number(_pricePerKg.text) * confirmed;
      await SaleStore.instance.save(
        Sale(
          id: widget.sale?.id,
          date: _date,
          fruit: _fruit.text.trim(),
          revenue: totalReceived,
          pricePerKg: number(_pricePerKg.text),
          quantityKg: confirmed,
          cost: widget.sale?.cost ?? 0,
          expenses: number(_expenses.text),
          note: _note.text.trim(),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.saveError)));
      }
      return;
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        initialChildSize: .88,
        minChildSize: .72,
        maxChildSize: .96,
        expand: false,
        builder: (context, scroll) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF7F8F5),
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Form(
            key: _form,
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.sale == null ? l10n.addSaleTitle : l10n.editEntryTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.formIntro,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _fruit,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.fruitName,
                    hintText: l10n.fruitHint,
                    prefixIcon: Icon(Icons.eco_outlined),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.addFruitValidation
                      : null,
                ),
                const SizedBox(height: 13),
                _moneyField(
                  _pricePerKg,
                  l10n.pricePerKg,
                  l10n.pricePerKgHint,
                  Icons.payments_outlined,
                  required: true,
                ),
                const SizedBox(height: 13),
                _moneyField(
                  _expenses,
                  l10n.otherExpenses,
                  l10n.otherExpensesHint,
                  Icons.receipt_long_outlined,
                ),
                const SizedBox(height: 14),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _note,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.optionalNote,
                    hintText: l10n.noteHint,
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: Icon(
                      widget.sale == null ? Icons.check : Icons.save_outlined,
                    ),
                    label: Text(
                      widget.sale == null
                          ? l10n.continueToConfirm
                          : l10n.continueToConfirm,
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF26734D),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moneyField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool required = false,
  }) => TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onChanged: (_) => setState(() {}),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      prefixText: '${context.l10n.currencyPrefix}  ',
    ),
    validator: (v) {
      if (required && (v == null || v.trim().isEmpty)) {
        return context.l10n.enterAmount(label);
      }
      if (v != null && v.trim().isNotEmpty && numberOrNull(v) == null) {
        return context.l10n.validAmount;
      }
      if (v != null && v.trim().isNotEmpty && numberOrNull(v)! < 0) {
        return context.l10n.nonNegativeAmount;
      }
      return null;
    },
  );
}

class ConfirmReceivedDialog extends StatefulWidget {
  const ConfirmReceivedDialog({
    super.key,
    required this.fruit,
    required this.pricePerKg,
    this.initialQuantityKg,
  });

  final String fruit;
  final double pricePerKg;
  final double? initialQuantityKg;

  @override
  State<ConfirmReceivedDialog> createState() => _ConfirmReceivedDialogState();
}

class _ConfirmReceivedDialogState extends State<ConfirmReceivedDialog> {
  late final TextEditingController _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = TextEditingController(
      text: widget.initialQuantityKg == null
          ? ''
          : compact(widget.initialQuantityKg!),
    );
  }

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kg = numberOrNull(_quantity.text) ?? 0;
    final received = widget.pricePerKg * kg;
    return AlertDialog(
      title: Text(context.l10n.confirmReceivedTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.confirmReceivedMessage(widget.fruit)),
          const SizedBox(height: 16),
          TextField(
            controller: _quantity,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: context.l10n.quantityKg,
              hintText: context.l10n.quantityKgHint,
              prefixIcon: const Icon(Icons.scale_outlined),
            ),
          ),
          const SizedBox(height: 16),
          Text(context.l10n.calculatedReceived),
          const SizedBox(height: 4),
          Text(
            money(context, received),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF26734D),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: kg > 0 ? () => Navigator.pop(context, kg) : null,
          child: Text(context.l10n.confirmAndSave),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  boxShadow: const [
    BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 3)),
  ],
);
double sum(Iterable<Sale> values, double Function(Sale) pick) =>
    values.fold(0, (a, s) => a + pick(s));
bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
double number(String input) => numberOrNull(input) ?? 0;
double? numberOrNull(String input) {
  final cleaned = input.trim().replaceAll(RegExp(r'[\s\u00a0\u202f]'), '');
  final normalized = cleaned.contains(',') && !cleaned.contains('.')
      ? cleaned.replaceAll(',', '.')
      : cleaned.replaceAll(',', '');
  final parsed = double.tryParse(normalized);
  return parsed != null && parsed.isFinite ? parsed : null;
}

String capitalizeFirst(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
String compact(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toString();
String money(BuildContext context, num value) => context.l10n.currency(
  NumberFormat('#,##0.##', context.localeName).format(value),
);

DateTime periodStart(DateTime d, int period) {
  if (period == 0) return DateTime(d.year, d.month, d.day);
  if (period == 1) {
    return DateTime(
      d.year,
      d.month,
      d.day,
    ).subtract(Duration(days: d.weekday - 1));
  }
  return DateTime(d.year, d.month);
}

DateTime periodEnd(DateTime d, int period) {
  final start = periodStart(d, period);
  return period == 0
      ? start.add(const Duration(days: 1))
      : period == 1
      ? start.add(const Duration(days: 7))
      : DateTime(start.year, start.month + 1);
}

DateTime shiftPeriod(DateTime d, int period, int amount) => period == 0
    ? d.add(Duration(days: amount))
    : period == 1
    ? d.add(Duration(days: 7 * amount))
    : DateTime(d.year, d.month + amount, 1);
bool periodIsCurrent(DateTime d, int period) =>
    !periodStart(d, period).isBefore(periodStart(DateTime.now(), period));
String periodLabel(DateTime d, int period, String localeName) {
  if (period == 0) {
    return capitalizeFirst(DateFormat('EEE, d MMM yyyy', localeName).format(d));
  }
  if (period == 1) {
    final start = periodStart(d, period);
    final end = start.add(const Duration(days: 6));
    return '${DateFormat('d MMM', localeName).format(start)} – ${DateFormat('d MMM yyyy', localeName).format(end)}';
  }
  return DateFormat('MMMM yyyy', localeName).format(d);
}
