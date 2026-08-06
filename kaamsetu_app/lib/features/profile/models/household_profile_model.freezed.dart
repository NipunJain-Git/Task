// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HouseholdProfile {

 String get id; String get userId; String? get address;@JsonKey(name: 'thumbsUp') int get thumbsUp;@JsonKey(name: 'thumbsDown') int get thumbsDown;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'updatedAt') DateTime get updatedAt;
/// Create a copy of HouseholdProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdProfileCopyWith<HouseholdProfile> get copyWith => _$HouseholdProfileCopyWithImpl<HouseholdProfile>(this as HouseholdProfile, _$identity);

  /// Serializes this HouseholdProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.address, address) || other.address == address)&&(identical(other.thumbsUp, thumbsUp) || other.thumbsUp == thumbsUp)&&(identical(other.thumbsDown, thumbsDown) || other.thumbsDown == thumbsDown)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,address,thumbsUp,thumbsDown,createdAt,updatedAt);

@override
String toString() {
  return 'HouseholdProfile(id: $id, userId: $userId, address: $address, thumbsUp: $thumbsUp, thumbsDown: $thumbsDown, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HouseholdProfileCopyWith<$Res>  {
  factory $HouseholdProfileCopyWith(HouseholdProfile value, $Res Function(HouseholdProfile) _then) = _$HouseholdProfileCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? address,@JsonKey(name: 'thumbsUp') int thumbsUp,@JsonKey(name: 'thumbsDown') int thumbsDown,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'updatedAt') DateTime updatedAt
});




}
/// @nodoc
class _$HouseholdProfileCopyWithImpl<$Res>
    implements $HouseholdProfileCopyWith<$Res> {
  _$HouseholdProfileCopyWithImpl(this._self, this._then);

  final HouseholdProfile _self;
  final $Res Function(HouseholdProfile) _then;

/// Create a copy of HouseholdProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? address = freezed,Object? thumbsUp = null,Object? thumbsDown = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,thumbsUp: null == thumbsUp ? _self.thumbsUp : thumbsUp // ignore: cast_nullable_to_non_nullable
as int,thumbsDown: null == thumbsDown ? _self.thumbsDown : thumbsDown // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HouseholdProfile].
extension HouseholdProfilePatterns on HouseholdProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HouseholdProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HouseholdProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HouseholdProfile value)  $default,){
final _that = this;
switch (_that) {
case _HouseholdProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HouseholdProfile value)?  $default,){
final _that = this;
switch (_that) {
case _HouseholdProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? address, @JsonKey(name: 'thumbsUp')  int thumbsUp, @JsonKey(name: 'thumbsDown')  int thumbsDown, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HouseholdProfile() when $default != null:
return $default(_that.id,_that.userId,_that.address,_that.thumbsUp,_that.thumbsDown,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? address, @JsonKey(name: 'thumbsUp')  int thumbsUp, @JsonKey(name: 'thumbsDown')  int thumbsDown, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _HouseholdProfile():
return $default(_that.id,_that.userId,_that.address,_that.thumbsUp,_that.thumbsDown,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? address, @JsonKey(name: 'thumbsUp')  int thumbsUp, @JsonKey(name: 'thumbsDown')  int thumbsDown, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HouseholdProfile() when $default != null:
return $default(_that.id,_that.userId,_that.address,_that.thumbsUp,_that.thumbsDown,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HouseholdProfile extends HouseholdProfile {
  const _HouseholdProfile({required this.id, required this.userId, this.address, @JsonKey(name: 'thumbsUp') this.thumbsUp = 0, @JsonKey(name: 'thumbsDown') this.thumbsDown = 0, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'updatedAt') required this.updatedAt}): super._();
  factory _HouseholdProfile.fromJson(Map<String, dynamic> json) => _$HouseholdProfileFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? address;
@override@JsonKey(name: 'thumbsUp') final  int thumbsUp;
@override@JsonKey(name: 'thumbsDown') final  int thumbsDown;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'updatedAt') final  DateTime updatedAt;

/// Create a copy of HouseholdProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdProfileCopyWith<_HouseholdProfile> get copyWith => __$HouseholdProfileCopyWithImpl<_HouseholdProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HouseholdProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HouseholdProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.address, address) || other.address == address)&&(identical(other.thumbsUp, thumbsUp) || other.thumbsUp == thumbsUp)&&(identical(other.thumbsDown, thumbsDown) || other.thumbsDown == thumbsDown)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,address,thumbsUp,thumbsDown,createdAt,updatedAt);

@override
String toString() {
  return 'HouseholdProfile(id: $id, userId: $userId, address: $address, thumbsUp: $thumbsUp, thumbsDown: $thumbsDown, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HouseholdProfileCopyWith<$Res> implements $HouseholdProfileCopyWith<$Res> {
  factory _$HouseholdProfileCopyWith(_HouseholdProfile value, $Res Function(_HouseholdProfile) _then) = __$HouseholdProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? address,@JsonKey(name: 'thumbsUp') int thumbsUp,@JsonKey(name: 'thumbsDown') int thumbsDown,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'updatedAt') DateTime updatedAt
});




}
/// @nodoc
class __$HouseholdProfileCopyWithImpl<$Res>
    implements _$HouseholdProfileCopyWith<$Res> {
  __$HouseholdProfileCopyWithImpl(this._self, this._then);

  final _HouseholdProfile _self;
  final $Res Function(_HouseholdProfile) _then;

/// Create a copy of HouseholdProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? address = freezed,Object? thumbsUp = null,Object? thumbsDown = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_HouseholdProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,thumbsUp: null == thumbsUp ? _self.thumbsUp : thumbsUp // ignore: cast_nullable_to_non_nullable
as int,thumbsDown: null == thumbsDown ? _self.thumbsDown : thumbsDown // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
