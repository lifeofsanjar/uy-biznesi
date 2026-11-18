import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:home_fruit_seller/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('records a sale, reports its profit, and removes test data', (
    tester,
  ) async {
    final testFruit = 'Codex QA ${DateTime.now().microsecondsSinceEpoch}';
    await tester.pumpWidget(const FruitLedgerApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Uy biznesi'), findsOneWidget);
    await _deleteTestEntries(tester);
    await tester.tap(find.text('Yozuv qo‘shish'));
    await tester.pumpAndSettle();

    final formFields = find.byType(TextFormField);
    expect(formFields, findsNWidgets(4));
    await tester.enterText(formFields.at(0), testFruit);
    await tester.enterText(formFields.at(1), '12000');
    await tester.enterText(formFields.at(2), '1000');
    await tester.tap(find.text('Davom etish'));
    await tester.pumpAndSettle();

    final quantityField = find.byType(TextField).last;
    await tester.enterText(quantityField, '2.5');
    await tester.pumpAndSettle();
    expect(
      _textDisplaysAmount(tester, 30000),
      findsOneWidget,
      reason:
          'The confirmation should show price per kg multiplied by kilograms.',
    );
    await tester.tap(find.text('Tasdiqlash va saqlash'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text(testFruit), findsOneWidget);
    expect(_textDisplaysAmount(tester, 29000), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();
    final editFields = find.byType(TextFormField);
    expect(editFields, findsNWidgets(4));
    await tester.enterText(editFields.at(2), '2000');
    await tester.tap(find.text('Davom etish'));
    await tester.pumpAndSettle();
    expect(
      _textDisplaysAmount(tester, 30000),
      findsAtLeastNWidgets(1),
      reason: 'Editing should keep the saved kilogram quantity.',
    );
    await tester.tap(find.text('Tasdiqlash va saqlash'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(_textDisplaysAmount(tester, 28000), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Hisobotlar'));
    await tester.pumpAndSettle();
    expect(_textDisplaysAmount(tester, 28000), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Bugun'));
    await tester.pumpAndSettle();
    await _deleteTestEntries(tester);
    expect(find.text(testFruit), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _deleteTestEntries(WidgetTester tester) async {
  final entries = find.byWidgetPredicate((widget) {
    if (widget is! Text) return false;
    final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
    return RegExp(r'^Codex QA \d+$').hasMatch(text);
  });
  while (entries.evaluate().isNotEmpty) {
    await tester.longPress(entries.first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('O‘chirish'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}

Finder _textDisplaysAmount(WidgetTester tester, int amount) =>
    find.byWidgetPredicate((widget) {
      if (widget is! Text) return false;
      final visible = widget.data ?? widget.textSpan?.toPlainText() ?? '';
      return visible.replaceAll(RegExp(r'[^0-9]'), '') == '$amount';
    });
