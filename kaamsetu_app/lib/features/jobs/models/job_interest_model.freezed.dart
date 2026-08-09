// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_interest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobInterest {

 String get id;@JsonKey(name: 'jobId') String get jobId;@JsonKey(name: 'workerId') String get workerId;@JsonKey(name: 'worker') UserModel get worker;@JsonKey(name: 'status') String get status;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'updatedAt') DateTime get updatedAt;
/// Create a copy of JobInterest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobInterestCopyWith<JobInterest> get copyWith => _$JobInterestCopyWithImpl<JobInterest>(this as JobInterest, _$identity);

  /// Serializes this JobInterest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobInterest&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,workerId,worker,status,createdAt,updatedAt);

@override
String toString() {
  return 'JobInterest(id: $id, jobId: $jobId, workerId: $workerId, worker: $worker, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JobInterestCopyWith<$Res>  {
  factory $JobInterestCopyWith(JobInterest value, $Res Function(JobInterest) _then) = _$JobInterestCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'jobId') String jobId,@JsonKey(name: 'workerId') String workerId,@JsonKey(name: 'worker') UserModel worker,@JsonKey(name: 'status') String status,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'updatedAt') DateTime updatedAt
});




}
/// @nodoc
class _$JobInterestCopyWithImpl<$Res>
    implements $JobInterestCopyWith<$Res> {
  _$JobInterestCopyWithImpl(this._self, this._then);

  final JobInterest _self;
  final $Res Function(JobInterest) _then;

/// Create a copy of JobInterest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? jobId = null,Object? workerId = null,Object? worker = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,workerId: null == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String,worker: null == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as UserModel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JobInterest].
extension JobInterestPatterns on JobInterest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobInterest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobInterest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobInterest value)  $default,){
final _that = this;
switch (_that) {
case _JobInterest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobInterest value)?  $default,){
final _that = this;
switch (_that) {
case _JobInterest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'jobId')  String jobId, @JsonKey(name: 'workerId')  String workerId, @JsonKey(name: 'worker')  UserModel worker, @JsonKey(name: 'status')  String status, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobInterest() when $default != null:
return $default(_that.id,_that.jobId,_that.workerId,_that.worker,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'jobId')  String jobId, @JsonKey(name: 'workerId')  String workerId, @JsonKey(name: 'worker')  UserModel worker, @JsonKey(name: 'status')  String status, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JobInterest():
return $default(_that.id,_that.jobId,_that.workerId,_that.worker,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'jobId')  String jobId, @JsonKey(name: 'workerId')  String workerId, @JsonKey(name: 'worker')  UserModel worker, @JsonKey(name: 'status')  String status, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobInterest() when $default != null:
return $default(_that.id,_that.jobId,_that.workerId,_that.worker,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobInterest implements JobInterest {
  const _JobInterest({required this.id, @JsonKey(name: 'jobId') required this.jobId, @JsonKey(name: 'workerId') required this.workerId, @JsonKey(name: 'worker') required this.worker, @JsonKey(name: 'status') this.status = 'PENDING', @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'updatedAt') required this.updatedAt});
  factory _JobInterest.fromJson(Map<String, dynamic> json) => _$JobInterestFromJson(json);

@override final  String id;
@override@JsonKey(name: 'jobId') final  String jobId;
@override@JsonKey(name: 'workerId') final  String workerId;
@override@JsonKey(name: 'worker') final  UserModel worker;
@override@JsonKey(name: 'status') final  String status;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'updatedAt') final  DateTime updatedAt;

/// Create a copy of JobInterest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobInterestCopyWith<_JobInterest> get copyWith => __$JobInterestCopyWithImpl<_JobInterest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobInterestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobInterest&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.workerId, workerId) || other.workerId == workerId)&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,workerId,worker,status,createdAt,updatedAt);

@override
String toString() {
  return 'JobInterest(id: $id, jobId: $jobId, workerId: $workerId, worker: $worker, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JobInterestCopyWith<$Res> implements $JobInterestCopyWith<$Res> {
  factory _$JobInterestCopyWith(_JobInterest value, $Res Function(_JobInterest) _then) = __$JobInterestCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'jobId') String jobId,@JsonKey(name: 'workerId') String workerId,@JsonKey(name: 'worker') UserModel worker,@JsonKey(name: 'status') String status,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'updatedAt') DateTime updatedAt
});




}
/// @nodoc
class __$JobInterestCopyWithImpl<$Res>
    implements _$JobInterestCopyWith<$Res> {
  __$JobInterestCopyWithImpl(this._self, this._then);

  final _JobInterest _self;
  final $Res Function(_JobInterest) _then;

/// Create a copy of JobInterest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? jobId = null,Object? workerId = null,Object? worker = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_JobInterest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,workerId: null == workerId ? _self.workerId : workerId // ignore: cast_nullable_to_non_nullable
as String,worker: null == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as UserModel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
