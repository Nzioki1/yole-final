/// Money model for handling currency values
///
/// This model represents a monetary value with a currency code.
/// The value is stored in minor units (e.g., cents for USD) to avoid
/// floating point precision issues.
library;

import '../../core/money.dart' as core;

/// Re-export the core Money class for backward compatibility
export '../../core/money.dart';

/// Legacy Money class that wraps the core Money class
@Deprecated('Use core.Money directly instead')
class Money {
  final core.Money _money;

  Money({required int valueMinor, required String currency})
    : _money = core.Money(minor: valueMinor, currency: currency);

  int get valueMinor => _money.minor;
  String get currency => _money.currency;

  factory Money.fromMajor(double value, String currency) {
    return Money(
      valueMinor: core.Money.fromMajor(value, currency).minor,
      currency: currency,
    );
  }

  double get valueMajor => _money.major;

  String format({bool showCurrency = true, bool abbreviate = false}) {
    return core.formatMoney(_money, abbrev: abbreviate);
  }

  Money copyWith({int? valueMinor, String? currency}) {
    return Money(
      valueMinor: valueMinor ?? this.valueMinor,
      currency: currency ?? this.currency,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Money &&
        other.valueMinor == valueMinor &&
        other.currency == currency;
  }

  @override
  int get hashCode => valueMinor.hashCode ^ currency.hashCode;

  @override
  String toString() => 'Money(valueMinor: $valueMinor, currency: $currency)';
}
