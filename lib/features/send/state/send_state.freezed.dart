// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipientInfo {

 String get id; String get name; String get phoneNumber; String? get email; NetworkType get networkType; String get networkName; String? get bankCode; String? get accountNumber; bool get isVerified; bool get isFavorite;
/// Create a copy of RecipientInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipientInfoCopyWith<RecipientInfo> get copyWith => _$RecipientInfoCopyWithImpl<RecipientInfo>(this as RecipientInfo, _$identity);

  /// Serializes this RecipientInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipientInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.networkType, networkType) || other.networkType == networkType)&&(identical(other.networkName, networkName) || other.networkName == networkName)&&(identical(other.bankCode, bankCode) || other.bankCode == bankCode)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,email,networkType,networkName,bankCode,accountNumber,isVerified,isFavorite);

@override
String toString() {
  return 'RecipientInfo(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, networkType: $networkType, networkName: $networkName, bankCode: $bankCode, accountNumber: $accountNumber, isVerified: $isVerified, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $RecipientInfoCopyWith<$Res>  {
  factory $RecipientInfoCopyWith(RecipientInfo value, $Res Function(RecipientInfo) _then) = _$RecipientInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phoneNumber, String? email, NetworkType networkType, String networkName, String? bankCode, String? accountNumber, bool isVerified, bool isFavorite
});




}
/// @nodoc
class _$RecipientInfoCopyWithImpl<$Res>
    implements $RecipientInfoCopyWith<$Res> {
  _$RecipientInfoCopyWithImpl(this._self, this._then);

  final RecipientInfo _self;
  final $Res Function(RecipientInfo) _then;

/// Create a copy of RecipientInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? email = freezed,Object? networkType = null,Object? networkName = null,Object? bankCode = freezed,Object? accountNumber = freezed,Object? isVerified = null,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,networkType: null == networkType ? _self.networkType : networkType // ignore: cast_nullable_to_non_nullable
as NetworkType,networkName: null == networkName ? _self.networkName : networkName // ignore: cast_nullable_to_non_nullable
as String,bankCode: freezed == bankCode ? _self.bankCode : bankCode // ignore: cast_nullable_to_non_nullable
as String?,accountNumber: freezed == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipientInfo].
extension RecipientInfoPatterns on RecipientInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipientInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipientInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipientInfo value)  $default,){
final _that = this;
switch (_that) {
case _RecipientInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipientInfo value)?  $default,){
final _that = this;
switch (_that) {
case _RecipientInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  String? email,  NetworkType networkType,  String networkName,  String? bankCode,  String? accountNumber,  bool isVerified,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipientInfo() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.email,_that.networkType,_that.networkName,_that.bankCode,_that.accountNumber,_that.isVerified,_that.isFavorite);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  String? email,  NetworkType networkType,  String networkName,  String? bankCode,  String? accountNumber,  bool isVerified,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _RecipientInfo():
return $default(_that.id,_that.name,_that.phoneNumber,_that.email,_that.networkType,_that.networkName,_that.bankCode,_that.accountNumber,_that.isVerified,_that.isFavorite);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phoneNumber,  String? email,  NetworkType networkType,  String networkName,  String? bankCode,  String? accountNumber,  bool isVerified,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _RecipientInfo() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.email,_that.networkType,_that.networkName,_that.bankCode,_that.accountNumber,_that.isVerified,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipientInfo implements RecipientInfo {
  const _RecipientInfo({required this.id, required this.name, required this.phoneNumber, required this.email, required this.networkType, required this.networkName, required this.bankCode, required this.accountNumber, this.isVerified = false, this.isFavorite = false});
  factory _RecipientInfo.fromJson(Map<String, dynamic> json) => _$RecipientInfoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phoneNumber;
@override final  String? email;
@override final  NetworkType networkType;
@override final  String networkName;
@override final  String? bankCode;
@override final  String? accountNumber;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  bool isFavorite;

/// Create a copy of RecipientInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipientInfoCopyWith<_RecipientInfo> get copyWith => __$RecipientInfoCopyWithImpl<_RecipientInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipientInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipientInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.networkType, networkType) || other.networkType == networkType)&&(identical(other.networkName, networkName) || other.networkName == networkName)&&(identical(other.bankCode, bankCode) || other.bankCode == bankCode)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,email,networkType,networkName,bankCode,accountNumber,isVerified,isFavorite);

@override
String toString() {
  return 'RecipientInfo(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, networkType: $networkType, networkName: $networkName, bankCode: $bankCode, accountNumber: $accountNumber, isVerified: $isVerified, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$RecipientInfoCopyWith<$Res> implements $RecipientInfoCopyWith<$Res> {
  factory _$RecipientInfoCopyWith(_RecipientInfo value, $Res Function(_RecipientInfo) _then) = __$RecipientInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phoneNumber, String? email, NetworkType networkType, String networkName, String? bankCode, String? accountNumber, bool isVerified, bool isFavorite
});




}
/// @nodoc
class __$RecipientInfoCopyWithImpl<$Res>
    implements _$RecipientInfoCopyWith<$Res> {
  __$RecipientInfoCopyWithImpl(this._self, this._then);

  final _RecipientInfo _self;
  final $Res Function(_RecipientInfo) _then;

/// Create a copy of RecipientInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? email = freezed,Object? networkType = null,Object? networkName = null,Object? bankCode = freezed,Object? accountNumber = freezed,Object? isVerified = null,Object? isFavorite = null,}) {
  return _then(_RecipientInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,networkType: null == networkType ? _self.networkType : networkType // ignore: cast_nullable_to_non_nullable
as NetworkType,networkName: null == networkName ? _self.networkName : networkName // ignore: cast_nullable_to_non_nullable
as String,bankCode: freezed == bankCode ? _self.bankCode : bankCode // ignore: cast_nullable_to_non_nullable
as String?,accountNumber: freezed == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NetworkInfo {

 String get id; String get name; NetworkType get type; String get country; String get currency; double get minAmount; double get maxAmount; double get feePercentage; double get fixedFee; int get processingTimeMinutes; bool get isActive; bool get isRecommended;
/// Create a copy of NetworkInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkInfoCopyWith<NetworkInfo> get copyWith => _$NetworkInfoCopyWithImpl<NetworkInfo>(this as NetworkInfo, _$identity);

  /// Serializes this NetworkInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.country, country) || other.country == country)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.minAmount, minAmount) || other.minAmount == minAmount)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount)&&(identical(other.feePercentage, feePercentage) || other.feePercentage == feePercentage)&&(identical(other.fixedFee, fixedFee) || other.fixedFee == fixedFee)&&(identical(other.processingTimeMinutes, processingTimeMinutes) || other.processingTimeMinutes == processingTimeMinutes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isRecommended, isRecommended) || other.isRecommended == isRecommended));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,country,currency,minAmount,maxAmount,feePercentage,fixedFee,processingTimeMinutes,isActive,isRecommended);

@override
String toString() {
  return 'NetworkInfo(id: $id, name: $name, type: $type, country: $country, currency: $currency, minAmount: $minAmount, maxAmount: $maxAmount, feePercentage: $feePercentage, fixedFee: $fixedFee, processingTimeMinutes: $processingTimeMinutes, isActive: $isActive, isRecommended: $isRecommended)';
}


}

/// @nodoc
abstract mixin class $NetworkInfoCopyWith<$Res>  {
  factory $NetworkInfoCopyWith(NetworkInfo value, $Res Function(NetworkInfo) _then) = _$NetworkInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, NetworkType type, String country, String currency, double minAmount, double maxAmount, double feePercentage, double fixedFee, int processingTimeMinutes, bool isActive, bool isRecommended
});




}
/// @nodoc
class _$NetworkInfoCopyWithImpl<$Res>
    implements $NetworkInfoCopyWith<$Res> {
  _$NetworkInfoCopyWithImpl(this._self, this._then);

  final NetworkInfo _self;
  final $Res Function(NetworkInfo) _then;

/// Create a copy of NetworkInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? country = null,Object? currency = null,Object? minAmount = null,Object? maxAmount = null,Object? feePercentage = null,Object? fixedFee = null,Object? processingTimeMinutes = null,Object? isActive = null,Object? isRecommended = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NetworkType,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,minAmount: null == minAmount ? _self.minAmount : minAmount // ignore: cast_nullable_to_non_nullable
as double,maxAmount: null == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as double,feePercentage: null == feePercentage ? _self.feePercentage : feePercentage // ignore: cast_nullable_to_non_nullable
as double,fixedFee: null == fixedFee ? _self.fixedFee : fixedFee // ignore: cast_nullable_to_non_nullable
as double,processingTimeMinutes: null == processingTimeMinutes ? _self.processingTimeMinutes : processingTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isRecommended: null == isRecommended ? _self.isRecommended : isRecommended // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkInfo].
extension NetworkInfoPatterns on NetworkInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkInfo value)  $default,){
final _that = this;
switch (_that) {
case _NetworkInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkInfo value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  NetworkType type,  String country,  String currency,  double minAmount,  double maxAmount,  double feePercentage,  double fixedFee,  int processingTimeMinutes,  bool isActive,  bool isRecommended)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkInfo() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.country,_that.currency,_that.minAmount,_that.maxAmount,_that.feePercentage,_that.fixedFee,_that.processingTimeMinutes,_that.isActive,_that.isRecommended);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  NetworkType type,  String country,  String currency,  double minAmount,  double maxAmount,  double feePercentage,  double fixedFee,  int processingTimeMinutes,  bool isActive,  bool isRecommended)  $default,) {final _that = this;
switch (_that) {
case _NetworkInfo():
return $default(_that.id,_that.name,_that.type,_that.country,_that.currency,_that.minAmount,_that.maxAmount,_that.feePercentage,_that.fixedFee,_that.processingTimeMinutes,_that.isActive,_that.isRecommended);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  NetworkType type,  String country,  String currency,  double minAmount,  double maxAmount,  double feePercentage,  double fixedFee,  int processingTimeMinutes,  bool isActive,  bool isRecommended)?  $default,) {final _that = this;
switch (_that) {
case _NetworkInfo() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.country,_that.currency,_that.minAmount,_that.maxAmount,_that.feePercentage,_that.fixedFee,_that.processingTimeMinutes,_that.isActive,_that.isRecommended);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkInfo implements NetworkInfo {
  const _NetworkInfo({required this.id, required this.name, required this.type, required this.country, required this.currency, this.minAmount = 0, this.maxAmount = 0, this.feePercentage = 0, this.fixedFee = 0, this.processingTimeMinutes = 0, this.isActive = true, this.isRecommended = false});
  factory _NetworkInfo.fromJson(Map<String, dynamic> json) => _$NetworkInfoFromJson(json);

@override final  String id;
@override final  String name;
@override final  NetworkType type;
@override final  String country;
@override final  String currency;
@override@JsonKey() final  double minAmount;
@override@JsonKey() final  double maxAmount;
@override@JsonKey() final  double feePercentage;
@override@JsonKey() final  double fixedFee;
@override@JsonKey() final  int processingTimeMinutes;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isRecommended;

/// Create a copy of NetworkInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkInfoCopyWith<_NetworkInfo> get copyWith => __$NetworkInfoCopyWithImpl<_NetworkInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.country, country) || other.country == country)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.minAmount, minAmount) || other.minAmount == minAmount)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount)&&(identical(other.feePercentage, feePercentage) || other.feePercentage == feePercentage)&&(identical(other.fixedFee, fixedFee) || other.fixedFee == fixedFee)&&(identical(other.processingTimeMinutes, processingTimeMinutes) || other.processingTimeMinutes == processingTimeMinutes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isRecommended, isRecommended) || other.isRecommended == isRecommended));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,country,currency,minAmount,maxAmount,feePercentage,fixedFee,processingTimeMinutes,isActive,isRecommended);

@override
String toString() {
  return 'NetworkInfo(id: $id, name: $name, type: $type, country: $country, currency: $currency, minAmount: $minAmount, maxAmount: $maxAmount, feePercentage: $feePercentage, fixedFee: $fixedFee, processingTimeMinutes: $processingTimeMinutes, isActive: $isActive, isRecommended: $isRecommended)';
}


}

/// @nodoc
abstract mixin class _$NetworkInfoCopyWith<$Res> implements $NetworkInfoCopyWith<$Res> {
  factory _$NetworkInfoCopyWith(_NetworkInfo value, $Res Function(_NetworkInfo) _then) = __$NetworkInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, NetworkType type, String country, String currency, double minAmount, double maxAmount, double feePercentage, double fixedFee, int processingTimeMinutes, bool isActive, bool isRecommended
});




}
/// @nodoc
class __$NetworkInfoCopyWithImpl<$Res>
    implements _$NetworkInfoCopyWith<$Res> {
  __$NetworkInfoCopyWithImpl(this._self, this._then);

  final _NetworkInfo _self;
  final $Res Function(_NetworkInfo) _then;

/// Create a copy of NetworkInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? country = null,Object? currency = null,Object? minAmount = null,Object? maxAmount = null,Object? feePercentage = null,Object? fixedFee = null,Object? processingTimeMinutes = null,Object? isActive = null,Object? isRecommended = null,}) {
  return _then(_NetworkInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NetworkType,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,minAmount: null == minAmount ? _self.minAmount : minAmount // ignore: cast_nullable_to_non_nullable
as double,maxAmount: null == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as double,feePercentage: null == feePercentage ? _self.feePercentage : feePercentage // ignore: cast_nullable_to_non_nullable
as double,fixedFee: null == fixedFee ? _self.fixedFee : fixedFee // ignore: cast_nullable_to_non_nullable
as double,processingTimeMinutes: null == processingTimeMinutes ? _self.processingTimeMinutes : processingTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isRecommended: null == isRecommended ? _self.isRecommended : isRecommended // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$FeeCalculation {

@MoneyConverter() Money get networkFee;@MoneyConverter() Money get platformFee;@MoneyConverter() Money get totalFee;@MoneyConverter() Money get totalAmount;@MoneyConverter() Money get recipientAmount; double get exchangeRate; String get exchangeRateSource; int get estimatedProcessingTimeMinutes;
/// Create a copy of FeeCalculation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeeCalculationCopyWith<FeeCalculation> get copyWith => _$FeeCalculationCopyWithImpl<FeeCalculation>(this as FeeCalculation, _$identity);

  /// Serializes this FeeCalculation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeeCalculation&&(identical(other.networkFee, networkFee) || other.networkFee == networkFee)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.totalFee, totalFee) || other.totalFee == totalFee)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.recipientAmount, recipientAmount) || other.recipientAmount == recipientAmount)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.exchangeRateSource, exchangeRateSource) || other.exchangeRateSource == exchangeRateSource)&&(identical(other.estimatedProcessingTimeMinutes, estimatedProcessingTimeMinutes) || other.estimatedProcessingTimeMinutes == estimatedProcessingTimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,networkFee,platformFee,totalFee,totalAmount,recipientAmount,exchangeRate,exchangeRateSource,estimatedProcessingTimeMinutes);

@override
String toString() {
  return 'FeeCalculation(networkFee: $networkFee, platformFee: $platformFee, totalFee: $totalFee, totalAmount: $totalAmount, recipientAmount: $recipientAmount, exchangeRate: $exchangeRate, exchangeRateSource: $exchangeRateSource, estimatedProcessingTimeMinutes: $estimatedProcessingTimeMinutes)';
}


}

/// @nodoc
abstract mixin class $FeeCalculationCopyWith<$Res>  {
  factory $FeeCalculationCopyWith(FeeCalculation value, $Res Function(FeeCalculation) _then) = _$FeeCalculationCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money networkFee,@MoneyConverter() Money platformFee,@MoneyConverter() Money totalFee,@MoneyConverter() Money totalAmount,@MoneyConverter() Money recipientAmount, double exchangeRate, String exchangeRateSource, int estimatedProcessingTimeMinutes
});




}
/// @nodoc
class _$FeeCalculationCopyWithImpl<$Res>
    implements $FeeCalculationCopyWith<$Res> {
  _$FeeCalculationCopyWithImpl(this._self, this._then);

  final FeeCalculation _self;
  final $Res Function(FeeCalculation) _then;

/// Create a copy of FeeCalculation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? networkFee = null,Object? platformFee = null,Object? totalFee = null,Object? totalAmount = null,Object? recipientAmount = null,Object? exchangeRate = null,Object? exchangeRateSource = null,Object? estimatedProcessingTimeMinutes = null,}) {
  return _then(_self.copyWith(
networkFee: null == networkFee ? _self.networkFee : networkFee // ignore: cast_nullable_to_non_nullable
as Money,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as Money,totalFee: null == totalFee ? _self.totalFee : totalFee // ignore: cast_nullable_to_non_nullable
as Money,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Money,recipientAmount: null == recipientAmount ? _self.recipientAmount : recipientAmount // ignore: cast_nullable_to_non_nullable
as Money,exchangeRate: null == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double,exchangeRateSource: null == exchangeRateSource ? _self.exchangeRateSource : exchangeRateSource // ignore: cast_nullable_to_non_nullable
as String,estimatedProcessingTimeMinutes: null == estimatedProcessingTimeMinutes ? _self.estimatedProcessingTimeMinutes : estimatedProcessingTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FeeCalculation].
extension FeeCalculationPatterns on FeeCalculation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeeCalculation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeeCalculation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeeCalculation value)  $default,){
final _that = this;
switch (_that) {
case _FeeCalculation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeeCalculation value)?  $default,){
final _that = this;
switch (_that) {
case _FeeCalculation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@MoneyConverter()  Money networkFee, @MoneyConverter()  Money platformFee, @MoneyConverter()  Money totalFee, @MoneyConverter()  Money totalAmount, @MoneyConverter()  Money recipientAmount,  double exchangeRate,  String exchangeRateSource,  int estimatedProcessingTimeMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeeCalculation() when $default != null:
return $default(_that.networkFee,_that.platformFee,_that.totalFee,_that.totalAmount,_that.recipientAmount,_that.exchangeRate,_that.exchangeRateSource,_that.estimatedProcessingTimeMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@MoneyConverter()  Money networkFee, @MoneyConverter()  Money platformFee, @MoneyConverter()  Money totalFee, @MoneyConverter()  Money totalAmount, @MoneyConverter()  Money recipientAmount,  double exchangeRate,  String exchangeRateSource,  int estimatedProcessingTimeMinutes)  $default,) {final _that = this;
switch (_that) {
case _FeeCalculation():
return $default(_that.networkFee,_that.platformFee,_that.totalFee,_that.totalAmount,_that.recipientAmount,_that.exchangeRate,_that.exchangeRateSource,_that.estimatedProcessingTimeMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@MoneyConverter()  Money networkFee, @MoneyConverter()  Money platformFee, @MoneyConverter()  Money totalFee, @MoneyConverter()  Money totalAmount, @MoneyConverter()  Money recipientAmount,  double exchangeRate,  String exchangeRateSource,  int estimatedProcessingTimeMinutes)?  $default,) {final _that = this;
switch (_that) {
case _FeeCalculation() when $default != null:
return $default(_that.networkFee,_that.platformFee,_that.totalFee,_that.totalAmount,_that.recipientAmount,_that.exchangeRate,_that.exchangeRateSource,_that.estimatedProcessingTimeMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeeCalculation implements FeeCalculation {
  const _FeeCalculation({@MoneyConverter() required this.networkFee, @MoneyConverter() required this.platformFee, @MoneyConverter() required this.totalFee, @MoneyConverter() required this.totalAmount, @MoneyConverter() required this.recipientAmount, this.exchangeRate = 0.0, this.exchangeRateSource = '', this.estimatedProcessingTimeMinutes = 0});
  factory _FeeCalculation.fromJson(Map<String, dynamic> json) => _$FeeCalculationFromJson(json);

@override@MoneyConverter() final  Money networkFee;
@override@MoneyConverter() final  Money platformFee;
@override@MoneyConverter() final  Money totalFee;
@override@MoneyConverter() final  Money totalAmount;
@override@MoneyConverter() final  Money recipientAmount;
@override@JsonKey() final  double exchangeRate;
@override@JsonKey() final  String exchangeRateSource;
@override@JsonKey() final  int estimatedProcessingTimeMinutes;

/// Create a copy of FeeCalculation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeeCalculationCopyWith<_FeeCalculation> get copyWith => __$FeeCalculationCopyWithImpl<_FeeCalculation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeeCalculationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeeCalculation&&(identical(other.networkFee, networkFee) || other.networkFee == networkFee)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.totalFee, totalFee) || other.totalFee == totalFee)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.recipientAmount, recipientAmount) || other.recipientAmount == recipientAmount)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.exchangeRateSource, exchangeRateSource) || other.exchangeRateSource == exchangeRateSource)&&(identical(other.estimatedProcessingTimeMinutes, estimatedProcessingTimeMinutes) || other.estimatedProcessingTimeMinutes == estimatedProcessingTimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,networkFee,platformFee,totalFee,totalAmount,recipientAmount,exchangeRate,exchangeRateSource,estimatedProcessingTimeMinutes);

@override
String toString() {
  return 'FeeCalculation(networkFee: $networkFee, platformFee: $platformFee, totalFee: $totalFee, totalAmount: $totalAmount, recipientAmount: $recipientAmount, exchangeRate: $exchangeRate, exchangeRateSource: $exchangeRateSource, estimatedProcessingTimeMinutes: $estimatedProcessingTimeMinutes)';
}


}

/// @nodoc
abstract mixin class _$FeeCalculationCopyWith<$Res> implements $FeeCalculationCopyWith<$Res> {
  factory _$FeeCalculationCopyWith(_FeeCalculation value, $Res Function(_FeeCalculation) _then) = __$FeeCalculationCopyWithImpl;
@override @useResult
$Res call({
@MoneyConverter() Money networkFee,@MoneyConverter() Money platformFee,@MoneyConverter() Money totalFee,@MoneyConverter() Money totalAmount,@MoneyConverter() Money recipientAmount, double exchangeRate, String exchangeRateSource, int estimatedProcessingTimeMinutes
});




}
/// @nodoc
class __$FeeCalculationCopyWithImpl<$Res>
    implements _$FeeCalculationCopyWith<$Res> {
  __$FeeCalculationCopyWithImpl(this._self, this._then);

  final _FeeCalculation _self;
  final $Res Function(_FeeCalculation) _then;

/// Create a copy of FeeCalculation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? networkFee = null,Object? platformFee = null,Object? totalFee = null,Object? totalAmount = null,Object? recipientAmount = null,Object? exchangeRate = null,Object? exchangeRateSource = null,Object? estimatedProcessingTimeMinutes = null,}) {
  return _then(_FeeCalculation(
networkFee: null == networkFee ? _self.networkFee : networkFee // ignore: cast_nullable_to_non_nullable
as Money,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as Money,totalFee: null == totalFee ? _self.totalFee : totalFee // ignore: cast_nullable_to_non_nullable
as Money,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Money,recipientAmount: null == recipientAmount ? _self.recipientAmount : recipientAmount // ignore: cast_nullable_to_non_nullable
as Money,exchangeRate: null == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double,exchangeRateSource: null == exchangeRateSource ? _self.exchangeRateSource : exchangeRateSource // ignore: cast_nullable_to_non_nullable
as String,estimatedProcessingTimeMinutes: null == estimatedProcessingTimeMinutes ? _self.estimatedProcessingTimeMinutes : estimatedProcessingTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SendState {

 SendStep get currentStep; List<SendStep> get completedSteps;// Recipient information
 RecipientInfo? get recipient; List<RecipientInfo> get recentRecipients; List<RecipientInfo> get favoriteRecipients; String get recipientSearchQuery; List<RecipientInfo> get searchResults;// Network selection
 NetworkInfo? get selectedNetwork; List<NetworkInfo> get availableNetworks; String? get networkError;// Amount and currency
@MoneyConverter() Money? get amount; String get fromCurrency; String get toCurrency; bool get showCurrencySelector;// Fee calculation
 FeeCalculation? get feeCalculation; bool get isCalculatingFees; String? get feeCalculationError;// Flow state
 bool get isLoading; bool get isSubmitting; String? get error; String? get transactionId;// Draft persistence
 bool get hasDraft; int get draftTimestamp;// Analytics
 int get stepViewCount; Map<String, dynamic> get analyticsData;
/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendStateCopyWith<SendState> get copyWith => _$SendStateCopyWithImpl<SendState>(this as SendState, _$identity);

  /// Serializes this SendState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&const DeepCollectionEquality().equals(other.completedSteps, completedSteps)&&(identical(other.recipient, recipient) || other.recipient == recipient)&&const DeepCollectionEquality().equals(other.recentRecipients, recentRecipients)&&const DeepCollectionEquality().equals(other.favoriteRecipients, favoriteRecipients)&&(identical(other.recipientSearchQuery, recipientSearchQuery) || other.recipientSearchQuery == recipientSearchQuery)&&const DeepCollectionEquality().equals(other.searchResults, searchResults)&&(identical(other.selectedNetwork, selectedNetwork) || other.selectedNetwork == selectedNetwork)&&const DeepCollectionEquality().equals(other.availableNetworks, availableNetworks)&&(identical(other.networkError, networkError) || other.networkError == networkError)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.fromCurrency, fromCurrency) || other.fromCurrency == fromCurrency)&&(identical(other.toCurrency, toCurrency) || other.toCurrency == toCurrency)&&(identical(other.showCurrencySelector, showCurrencySelector) || other.showCurrencySelector == showCurrencySelector)&&(identical(other.feeCalculation, feeCalculation) || other.feeCalculation == feeCalculation)&&(identical(other.isCalculatingFees, isCalculatingFees) || other.isCalculatingFees == isCalculatingFees)&&(identical(other.feeCalculationError, feeCalculationError) || other.feeCalculationError == feeCalculationError)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.error, error) || other.error == error)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.hasDraft, hasDraft) || other.hasDraft == hasDraft)&&(identical(other.draftTimestamp, draftTimestamp) || other.draftTimestamp == draftTimestamp)&&(identical(other.stepViewCount, stepViewCount) || other.stepViewCount == stepViewCount)&&const DeepCollectionEquality().equals(other.analyticsData, analyticsData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,currentStep,const DeepCollectionEquality().hash(completedSteps),recipient,const DeepCollectionEquality().hash(recentRecipients),const DeepCollectionEquality().hash(favoriteRecipients),recipientSearchQuery,const DeepCollectionEquality().hash(searchResults),selectedNetwork,const DeepCollectionEquality().hash(availableNetworks),networkError,amount,fromCurrency,toCurrency,showCurrencySelector,feeCalculation,isCalculatingFees,feeCalculationError,isLoading,isSubmitting,error,transactionId,hasDraft,draftTimestamp,stepViewCount,const DeepCollectionEquality().hash(analyticsData)]);

@override
String toString() {
  return 'SendState(currentStep: $currentStep, completedSteps: $completedSteps, recipient: $recipient, recentRecipients: $recentRecipients, favoriteRecipients: $favoriteRecipients, recipientSearchQuery: $recipientSearchQuery, searchResults: $searchResults, selectedNetwork: $selectedNetwork, availableNetworks: $availableNetworks, networkError: $networkError, amount: $amount, fromCurrency: $fromCurrency, toCurrency: $toCurrency, showCurrencySelector: $showCurrencySelector, feeCalculation: $feeCalculation, isCalculatingFees: $isCalculatingFees, feeCalculationError: $feeCalculationError, isLoading: $isLoading, isSubmitting: $isSubmitting, error: $error, transactionId: $transactionId, hasDraft: $hasDraft, draftTimestamp: $draftTimestamp, stepViewCount: $stepViewCount, analyticsData: $analyticsData)';
}


}

/// @nodoc
abstract mixin class $SendStateCopyWith<$Res>  {
  factory $SendStateCopyWith(SendState value, $Res Function(SendState) _then) = _$SendStateCopyWithImpl;
@useResult
$Res call({
 SendStep currentStep, List<SendStep> completedSteps, RecipientInfo? recipient, List<RecipientInfo> recentRecipients, List<RecipientInfo> favoriteRecipients, String recipientSearchQuery, List<RecipientInfo> searchResults, NetworkInfo? selectedNetwork, List<NetworkInfo> availableNetworks, String? networkError,@MoneyConverter() Money? amount, String fromCurrency, String toCurrency, bool showCurrencySelector, FeeCalculation? feeCalculation, bool isCalculatingFees, String? feeCalculationError, bool isLoading, bool isSubmitting, String? error, String? transactionId, bool hasDraft, int draftTimestamp, int stepViewCount, Map<String, dynamic> analyticsData
});


$RecipientInfoCopyWith<$Res>? get recipient;$NetworkInfoCopyWith<$Res>? get selectedNetwork;$FeeCalculationCopyWith<$Res>? get feeCalculation;

}
/// @nodoc
class _$SendStateCopyWithImpl<$Res>
    implements $SendStateCopyWith<$Res> {
  _$SendStateCopyWithImpl(this._self, this._then);

  final SendState _self;
  final $Res Function(SendState) _then;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? completedSteps = null,Object? recipient = freezed,Object? recentRecipients = null,Object? favoriteRecipients = null,Object? recipientSearchQuery = null,Object? searchResults = null,Object? selectedNetwork = freezed,Object? availableNetworks = null,Object? networkError = freezed,Object? amount = freezed,Object? fromCurrency = null,Object? toCurrency = null,Object? showCurrencySelector = null,Object? feeCalculation = freezed,Object? isCalculatingFees = null,Object? feeCalculationError = freezed,Object? isLoading = null,Object? isSubmitting = null,Object? error = freezed,Object? transactionId = freezed,Object? hasDraft = null,Object? draftTimestamp = null,Object? stepViewCount = null,Object? analyticsData = null,}) {
  return _then(_self.copyWith(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as SendStep,completedSteps: null == completedSteps ? _self.completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<SendStep>,recipient: freezed == recipient ? _self.recipient : recipient // ignore: cast_nullable_to_non_nullable
as RecipientInfo?,recentRecipients: null == recentRecipients ? _self.recentRecipients : recentRecipients // ignore: cast_nullable_to_non_nullable
as List<RecipientInfo>,favoriteRecipients: null == favoriteRecipients ? _self.favoriteRecipients : favoriteRecipients // ignore: cast_nullable_to_non_nullable
as List<RecipientInfo>,recipientSearchQuery: null == recipientSearchQuery ? _self.recipientSearchQuery : recipientSearchQuery // ignore: cast_nullable_to_non_nullable
as String,searchResults: null == searchResults ? _self.searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<RecipientInfo>,selectedNetwork: freezed == selectedNetwork ? _self.selectedNetwork : selectedNetwork // ignore: cast_nullable_to_non_nullable
as NetworkInfo?,availableNetworks: null == availableNetworks ? _self.availableNetworks : availableNetworks // ignore: cast_nullable_to_non_nullable
as List<NetworkInfo>,networkError: freezed == networkError ? _self.networkError : networkError // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money?,fromCurrency: null == fromCurrency ? _self.fromCurrency : fromCurrency // ignore: cast_nullable_to_non_nullable
as String,toCurrency: null == toCurrency ? _self.toCurrency : toCurrency // ignore: cast_nullable_to_non_nullable
as String,showCurrencySelector: null == showCurrencySelector ? _self.showCurrencySelector : showCurrencySelector // ignore: cast_nullable_to_non_nullable
as bool,feeCalculation: freezed == feeCalculation ? _self.feeCalculation : feeCalculation // ignore: cast_nullable_to_non_nullable
as FeeCalculation?,isCalculatingFees: null == isCalculatingFees ? _self.isCalculatingFees : isCalculatingFees // ignore: cast_nullable_to_non_nullable
as bool,feeCalculationError: freezed == feeCalculationError ? _self.feeCalculationError : feeCalculationError // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,hasDraft: null == hasDraft ? _self.hasDraft : hasDraft // ignore: cast_nullable_to_non_nullable
as bool,draftTimestamp: null == draftTimestamp ? _self.draftTimestamp : draftTimestamp // ignore: cast_nullable_to_non_nullable
as int,stepViewCount: null == stepViewCount ? _self.stepViewCount : stepViewCount // ignore: cast_nullable_to_non_nullable
as int,analyticsData: null == analyticsData ? _self.analyticsData : analyticsData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipientInfoCopyWith<$Res>? get recipient {
    if (_self.recipient == null) {
    return null;
  }

  return $RecipientInfoCopyWith<$Res>(_self.recipient!, (value) {
    return _then(_self.copyWith(recipient: value));
  });
}/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkInfoCopyWith<$Res>? get selectedNetwork {
    if (_self.selectedNetwork == null) {
    return null;
  }

  return $NetworkInfoCopyWith<$Res>(_self.selectedNetwork!, (value) {
    return _then(_self.copyWith(selectedNetwork: value));
  });
}/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeeCalculationCopyWith<$Res>? get feeCalculation {
    if (_self.feeCalculation == null) {
    return null;
  }

  return $FeeCalculationCopyWith<$Res>(_self.feeCalculation!, (value) {
    return _then(_self.copyWith(feeCalculation: value));
  });
}
}


/// Adds pattern-matching-related methods to [SendState].
extension SendStatePatterns on SendState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendState value)  $default,){
final _that = this;
switch (_that) {
case _SendState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendState value)?  $default,){
final _that = this;
switch (_that) {
case _SendState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SendStep currentStep,  List<SendStep> completedSteps,  RecipientInfo? recipient,  List<RecipientInfo> recentRecipients,  List<RecipientInfo> favoriteRecipients,  String recipientSearchQuery,  List<RecipientInfo> searchResults,  NetworkInfo? selectedNetwork,  List<NetworkInfo> availableNetworks,  String? networkError, @MoneyConverter()  Money? amount,  String fromCurrency,  String toCurrency,  bool showCurrencySelector,  FeeCalculation? feeCalculation,  bool isCalculatingFees,  String? feeCalculationError,  bool isLoading,  bool isSubmitting,  String? error,  String? transactionId,  bool hasDraft,  int draftTimestamp,  int stepViewCount,  Map<String, dynamic> analyticsData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendState() when $default != null:
return $default(_that.currentStep,_that.completedSteps,_that.recipient,_that.recentRecipients,_that.favoriteRecipients,_that.recipientSearchQuery,_that.searchResults,_that.selectedNetwork,_that.availableNetworks,_that.networkError,_that.amount,_that.fromCurrency,_that.toCurrency,_that.showCurrencySelector,_that.feeCalculation,_that.isCalculatingFees,_that.feeCalculationError,_that.isLoading,_that.isSubmitting,_that.error,_that.transactionId,_that.hasDraft,_that.draftTimestamp,_that.stepViewCount,_that.analyticsData);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SendStep currentStep,  List<SendStep> completedSteps,  RecipientInfo? recipient,  List<RecipientInfo> recentRecipients,  List<RecipientInfo> favoriteRecipients,  String recipientSearchQuery,  List<RecipientInfo> searchResults,  NetworkInfo? selectedNetwork,  List<NetworkInfo> availableNetworks,  String? networkError, @MoneyConverter()  Money? amount,  String fromCurrency,  String toCurrency,  bool showCurrencySelector,  FeeCalculation? feeCalculation,  bool isCalculatingFees,  String? feeCalculationError,  bool isLoading,  bool isSubmitting,  String? error,  String? transactionId,  bool hasDraft,  int draftTimestamp,  int stepViewCount,  Map<String, dynamic> analyticsData)  $default,) {final _that = this;
switch (_that) {
case _SendState():
return $default(_that.currentStep,_that.completedSteps,_that.recipient,_that.recentRecipients,_that.favoriteRecipients,_that.recipientSearchQuery,_that.searchResults,_that.selectedNetwork,_that.availableNetworks,_that.networkError,_that.amount,_that.fromCurrency,_that.toCurrency,_that.showCurrencySelector,_that.feeCalculation,_that.isCalculatingFees,_that.feeCalculationError,_that.isLoading,_that.isSubmitting,_that.error,_that.transactionId,_that.hasDraft,_that.draftTimestamp,_that.stepViewCount,_that.analyticsData);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SendStep currentStep,  List<SendStep> completedSteps,  RecipientInfo? recipient,  List<RecipientInfo> recentRecipients,  List<RecipientInfo> favoriteRecipients,  String recipientSearchQuery,  List<RecipientInfo> searchResults,  NetworkInfo? selectedNetwork,  List<NetworkInfo> availableNetworks,  String? networkError, @MoneyConverter()  Money? amount,  String fromCurrency,  String toCurrency,  bool showCurrencySelector,  FeeCalculation? feeCalculation,  bool isCalculatingFees,  String? feeCalculationError,  bool isLoading,  bool isSubmitting,  String? error,  String? transactionId,  bool hasDraft,  int draftTimestamp,  int stepViewCount,  Map<String, dynamic> analyticsData)?  $default,) {final _that = this;
switch (_that) {
case _SendState() when $default != null:
return $default(_that.currentStep,_that.completedSteps,_that.recipient,_that.recentRecipients,_that.favoriteRecipients,_that.recipientSearchQuery,_that.searchResults,_that.selectedNetwork,_that.availableNetworks,_that.networkError,_that.amount,_that.fromCurrency,_that.toCurrency,_that.showCurrencySelector,_that.feeCalculation,_that.isCalculatingFees,_that.feeCalculationError,_that.isLoading,_that.isSubmitting,_that.error,_that.transactionId,_that.hasDraft,_that.draftTimestamp,_that.stepViewCount,_that.analyticsData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendState implements SendState {
  const _SendState({this.currentStep = SendStep.start, final  List<SendStep> completedSteps = const [], this.recipient, final  List<RecipientInfo> recentRecipients = const [], final  List<RecipientInfo> favoriteRecipients = const [], this.recipientSearchQuery = '', final  List<RecipientInfo> searchResults = const [], this.selectedNetwork, final  List<NetworkInfo> availableNetworks = const [], this.networkError, @MoneyConverter() this.amount, this.fromCurrency = 'USD', this.toCurrency = 'USD', this.showCurrencySelector = false, this.feeCalculation, this.isCalculatingFees = false, this.feeCalculationError, this.isLoading = false, this.isSubmitting = false, this.error, this.transactionId, this.hasDraft = false, this.draftTimestamp = 0, this.stepViewCount = 0, final  Map<String, dynamic> analyticsData = const {}}): _completedSteps = completedSteps,_recentRecipients = recentRecipients,_favoriteRecipients = favoriteRecipients,_searchResults = searchResults,_availableNetworks = availableNetworks,_analyticsData = analyticsData;
  factory _SendState.fromJson(Map<String, dynamic> json) => _$SendStateFromJson(json);

@override@JsonKey() final  SendStep currentStep;
 final  List<SendStep> _completedSteps;
@override@JsonKey() List<SendStep> get completedSteps {
  if (_completedSteps is EqualUnmodifiableListView) return _completedSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedSteps);
}

// Recipient information
@override final  RecipientInfo? recipient;
 final  List<RecipientInfo> _recentRecipients;
@override@JsonKey() List<RecipientInfo> get recentRecipients {
  if (_recentRecipients is EqualUnmodifiableListView) return _recentRecipients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentRecipients);
}

 final  List<RecipientInfo> _favoriteRecipients;
@override@JsonKey() List<RecipientInfo> get favoriteRecipients {
  if (_favoriteRecipients is EqualUnmodifiableListView) return _favoriteRecipients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteRecipients);
}

@override@JsonKey() final  String recipientSearchQuery;
 final  List<RecipientInfo> _searchResults;
@override@JsonKey() List<RecipientInfo> get searchResults {
  if (_searchResults is EqualUnmodifiableListView) return _searchResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchResults);
}

// Network selection
@override final  NetworkInfo? selectedNetwork;
 final  List<NetworkInfo> _availableNetworks;
@override@JsonKey() List<NetworkInfo> get availableNetworks {
  if (_availableNetworks is EqualUnmodifiableListView) return _availableNetworks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableNetworks);
}

@override final  String? networkError;
// Amount and currency
@override@MoneyConverter() final  Money? amount;
@override@JsonKey() final  String fromCurrency;
@override@JsonKey() final  String toCurrency;
@override@JsonKey() final  bool showCurrencySelector;
// Fee calculation
@override final  FeeCalculation? feeCalculation;
@override@JsonKey() final  bool isCalculatingFees;
@override final  String? feeCalculationError;
// Flow state
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override final  String? error;
@override final  String? transactionId;
// Draft persistence
@override@JsonKey() final  bool hasDraft;
@override@JsonKey() final  int draftTimestamp;
// Analytics
@override@JsonKey() final  int stepViewCount;
 final  Map<String, dynamic> _analyticsData;
@override@JsonKey() Map<String, dynamic> get analyticsData {
  if (_analyticsData is EqualUnmodifiableMapView) return _analyticsData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_analyticsData);
}


/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendStateCopyWith<_SendState> get copyWith => __$SendStateCopyWithImpl<_SendState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&const DeepCollectionEquality().equals(other._completedSteps, _completedSteps)&&(identical(other.recipient, recipient) || other.recipient == recipient)&&const DeepCollectionEquality().equals(other._recentRecipients, _recentRecipients)&&const DeepCollectionEquality().equals(other._favoriteRecipients, _favoriteRecipients)&&(identical(other.recipientSearchQuery, recipientSearchQuery) || other.recipientSearchQuery == recipientSearchQuery)&&const DeepCollectionEquality().equals(other._searchResults, _searchResults)&&(identical(other.selectedNetwork, selectedNetwork) || other.selectedNetwork == selectedNetwork)&&const DeepCollectionEquality().equals(other._availableNetworks, _availableNetworks)&&(identical(other.networkError, networkError) || other.networkError == networkError)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.fromCurrency, fromCurrency) || other.fromCurrency == fromCurrency)&&(identical(other.toCurrency, toCurrency) || other.toCurrency == toCurrency)&&(identical(other.showCurrencySelector, showCurrencySelector) || other.showCurrencySelector == showCurrencySelector)&&(identical(other.feeCalculation, feeCalculation) || other.feeCalculation == feeCalculation)&&(identical(other.isCalculatingFees, isCalculatingFees) || other.isCalculatingFees == isCalculatingFees)&&(identical(other.feeCalculationError, feeCalculationError) || other.feeCalculationError == feeCalculationError)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.error, error) || other.error == error)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.hasDraft, hasDraft) || other.hasDraft == hasDraft)&&(identical(other.draftTimestamp, draftTimestamp) || other.draftTimestamp == draftTimestamp)&&(identical(other.stepViewCount, stepViewCount) || other.stepViewCount == stepViewCount)&&const DeepCollectionEquality().equals(other._analyticsData, _analyticsData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,currentStep,const DeepCollectionEquality().hash(_completedSteps),recipient,const DeepCollectionEquality().hash(_recentRecipients),const DeepCollectionEquality().hash(_favoriteRecipients),recipientSearchQuery,const DeepCollectionEquality().hash(_searchResults),selectedNetwork,const DeepCollectionEquality().hash(_availableNetworks),networkError,amount,fromCurrency,toCurrency,showCurrencySelector,feeCalculation,isCalculatingFees,feeCalculationError,isLoading,isSubmitting,error,transactionId,hasDraft,draftTimestamp,stepViewCount,const DeepCollectionEquality().hash(_analyticsData)]);

