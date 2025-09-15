import 'package:json_annotation/json_annotation.dart';
import '../../ui/components/money.dart';

/// JSON converter for Money type
class MoneyConverter implements JsonConverter<Money, Map<String, dynamic>> {
  const MoneyConverter();

  @override
  Money fromJson(Map<String, dynamic> json) {
    return Money(
      valueMinor: json['valueMinor'] as int,
      currency: json['currency'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(Money money) {
    return {'valueMinor': money.valueMinor, 'currency': money.currency};
  }
}

