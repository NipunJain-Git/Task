// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerProfile {

 String get id; String get userId;@JsonKey(name: 'skills') List<String> get skills;@JsonKey(name: 'expectedWage') double? get expectedWage;@JsonKey(name: 'wageType') String get wageType;@JsonKey(name: 'isAvailable') bool get isAvailable;@JsonKey(name: 'workRadius') double get workRadius;@JsonKey(name: 'thumbsUp') int get thumbsUp;@JsonKey(name: 'thumbsDown') int get thumbsDown;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'updatedAt') DateTime get updatedAt;
/// Create a copy of WorkerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileCopyWith<WorkerProfile> get copyWith => _$WorkerProfileCopyWithImpl<WorkerProfile>(this as WorkerProfile, _$identity);

  /// Serializes this WorkerProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.skills, skills)&&(identical(other.expectedWage, expectedWage) || other.expectedWage == expectedWage)&&(identical(other.wageType, wageType) || other.wageType == wageType)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.workRadius, workRadius) || other.workRadius == workRadius)&&(identical(other.thumbsUp, thumbsUp) || other.thumbsUp == thumbsUp)&&(identical(other.thumbsDown, thumbsDown) || other.thumbsDown == thumbsDown)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(skills),expectedWage,wageType,isAvailable,workRadius,thumbsUp,thumbsDown,createdAt,updatedAt);