@override
String toString() {
  return 'SendState(currentStep: $currentStep, completedSteps: $completedSteps, recipient: $recipient, recentRecipients: $recentRecipients, favoriteRecipients: $favoriteRecipients, recipientSearchQuery: $recipientSearchQuery, searchResults: $searchResults, selectedNetwork: $selectedNetwork, availableNetworks: $availableNetworks, networkError: $networkError, amount: $amount, fromCurrency: $fromCurrency, toCurrency: $toCurrency, showCurrencySelector: $showCurrencySelector, feeCalculation: $feeCalculation, isCalculatingFees: $isCalculatingFees, feeCalculationError: $feeCalculationError, isLoading: $isLoading, isSubmitting: $isSubmitting, error: $error, transactionId: $transactionId, hasDraft: $hasDraft, draftTimestamp: $draftTimestamp, stepViewCount: $stepViewCount, analyticsData: $analyticsData)';
}


}

/// @nodoc
abstract mixin class _$SendStateCopyWith<$Res> implements $SendStateCopyWith<$Res> {
  factory _$SendStateCopyWith(_SendState value, $Res Function(_SendState) _then) = __$SendStateCopyWithImpl;
@override @useResult
$Res call({
 SendStep currentStep, List<SendStep> completedSteps, RecipientInfo? recipient, List<RecipientInfo> recentRecipients, List<RecipientInfo> favoriteRecipients, String recipientSearchQuery, List<RecipientInfo> searchResults, NetworkInfo? selectedNetwork, List<NetworkInfo> availableNetworks, String? networkError,@MoneyConverter() Money? amount, String fromCurrency, String toCurrency, bool showCurrencySelector, FeeCalculation? feeCalculation, bool isCalculatingFees, String? feeCalculationError, bool isLoading, bool isSubmitting, String? error, String? transactionId, bool hasDraft, int draftTimestamp, int stepViewCount, Map<String, dynamic> analyticsData
});


@override $RecipientInfoCopyWith<$Res>? get recipient;@override $NetworkInfoCopyWith<$Res>? get selectedNetwork;@override $FeeCalculationCopyWith<$Res>? get feeCalculation;

}
/// @nodoc
class __$SendStateCopyWithImpl<$Res>
    implements _$SendStateCopyWith<$Res> {
  __$SendStateCopyWithImpl(this._self, this._then);

  final _SendState _self;
  final $Res Function(_SendState) _then;

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? completedSteps = null,Object? recipient = freezed,Object? recentRecipients = null,Object? favoriteRecipients = null,Object? recipientSearchQuery = null,Object? searchResults = null,Object? selectedNetwork = freezed,Object? availableNetworks = null,Object? networkError = freezed,Object? amount = freezed,Object? fromCurrency = null,Object? toCurrency = null,Object? showCurrencySelector = null,Object? feeCalculation = freezed,Object? isCalculatingFees = null,Object? feeCalculationError = freezed,Object? isLoading = null,Object? isSubmitting = null,Object? error = freezed,Object? transactionId = freezed,Object? hasDraft = null,Object? draftTimestamp = null,Object? stepViewCount = null,Object? analyticsData = null,}) {
  return _then(_SendState(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as SendStep,completedSteps: null == completedSteps ? _self._completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<SendStep>,recipient: freezed == recipient ? _self.recipient : recipient // ignore: cast_nullable_to_non_nullable
as RecipientInfo?,recentRecipients: null == recentRecipients ? _self._recentRecipients : recentRecipients // ignore: cast_nullable_to_non_nullable
as List<RecipientInfo>,favoriteRecipients: null == favoriteRecipients ? _self._favoriteRecipients : favoriteRecipients // ignore: cast_nullable_to_non_nullable
as List<RecipientInfo>,recipientSearchQuery: null == recipientSearchQuery ? _self.recipientSearchQuery : recipientSearchQuery // ignore: cast_nullable_to_non_nullable
as String,searchResults: null == searchResults ? _self._searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<RecipientInfo>,selectedNetwork: freezed == selectedNetwork ? _self.selectedNetwork : selectedNetwork // ignore: cast_nullable_to_non_nullable
as NetworkInfo?,availableNetworks: null == availableNetworks ? _self._availableNetworks : availableNetworks // ignore: cast_nullable_to_non_nullable
as List<NetworkInfo>,networkError: freezed == networkError ? _self.networkError : networkError // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money?,fromCurrency: null == fromCurrency ? _self.fromCurrency : fromCurrency // ignore: cast_nullable_to_non_nullable
as String,toCurrency: null == toCurrency ? _self.toCurrency : toCurrency // ignore: cast_nullable_to_non_nullable
as String,showCurrencySelector: null == showCurrencySelector ? _self.showCurrencySelector : showCurrencySelector // ignore: cast_nullable_to_non_nullable
as bool,feeCalculation: freezed == feeCalculation ? _self.feeCalculation : feeCalculation // ignore: cast_nullable_to_non_nullable
as FeeCalculation?,isCalculatingFees: null == isCalculatingFees ? _self.isCalculatingFees : isCalculatingFees // ignore: cast_nullable_to_non_nullable
as bool,feeCalculationError: freezed == feeCalculationError ? _self.feeCalculationError : feeCalculationError // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,hasDraft: null == hasDraft ? _self.hasDraft : hasDraft // ignore: cast_nullable_to_non_nullable
as bool,draftTimestamp: null == draftTimestamp ? _self.draftTimestamp : draftTimestamp // ignore: cast_nullable_to_non_nullable
as int,stepViewCount: null == stepViewCount ? _self.stepViewCount : stepViewCount // ignore: cast_nullable_to_non_nullable
as int,analyticsData: null == analyticsData ? _self._analyticsData : analyticsData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecipientInfoCopyWith<$Res>? get recipient {
    if (_self.recipient == null) {
    return null;
  }

  return $RecipientInfoCopyWith<$Res>(_self.recipient!, (value) {
    return _then(_self.copyWith(recipient: value));
  });
}/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkInfoCopyWith<$Res>? get selectedNetwork {
    if (_self.selectedNetwork == null) {
    return null;
  }

  return $NetworkInfoCopyWith<$Res>(_self.selectedNetwork!, (value) {
    return _then(_self.copyWith(selectedNetwork: value));
  });
}/// Create a copy of SendState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeeCalculationCopyWith<$Res>? get feeCalculation {
    if (_self.feeCalculation == null) {
    return null;
  }

  return $FeeCalculationCopyWith<$Res>(_self.feeCalculation!, (value) {
    return _then(_self.copyWith(feeCalculation: value));
  });
}
}

// dart format on
