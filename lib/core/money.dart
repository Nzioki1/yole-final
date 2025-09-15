/// Core Money class for handling currency amounts
///
/// This class represents monetary amounts with proper precision handling
/// using minor units (cents) to avoid floating-point precision issues.
library;

import 'package:json_annotation/json_annotation.dart';

part 'money.g.dart';

/// Represents a monetary amount with currency
@JsonSerializable()
class Money {
  const Money({required this.minor, required this.currency});

  /// Amount in minor units (cents)
  final int minor;

  /// ISO currency code (USD, EUR, etc.)
  final String currency;

  /// Create Money from major units (dollars)
  factory Money.fromMajor(double major, String currency) {
    return Money(minor: (major * 100).round(), currency: currency);
  }

  /// Create Money from minor units (cents)
  factory Money.fromMinor(int minor, String currency) {
    return Money(minor: minor, currency: currency);
  }

  /// Get amount in major units (dollars)
  double get major => minor / 100.0;

  /// Get currency symbol
  String get symbol {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'KES':
        return 'KSh';
      case 'NGN':
        return '₦';
      default:
        return currency;
    }
  }

  /// Get formatted amount string
  String get formatted {
    return formatMoney(this);
  }

  /// Get abbreviated formatted amount (e.g., $1.2K, $1.5M)
  String get abbreviated {
    return formatMoney(this, abbrev: true);
  }

  /// Add another Money amount (must be same currency)
  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Cannot add different currencies: $currency + ${other.currency}',
      );
    }
    return Money(minor: minor + other.minor, currency: currency);
  }

  /// Subtract another Money amount (must be same currency)
  Money operator -(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Cannot subtract different currencies: $currency - ${other.currency}',
      );
    }
    return Money(minor: minor - other.minor, currency: currency);
  }

  /// Multiply by a factor
  Money operator *(double factor) {
    return Money(minor: (minor * factor).round(), currency: currency);
  }

  /// Divide by a factor
  Money operator /(double factor) {
    if (factor == 0) throw ArgumentError('Cannot divide by zero');
    return Money(minor: (minor / factor).round(), currency: currency);
  }

  /// Check if amount is zero
  bool get isZero => minor == 0;

  /// Check if amount is positive
  bool get isPositive => minor > 0;

  /// Check if amount is negative
  bool get isNegative => minor < 0;

  /// Get absolute value
  Money get abs => Money(minor: minor.abs(), currency: currency);

  /// Compare with another Money amount
  int compareTo(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Cannot compare different currencies: $currency vs ${other.currency}',
      );
    }
    return minor.compareTo(other.minor);
  }

  /// Check if this amount is greater than another
  bool operator >(Money other) => compareTo(other) > 0;

  /// Check if this amount is less than another
  bool operator <(Money other) => compareTo(other) < 0;

  /// Check if this amount is greater than or equal to another
  bool operator >=(Money other) => compareTo(other) >= 0;

  /// Check if this amount is less than or equal to another
  bool operator <=(Money other) => compareTo(other) <= 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Money && other.minor == minor && other.currency == currency;
  }

  @override
  int get hashCode => minor.hashCode ^ currency.hashCode;

  @override
  String toString() => 'Money(minor: $minor, currency: $currency)';

  /// Create Money from JSON
  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);

  /// Convert Money to JSON
  Map<String, dynamic> toJson() => _$MoneyToJson(this);
}

/// Format Money amount as string
String formatMoney(Money money, {bool abbrev = false}) {
  final amount = money.major;
  final symbol = money.symbol;

  if (abbrev) {
    if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    }
  }

  // Format with proper decimal places
  if (amount == amount.truncate()) {
    return '$symbol${amount.toInt()}';
  } else {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}

/// Parse Money from string (e.g., "$123.45", "€100", "KSh 500")
Money parseMoney(String input) {
  final cleanInput = input.trim();

  // Extract currency symbol and amount
  String? currency;
  String amountStr = cleanInput;

  if (cleanInput.startsWith('\$')) {
    currency = 'USD';
    amountStr = cleanInput.substring(1);
  } else if (cleanInput.startsWith('€')) {
    currency = 'EUR';
    amountStr = cleanInput.substring(1);
  } else if (cleanInput.startsWith('£')) {
    currency = 'GBP';
    amountStr = cleanInput.substring(1);
  } else if (cleanInput.startsWith('KSh')) {
    currency = 'KES';
    amountStr = cleanInput.substring(3);
  } else if (cleanInput.startsWith('₦')) {
    currency = 'NGN';
    amountStr = cleanInput.substring(1);
  } else {
    // Try to extract currency from end
    final parts = cleanInput.split(' ');
    if (parts.length == 2) {
      amountStr = parts[0];
      currency = parts[1];
    } else {
      throw FormatException('Unable to parse currency from: $input');
    }
  }

  final amount = double.tryParse(amountStr);
  if (amount == null) {
    throw FormatException('Unable to parse amount from: $amountStr');
  }

  return Money.fromMajor(amount, currency);
}

/// Common Money constants
class MoneyConstants {
  static const Money zeroUSD = Money(minor: 0, currency: 'USD');
  static const Money zeroEUR = Money(minor: 0, currency: 'EUR');
  static const Money zeroGBP = Money(minor: 0, currency: 'GBP');
  static const Money zeroKES = Money(minor: 0, currency: 'KES');
  static const Money zeroNGN = Money(minor: 0, currency: 'NGN');

  /// Get zero Money for a specific currency
  static Money zero(String currency) {
    return Money(minor: 0, currency: currency);
  }
}
