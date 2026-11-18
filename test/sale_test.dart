import 'package:flutter_test/flutter_test.dart';
import 'package:home_fruit_seller/main.dart';

void main() {
  group('sale calculations', () {
    test(
      'calculates received money and profit from price, weight, expenses',
      () {
        final sale = Sale(
          id: 1,
          date: DateTime(2026, 10, 12),
          fruit: 'Olma',
          revenue: 30000,
          pricePerKg: 12000,
          quantityKg: 2.5,
          cost: 0,
          expenses: 1000,
          note: '',
        );

        expect(sale.pricePerKg * sale.quantityKg, 30000);
        expect(sale.profit, 29000);
      },
    );

    test('round trips sale fields through the local database map', () {
      final original = Sale(
        id: 8,
        date: DateTime(2026, 10, 12),
        fruit: 'Uzum',
        revenue: 52500,
        pricePerKg: 17500,
        quantityKg: 3,
        cost: 0,
        expenses: 2500,
        note: 'Qo‘shni',
      );

      final restored = Sale.fromMap(original.toMap());
      expect(restored.id, original.id);
      expect(restored.date, original.date);
      expect(restored.fruit, original.fruit);
      expect(restored.revenue, original.revenue);
      expect(restored.pricePerKg, original.pricePerKg);
      expect(restored.quantityKg, original.quantityKg);
      expect(restored.expenses, original.expenses);
      expect(restored.note, original.note);
    });
  });

  group('amount input parsing', () {
    test('accepts decimal commas and grouped currency amounts', () {
      expect(numberOrNull('2,5'), 2.5);
      expect(numberOrNull('12,000.50'), 12000.5);
      expect(numberOrNull(' 1\u202f200 '), 1200);
    });

    test('rejects invalid and non-finite amounts', () {
      expect(numberOrNull('not a number'), isNull);
      expect(numberOrNull('Infinity'), isNull);
      expect(numberOrNull('NaN'), isNull);
    });
  });
}
