// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Uy biznesi';

  @override
  String get appSubtitle => 'Sales and profit, all in one place';

  @override
  String get language => 'Language';

  @override
  String get languageUzbek => 'O‘zbekcha';

  @override
  String get languageEnglish => 'English';

  @override
  String get deleteEntryTitle => 'Delete this entry?';

  @override
  String deleteEntryMessage(String fruit) {
    return 'The $fruit entry will be removed from your ledger.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get addSale => 'Add sale';

  @override
  String get addEntry => 'Add entry';

  @override
  String get today => 'Today';

  @override
  String get reports => 'Reports';

  @override
  String get todayNetProfit => 'TODAY’S NET PROFIT';

  @override
  String get sales => 'Sales';

  @override
  String get costsAndExpenses => 'Costs & expenses';

  @override
  String get todaysActivity => 'Today’s activity';

  @override
  String entriesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '$count entry',
      zero: 'No entries',
    );
    return '$_temp0';
  }

  @override
  String get noSalesTitle => 'No sales logged yet';

  @override
  String get noSalesMessage => 'Add your first sale to start tracking profit.';

  @override
  String get thisWeek => 'This week';

  @override
  String get reportSubtitle => 'Understand how your business is doing.';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get netProfit => 'Net profit';

  @override
  String get totalSales => 'Total sales';

  @override
  String get fruitCost => 'Fruit cost';

  @override
  String get otherExpenses => 'Other expenses';

  @override
  String get entriesRecorded => 'Entries recorded';

  @override
  String get profitMargin => 'Profit margin';

  @override
  String get periodEntries => 'Entries in this period';

  @override
  String get noPeriodEntries =>
      'No entries for this period yet. Add a sale and your report will appear here.';

  @override
  String saleDetails(String date, String amount) {
    return '$date  ·  Sales $amount';
  }

  @override
  String get profit => 'profit';

  @override
  String get addSaleTitle => 'Add a sale';

  @override
  String get editEntryTitle => 'Edit entry';

  @override
  String get formIntro =>
      'Enter the fruit name, price per kilogram, and extra expenses.';

  @override
  String get date => 'Date';

  @override
  String get fruitName => 'Fruit or sale name';

  @override
  String get fruitHint => 'e.g. Apples';

  @override
  String get addFruitValidation => 'Add a fruit or sale name';

  @override
  String get salesAmount => 'Sales amount';

  @override
  String get pricePerKg => 'Price per kg';

  @override
  String get pricePerKgHint => 'What you charged for one kilogram';

  @override
  String get quantityKg => 'Quantity sold (kg)';

  @override
  String get quantityKgHint => 'For example, 2.5';

  @override
  String get confirmReceivedTitle => 'Confirm money received';

  @override
  String confirmReceivedMessage(String fruit) {
    return 'Enter the kilograms sold for $fruit.';
  }

  @override
  String get calculatedReceived => 'Calculated total received';

  @override
  String get continueToConfirm => 'Continue';

  @override
  String get confirmAndSave => 'Confirm and save';

  @override
  String get totalReceivedHint => 'Total money received';

  @override
  String get fruitCostHint => 'What you paid for the fruit';

  @override
  String get otherExpensesHint => 'Delivery, bags, or other costs';

  @override
  String get estimatedNetProfit => 'Estimated net profit';

  @override
  String get optionalNote => 'Note (optional)';

  @override
  String get noteHint => 'Anything you want to remember';

  @override
  String get saveEntry => 'Save entry';

  @override
  String get saveChanges => 'Save changes';

  @override
  String enterAmount(String field) {
    return 'Enter $field';
  }

  @override
  String get validAmount => 'Enter a valid amount';

  @override
  String get nonNegativeAmount => 'Amount cannot be negative';

  @override
  String get saveError => 'Could not save this entry. Please try again.';

  @override
  String currency(String amount) {
    return 'UZS $amount';
  }

  @override
  String get currencyPrefix => 'UZS';

  @override
  String periodRange(String start, String end) {
    return '$start – $end';
  }
}