@override
String toString() {
  return 'WorkerProfile(id: $id, userId: $userId, skills: $skills, expectedWage: $expectedWage, wageType: $wageType, isAvailable: $isAvailable, workRadius: $workRadius, thumbsUp: $thumbsUp, thumbsDown: $thumbsDown, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileCopyWith<$Res>  {
  factory $WorkerProfileCopyWith(WorkerProfile value, $Res Function(WorkerProfile) _then) = _$WorkerProfileCopyWithImpl;
@useResult
$Res call({
 String id, String userId,@JsonKey(name: 'skills') List<String> skills,@JsonKey(name: 'expectedWage') double? expectedWage,@JsonKey(name: 'wageType') String wageType,@JsonKey(name: 'isAvailable') bool isAvailable,@JsonKey(name: 'workRadius') double workRadius,@JsonKey(name: 'thumbsUp') int thumbsUp,@JsonKey(name: 'thumbsDown') int thumbsDown,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'updatedAt') DateTime updatedAt
});




}
/// @nodoc
class _$WorkerProfileCopyWithImpl<$Res>
    implements $WorkerProfileCopyWith<$Res> {
  _$WorkerProfileCopyWithImpl(this._self, this._then);

  final WorkerProfile _self;
  final $Res Function(WorkerProfile) _then;

/// Create a copy of WorkerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? skills = null,Object? expectedWage = freezed,Object? wageType = null,Object? isAvailable = null,Object? workRadius = null,Object? thumbsUp = null,Object? thumbsDown = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,expectedWage: freezed == expectedWage ? _self.expectedWage : expectedWage // ignore: cast_nullable_to_non_nullable
as double?,wageType: null == wageType ? _self.wageType : wageType // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,workRadius: null == workRadius ? _self.workRadius : workRadius // ignore: cast_nullable_to_non_nullable
as double,thumbsUp: null == thumbsUp ? _self.thumbsUp : thumbsUp // ignore: cast_nullable_to_non_nullable
as int,thumbsDown: null == thumbsDown ? _self.thumbsDown : thumbsDown // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerProfile].
extension WorkerProfilePatterns on WorkerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfile value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId, @JsonKey(name: 'skills')  List<String> skills, @JsonKey(name: 'expectedWage')  double? expectedWage, @JsonKey(name: 'wageType')  String wageType, @JsonKey(name: 'isAvailable')  bool isAvailable, @JsonKey(name: 'workRadius')  double workRadius, @JsonKey(name: 'thumbsUp')  int thumbsUp, @JsonKey(name: 'thumbsDown')  int thumbsDown, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfile() when $default != null:
return $default(_that.id,_that.userId,_that.skills,_that.expectedWage,_that.wageType,_that.isAvailable,_that.workRadius,_that.thumbsUp,_that.thumbsDown,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId, @JsonKey(name: 'skills')  List<String> skills, @JsonKey(name: 'expectedWage')  double? expectedWage, @JsonKey(name: 'wageType')  String wageType, @JsonKey(name: 'isAvailable')  bool isAvailable, @JsonKey(name: 'workRadius')  double workRadius, @JsonKey(name: 'thumbsUp')  int thumbsUp, @JsonKey(name: 'thumbsDown')  int thumbsDown, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfile():
return $default(_that.id,_that.userId,_that.skills,_that.expectedWage,_that.wageType,_that.isAvailable,_that.workRadius,_that.thumbsUp,_that.thumbsDown,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId, @JsonKey(name: 'skills')  List<String> skills, @JsonKey(name: 'expectedWage')  double? expectedWage, @JsonKey(name: 'wageType')  String wageType, @JsonKey(name: 'isAvailable')  bool isAvailable, @JsonKey(name: 'workRadius')  double workRadius, @JsonKey(name: 'thumbsUp')  int thumbsUp, @JsonKey(name: 'thumbsDown')  int thumbsDown, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfile() when $default != null:
return $default(_that.id,_that.userId,_that.skills,_that.expectedWage,_that.wageType,_that.isAvailable,_that.workRadius,_that.thumbsUp,_that.thumbsDown,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfile extends WorkerProfile {
  const _WorkerProfile({required this.id, required this.userId, @JsonKey(name: 'skills') required final  List<String> skills, @JsonKey(name: 'expectedWage') this.expectedWage, @JsonKey(name: 'wageType') this.wageType = 'DAILY', @JsonKey(name: 'isAvailable') this.isAvailable = true, @JsonKey(name: 'workRadius') this.workRadius = 5.0, @JsonKey(name: 'thumbsUp') this.thumbsUp = 0, @JsonKey(name: 'thumbsDown') this.thumbsDown = 0, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'updatedAt') required this.updatedAt}): _skills = skills,super._();
  factory _WorkerProfile.fromJson(Map<String, dynamic> json) => _$WorkerProfileFromJson(json);

@override final  String id;
@override final  String userId;
 final  List<String> _skills;
@override@JsonKey(name: 'skills') List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

@override@JsonKey(name: 'expectedWage') final  double? expectedWage;
@override@JsonKey(name: 'wageType') final  String wageType;
@override@JsonKey(name: 'isAvailable') final  bool isAvailable;
@override@JsonKey(name: 'workRadius') final  double workRadius;
@override@JsonKey(name: 'thumbsUp') final  int thumbsUp;
@override@JsonKey(name: 'thumbsDown') final  int thumbsDown;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'updatedAt') final  DateTime updatedAt;

/// Create a copy of WorkerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfileCopyWith<_WorkerProfile> get copyWith => __$WorkerProfileCopyWithImpl<_WorkerProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._skills, _skills)&&(identical(other.expectedWage, expectedWage) || other.expectedWage == expectedWage)&&(identical(other.wageType, wageType) || other.wageType == wageType)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.workRadius, workRadius) || other.workRadius == workRadius)&&(identical(other.thumbsUp, thumbsUp) || other.thumbsUp == thumbsUp)&&(identical(other.thumbsDown, thumbsDown) || other.thumbsDown == thumbsDown)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(_skills),expectedWage,wageType,isAvailable,workRadius,thumbsUp,thumbsDown,createdAt,updatedAt);

@override
String toString() {
  return 'WorkerProfile(id: $id, userId: $userId, skills: $skills, expectedWage: $expectedWage, wageType: $wageType, isAvailable: $isAvailable, workRadius: $workRadius, thumbsUp: $thumbsUp, thumbsDown: $thumbsDown, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileCopyWith<$Res> implements $WorkerProfileCopyWith<$Res> {
  factory _$WorkerProfileCopyWith(_WorkerProfile value, $Res Function(_WorkerProfile) _then) = __$WorkerProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId,@JsonKey(name: 'skills') List<String> skills,@JsonKey(name: 'expectedWage') double? expectedWage,@JsonKey(name: 'wageType') String wageType,@JsonKey(name: 'isAvailable') bool isAvailable,@JsonKey(name: 'workRadius') double workRadius,@JsonKey(name: 'thumbsUp') int thumbsUp,@JsonKey(name: 'thumbsDown') int thumbsDown,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'updatedAt') DateTime updatedAt
});




}
/// @nodoc
class __$WorkerProfileCopyWithImpl<$Res>
    implements _$WorkerProfileCopyWith<$Res> {
  __$WorkerProfileCopyWithImpl(this._self, this._then);

  final _WorkerProfile _self;
  final $Res Function(_WorkerProfile) _then;

/// Create a copy of WorkerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? skills = null,Object? expectedWage = freezed,Object? wageType = null,Object? isAvailable = null,Object? workRadius = null,Object? thumbsUp = null,Object? thumbsDown = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WorkerProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,expectedWage: freezed == expectedWage ? _self.expectedWage : expectedWage // ignore: cast_nullable_to_non_nullable
as double?,wageType: null == wageType ? _self.wageType : wageType // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,workRadius: null == workRadius ? _self.workRadius : workRadius // ignore: cast_nullable_to_non_nullable
as double,thumbsUp: null == thumbsUp ? _self.thumbsUp : thumbsUp // ignore: cast_nullable_to_non_nullable
as int,thumbsDown: null == thumbsDown ? _self.thumbsDown : thumbsDown // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
