import 'package:flutter_test/flutter_test.dart';
import 'package:yole_final/core/money.dart';

void main() {
  group('Money', () {
    test('should create Money from major units', () {
      final money = Money.fromMajor(100.50, 'USD');
      expect(money.minor, 10050);
      expect(money.currency, 'USD');
      expect(money.major, 100.50);
    });

    test('should create Money from minor units', () {
      final money = Money.fromMinor(10050, 'USD');
      expect(money.minor, 10050);
      expect(money.currency, 'USD');
      expect(money.major, 100.50);
    });

    test('should return correct currency symbols', () {
      expect(Money.fromMajor(100, 'USD').symbol, '\$');
      expect(Money.fromMajor(100, 'EUR').symbol, '€');
      expect(Money.fromMajor(100, 'GBP').symbol, '£');
      expect(Money.fromMajor(100, 'KES').symbol, 'KSh');
      expect(Money.fromMajor(100, 'NGN').symbol, '₦');
      expect(Money.fromMajor(100, 'UNKNOWN').symbol, 'UNKNOWN');
    });

    test('should format money correctly', () {
      expect(Money.fromMajor(100, 'USD').formatted, '\$100');
      expect(Money.fromMajor(100.50, 'USD').formatted, '\$100.50');
      expect(Money.fromMajor(0, 'USD').formatted, '\$0');
      expect(Money.fromMajor(0.01, 'USD').formatted, '\$0.01');
    });

    test('should format abbreviated money correctly', () {
      expect(Money.fromMajor(1000, 'USD').abbreviated, '\$1.0K');
      expect(Money.fromMajor(1500, 'USD').abbreviated, '\$1.5K');
      expect(Money.fromMajor(1000000, 'USD').abbreviated, '\$1.0M');
      expect(Money.fromMajor(1500000, 'USD').abbreviated, '\$1.5M');
      expect(Money.fromMajor(100, 'USD').abbreviated, '\$100');
      expect(Money.fromMajor(50000, 'USD').abbreviated, '\$50.0K');
    });

    test('should perform arithmetic operations', () {
      final money1 = Money.fromMajor(100, 'USD');
      final money2 = Money.fromMajor(50, 'USD');

      expect((money1 + money2).major, 150.0);
      expect((money1 - money2).major, 50.0);
      expect((money1 * 2).major, 200.0);
      expect((money1 / 2).major, 50.0);
    });

    test('should throw error for different currencies in arithmetic', () {
      final usdMoney = Money.fromMajor(100, 'USD');
      final eurMoney = Money.fromMajor(50, 'EUR');

      expect(() => usdMoney + eurMoney, throwsA(isA<ArgumentError>()));
      expect(() => usdMoney - eurMoney, throwsA(isA<ArgumentError>()));
    });

    test('should compare amounts correctly', () {
      final money1 = Money.fromMajor(100, 'USD');
      final money2 = Money.fromMajor(50, 'USD');
      final money3 = Money.fromMajor(100, 'USD');

      expect(money1 > money2, true);
      expect(money1 < money2, false);
      expect(money1 >= money3, true);
      expect(money1 <= money3, true);
      expect(money1 == money3, true);
    });

    test('should check amount properties', () {
      expect(Money.fromMajor(0, 'USD').isZero, true);
      expect(Money.fromMajor(100, 'USD').isZero, false);
      expect(Money.fromMajor(100, 'USD').isPositive, true);
      expect(Money.fromMajor(-100, 'USD').isPositive, false);
      expect(Money.fromMajor(-100, 'USD').isNegative, true);
      expect(Money.fromMajor(100, 'USD').isNegative, false);
    });

    test('should return absolute value', () {
      final negativeMoney = Money.fromMajor(-100, 'USD');
      expect(negativeMoney.abs.major, 100.0);
      expect(negativeMoney.abs.currency, 'USD');
    });
  });

  group('formatMoney', () {
    test('should format basic amounts', () {
      final money = Money.fromMajor(123.45, 'USD');
      expect(formatMoney(money), '\$123.45');
    });

    test('should format whole numbers without decimals', () {
      final money = Money.fromMajor(100, 'USD');
      expect(formatMoney(money), '\$100');
    });

    test('should format zero amount', () {
      final money = Money.fromMajor(0, 'USD');
      expect(formatMoney(money), '\$0');
    });

    test('should format small amounts', () {
      final money = Money.fromMajor(0.01, 'USD');
      expect(formatMoney(money), '\$0.01');
    });

    test('should format large amounts without abbreviation', () {
      final money = Money.fromMajor(999999, 'USD');
      expect(formatMoney(money), '\$999999');
    });

    test('should format abbreviated amounts', () {
      final money1K = Money.fromMajor(1000, 'USD');
      final money1_5K = Money.fromMajor(1500, 'USD');
      final money1M = Money.fromMajor(1000000, 'USD');
      final money1_5M = Money.fromMajor(1500000, 'USD');

      expect(formatMoney(money1K, abbrev: true), '\$1.0K');
      expect(formatMoney(money1_5K, abbrev: true), '\$1.5K');
      expect(formatMoney(money1M, abbrev: true), '\$1.0M');
      expect(formatMoney(money1_5M, abbrev: true), '\$1.5M');
    });

    test('should format different currencies', () {
      expect(formatMoney(Money.fromMajor(100, 'EUR')), '€100');
      expect(formatMoney(Money.fromMajor(100, 'GBP')), '£100');
      expect(formatMoney(Money.fromMajor(100, 'KES')), 'KSh100');
      expect(formatMoney(Money.fromMajor(100, 'NGN')), '₦100');
    });

    test('should handle edge cases for abbreviations', () {
      final money999 = Money.fromMajor(999, 'USD');
      final money1000 = Money.fromMajor(1000, 'USD');
      final money999999 = Money.fromMajor(999999, 'USD');
      final money1000000 = Money.fromMajor(1000000, 'USD');

      expect(formatMoney(money999, abbrev: true), '\$999');
      expect(formatMoney(money1000, abbrev: true), '\$1.0K');
      expect(formatMoney(money999999, abbrev: true), '\$1000.0K');
      expect(formatMoney(money1000000, abbrev: true), '\$1.0M');
    });

    test('should handle very large amounts', () {
      final money10M = Money.fromMajor(10000000, 'USD');
      final money100M = Money.fromMajor(100000000, 'USD');

      expect(formatMoney(money10M, abbrev: true), '\$10.0M');
      expect(formatMoney(money100M, abbrev: true), '\$100.0M');
    });

    test('should handle decimal precision in abbreviations', () {
      final money1234 = Money.fromMajor(1234, 'USD');
      final money12345 = Money.fromMajor(12345, 'USD');
      final money1234567 = Money.fromMajor(1234567, 'USD');

      expect(formatMoney(money1234, abbrev: true), '\$1.2K');
      expect(formatMoney(money12345, abbrev: true), '\$12.3K');
      expect(formatMoney(money1234567, abbrev: true), '\$1.2M');
    });
  });

  group('parseMoney', () {
    test('should parse USD amounts', () {
      expect(parseMoney('\$123.45'), Money.fromMajor(123.45, 'USD'));
      expect(parseMoney('\$100'), Money.fromMajor(100, 'USD'));
      expect(parseMoney('\$0.01'), Money.fromMajor(0.01, 'USD'));
    });

    test('should parse EUR amounts', () {
      expect(parseMoney('€123.45'), Money.fromMajor(123.45, 'EUR'));
      expect(parseMoney('€100'), Money.fromMajor(100, 'EUR'));
    });

    test('should parse GBP amounts', () {
      expect(parseMoney('£123.45'), Money.fromMajor(123.45, 'GBP'));
      expect(parseMoney('£100'), Money.fromMajor(100, 'GBP'));
    });

    test('should parse KES amounts', () {
      expect(parseMoney('KSh 123.45'), Money.fromMajor(123.45, 'KES'));
      expect(parseMoney('KSh 100'), Money.fromMajor(100, 'KES'));
    });

    test('should parse NGN amounts', () {
      expect(parseMoney('₦123.45'), Money.fromMajor(123.45, 'NGN'));
      expect(parseMoney('₦100'), Money.fromMajor(100, 'NGN'));
    });

    test('should parse amounts with currency at end', () {
      expect(parseMoney('123.45 USD'), Money.fromMajor(123.45, 'USD'));
      expect(parseMoney('100 EUR'), Money.fromMajor(100, 'EUR'));
    });

    test('should throw error for invalid input', () {
      expect(() => parseMoney('invalid'), throwsA(isA<FormatException>()));
      expect(() => parseMoney(''), throwsA(isA<FormatException>()));
      expect(() => parseMoney('abc USD'), throwsA(isA<FormatException>()));
    });
  });

  group('MoneyConstants', () {
    test('should provide zero amounts for different currencies', () {
      expect(MoneyConstants.zeroUSD.currency, 'USD');
      expect(MoneyConstants.zeroUSD.minor, 0);
      expect(MoneyConstants.zeroEUR.currency, 'EUR');
      expect(MoneyConstants.zeroEUR.minor, 0);
      expect(MoneyConstants.zeroGBP.currency, 'GBP');
      expect(MoneyConstants.zeroGBP.minor, 0);
      expect(MoneyConstants.zeroKES.currency, 'KES');
      expect(MoneyConstants.zeroKES.minor, 0);
      expect(MoneyConstants.zeroNGN.currency, 'NGN');
      expect(MoneyConstants.zeroNGN.minor, 0);
    });

    test('should create zero amount for any currency', () {
      final zeroCAD = MoneyConstants.zero('CAD');
      expect(zeroCAD.currency, 'CAD');
      expect(zeroCAD.minor, 0);
    });
  });
}
