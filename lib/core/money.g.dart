// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Money _$MoneyFromJson(Map<String, dynamic> json) => Money(
  minor: (json['minor'] as num).toInt(),
  currency: json['currency'] as String,
);

Map<String, dynamic> _$MoneyToJson(Money instance) => <String, dynamic>{
  'minor': instance.minor,
  'currency': instance.currency,
};
