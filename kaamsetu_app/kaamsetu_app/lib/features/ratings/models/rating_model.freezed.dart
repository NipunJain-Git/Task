// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Rating {

 String get id;@JsonKey(name: 'jobId') String get jobId;@JsonKey(name: 'raterId') String get raterId;@JsonKey(name: 'ratedUserId') String get ratedUserId;@JsonKey(name: 'value') String get value; String? get comment;@JsonKey(name: 'createdAt') DateTime get createdAt;
/// Create a copy of Rating
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingCopyWith<Rating> get copyWith => _$RatingCopyWithImpl<Rating>(this as Rating, _$identity);

  /// Serializes this Rating to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rating&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.raterId, raterId) || other.raterId == raterId)&&(identical(other.ratedUserId, ratedUserId) || other.ratedUserId == ratedUserId)&&(identical(other.value, value) || other.value == value)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,raterId,ratedUserId,value,comment,createdAt);

@override
String toString() {
  return 'Rating(id: $id, jobId: $jobId, raterId: $raterId, ratedUserId: $ratedUserId, value: $value, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RatingCopyWith<$Res>  {
  factory $RatingCopyWith(Rating value, $Res Function(Rating) _then) = _$RatingCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'jobId') String jobId,@JsonKey(name: 'raterId') String raterId,@JsonKey(name: 'ratedUserId') String ratedUserId,@JsonKey(name: 'value') String value, String? comment,@JsonKey(name: 'createdAt') DateTime createdAt
});




}
/// @nodoc
class _$RatingCopyWithImpl<$Res>
    implements $RatingCopyWith<$Res> {
  _$RatingCopyWithImpl(this._self, this._then);

  final Rating _self;
  final $Res Function(Rating) _then;

/// Create a copy of Rating
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? jobId = null,Object? raterId = null,Object? ratedUserId = null,Object? value = null,Object? comment = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,raterId: null == raterId ? _self.raterId : raterId // ignore: cast_nullable_to_non_nullable
as String,ratedUserId: null == ratedUserId ? _self.ratedUserId : ratedUserId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Rating].
extension RatingPatterns on Rating {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Rating value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Rating() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Rating value)  $default,){
final _that = this;
switch (_that) {
case _Rating():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Rating value)?  $default,){
final _that = this;
switch (_that) {
case _Rating() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'jobId')  String jobId, @JsonKey(name: 'raterId')  String raterId, @JsonKey(name: 'ratedUserId')  String ratedUserId, @JsonKey(name: 'value')  String value,  String? comment, @JsonKey(name: 'createdAt')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Rating() when $default != null:
return $default(_that.id,_that.jobId,_that.raterId,_that.ratedUserId,_that.value,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'jobId')  String jobId, @JsonKey(name: 'raterId')  String raterId, @JsonKey(name: 'ratedUserId')  String ratedUserId, @JsonKey(name: 'value')  String value,  String? comment, @JsonKey(name: 'createdAt')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Rating():
return $default(_that.id,_that.jobId,_that.raterId,_that.ratedUserId,_that.value,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'jobId')  String jobId, @JsonKey(name: 'raterId')  String raterId, @JsonKey(name: 'ratedUserId')  String ratedUserId, @JsonKey(name: 'value')  String value,  String? comment, @JsonKey(name: 'createdAt')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Rating() when $default != null:
return $default(_that.id,_that.jobId,_that.raterId,_that.ratedUserId,_that.value,_that.comment,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Rating implements Rating {
  const _Rating({required this.id, @JsonKey(name: 'jobId') required this.jobId, @JsonKey(name: 'raterId') required this.raterId, @JsonKey(name: 'ratedUserId') required this.ratedUserId, @JsonKey(name: 'value') required this.value, this.comment, @JsonKey(name: 'createdAt') required this.createdAt});
  factory _Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

@override final  String id;
@override@JsonKey(name: 'jobId') final  String jobId;
@override@JsonKey(name: 'raterId') final  String raterId;
@override@JsonKey(name: 'ratedUserId') final  String ratedUserId;
@override@JsonKey(name: 'value') final  String value;
@override final  String? comment;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;

/// Create a copy of Rating
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatingCopyWith<_Rating> get copyWith => __$RatingCopyWithImpl<_Rating>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RatingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rating&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.raterId, raterId) || other.raterId == raterId)&&(identical(other.ratedUserId, ratedUserId) || other.ratedUserId == ratedUserId)&&(identical(other.value, value) || other.value == value)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,raterId,ratedUserId,value,comment,createdAt);

@override
String toString() {
  return 'Rating(id: $id, jobId: $jobId, raterId: $raterId, ratedUserId: $ratedUserId, value: $value, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RatingCopyWith<$Res> implements $RatingCopyWith<$Res> {
  factory _$RatingCopyWith(_Rating value, $Res Function(_Rating) _then) = __$RatingCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'jobId') String jobId,@JsonKey(name: 'raterId') String raterId,@JsonKey(name: 'ratedUserId') String ratedUserId,@JsonKey(name: 'value') String value, String? comment,@JsonKey(name: 'createdAt') DateTime createdAt
});




}
/// @nodoc
class __$RatingCopyWithImpl<$Res>
    implements _$RatingCopyWith<$Res> {
  __$RatingCopyWithImpl(this._self, this._then);

  final _Rating _self;
  final $Res Function(_Rating) _then;

/// Create a copy of Rating
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? jobId = null,Object? raterId = null,Object? ratedUserId = null,Object? value = null,Object? comment = freezed,Object? createdAt = null,}) {
  return _then(_Rating(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,raterId: null == raterId ? _self.raterId : raterId // ignore: cast_nullable_to_non_nullable
as String,ratedUserId: null == ratedUserId ? _self.ratedUserId : ratedUserId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
