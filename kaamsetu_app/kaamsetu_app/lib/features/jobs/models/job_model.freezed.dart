// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Job {

 String get id;@JsonKey(name: 'householdId') String get householdId;@JsonKey(name: 'household') UserModel get household; String get title; String get description; String get category;@JsonKey(name: 'jobDate') DateTime get jobDate; String? get jobTime; double get latitude; double get longitude; String? get address;@JsonKey(name: 'budgetAmount') double get budgetAmount;@JsonKey(name: 'budgetType') String get budgetType;@JsonKey(name: 'status') String get status;@JsonKey(name: 'assignedWorkerId') String? get assignedWorkerId;@JsonKey(name: 'assignedWorker') UserModel? get assignedWorker;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'updatedAt') DateTime get updatedAt;
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobCopyWith<Job> get copyWith => _$JobCopyWithImpl<Job>(this as Job, _$identity);

  /// Serializes this Job to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Job&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.household, household) || other.household == household)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.jobDate, jobDate) || other.jobDate == jobDate)&&(identical(other.jobTime, jobTime) || other.jobTime == jobTime)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.address, address) || other.address == address)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.budgetType, budgetType) || other.budgetType == budgetType)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedWorkerId, assignedWorkerId) || other.assignedWorkerId == assignedWorkerId)&&(identical(other.assignedWorker, assignedWorker) || other.assignedWorker == assignedWorker)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,household,title,description,category,jobDate,jobTime,latitude,longitude,address,budgetAmount,budgetType,status,assignedWorkerId,assignedWorker,createdAt,updatedAt);

@override
String toString() {
  return 'Job(id: $id, householdId: $householdId, household: $household, title: $title, description: $description, category: $category, jobDate: $jobDate, jobTime: $jobTime, latitude: $latitude, longitude: $longitude, address: $address, budgetAmount: $budgetAmount, budgetType: $budgetType, status: $status, assignedWorkerId: $assignedWorkerId, assignedWorker: $assignedWorker, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JobCopyWith<$Res>  {
  factory $JobCopyWith(Job value, $Res Function(Job) _then) = _$JobCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'householdId') String householdId,@JsonKey(name: 'household') UserModel household, String title, String description, String category,@JsonKey(name: 'jobDate') DateTime jobDate, String? jobTime, double latitude, double longitude, String? address,@JsonKey(name: 'budgetAmount') double budgetAmount,@JsonKey(name: 'budgetType') String budgetType,@JsonKey(name: 'status') String status,@JsonKey(name: 'assignedWorkerId') String? assignedWorkerId,@JsonKey(name: 'assignedWorker') UserModel? assignedWorker,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'updatedAt') DateTime updatedAt
});




}
/// @nodoc
class _$JobCopyWithImpl<$Res>
    implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._self, this._then);

  final Job _self;
  final $Res Function(Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? householdId = null,Object? household = null,Object? title = null,Object? description = null,Object? category = null,Object? jobDate = null,Object? jobTime = freezed,Object? latitude = null,Object? longitude = null,Object? address = freezed,Object? budgetAmount = null,Object? budgetType = null,Object? status = null,Object? assignedWorkerId = freezed,Object? assignedWorker = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,household: null == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as UserModel,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,jobDate: null == jobDate ? _self.jobDate : jobDate // ignore: cast_nullable_to_non_nullable
as DateTime,jobTime: freezed == jobTime ? _self.jobTime : jobTime // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,budgetAmount: null == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double,budgetType: null == budgetType ? _self.budgetType : budgetType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assignedWorkerId: freezed == assignedWorkerId ? _self.assignedWorkerId : assignedWorkerId // ignore: cast_nullable_to_non_nullable
as String?,assignedWorker: freezed == assignedWorker ? _self.assignedWorker : assignedWorker // ignore: cast_nullable_to_non_nullable
as UserModel?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Job].
extension JobPatterns on Job {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Job value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Job value)  $default,){
final _that = this;
switch (_that) {
case _Job():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Job value)?  $default,){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'householdId')  String householdId, @JsonKey(name: 'household')  UserModel household,  String title,  String description,  String category, @JsonKey(name: 'jobDate')  DateTime jobDate,  String? jobTime,  double latitude,  double longitude,  String? address, @JsonKey(name: 'budgetAmount')  double budgetAmount, @JsonKey(name: 'budgetType')  String budgetType, @JsonKey(name: 'status')  String status, @JsonKey(name: 'assignedWorkerId')  String? assignedWorkerId, @JsonKey(name: 'assignedWorker')  UserModel? assignedWorker, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.id,_that.householdId,_that.household,_that.title,_that.description,_that.category,_that.jobDate,_that.jobTime,_that.latitude,_that.longitude,_that.address,_that.budgetAmount,_that.budgetType,_that.status,_that.assignedWorkerId,_that.assignedWorker,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'householdId')  String householdId, @JsonKey(name: 'household')  UserModel household,  String title,  String description,  String category, @JsonKey(name: 'jobDate')  DateTime jobDate,  String? jobTime,  double latitude,  double longitude,  String? address, @JsonKey(name: 'budgetAmount')  double budgetAmount, @JsonKey(name: 'budgetType')  String budgetType, @JsonKey(name: 'status')  String status, @JsonKey(name: 'assignedWorkerId')  String? assignedWorkerId, @JsonKey(name: 'assignedWorker')  UserModel? assignedWorker, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Job():
return $default(_that.id,_that.householdId,_that.household,_that.title,_that.description,_that.category,_that.jobDate,_that.jobTime,_that.latitude,_that.longitude,_that.address,_that.budgetAmount,_that.budgetType,_that.status,_that.assignedWorkerId,_that.assignedWorker,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'householdId')  String householdId, @JsonKey(name: 'household')  UserModel household,  String title,  String description,  String category, @JsonKey(name: 'jobDate')  DateTime jobDate,  String? jobTime,  double latitude,  double longitude,  String? address, @JsonKey(name: 'budgetAmount')  double budgetAmount, @JsonKey(name: 'budgetType')  String budgetType, @JsonKey(name: 'status')  String status, @JsonKey(name: 'assignedWorkerId')  String? assignedWorkerId, @JsonKey(name: 'assignedWorker')  UserModel? assignedWorker, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'updatedAt')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.id,_that.householdId,_that.household,_that.title,_that.description,_that.category,_that.jobDate,_that.jobTime,_that.latitude,_that.longitude,_that.address,_that.budgetAmount,_that.budgetType,_that.status,_that.assignedWorkerId,_that.assignedWorker,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Job implements Job {
  const _Job({required this.id, @JsonKey(name: 'householdId') required this.householdId, @JsonKey(name: 'household') required this.household, required this.title, required this.description, required this.category, @JsonKey(name: 'jobDate') required this.jobDate, this.jobTime, required this.latitude, required this.longitude, this.address, @JsonKey(name: 'budgetAmount') required this.budgetAmount, @JsonKey(name: 'budgetType') this.budgetType = 'FIXED', @JsonKey(name: 'status') this.status = 'OPEN', @JsonKey(name: 'assignedWorkerId') this.assignedWorkerId, @JsonKey(name: 'assignedWorker') this.assignedWorker, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'updatedAt') required this.updatedAt});
  factory _Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

@override final  String id;
@override@JsonKey(name: 'householdId') final  String householdId;
@override@JsonKey(name: 'household') final  UserModel household;
@override final  String title;
@override final  String description;
@override final  String category;
@override@JsonKey(name: 'jobDate') final  DateTime jobDate;
@override final  String? jobTime;
@override final  double latitude;
@override final  double longitude;
@override final  String? address;
@override@JsonKey(name: 'budgetAmount') final  double budgetAmount;
@override@JsonKey(name: 'budgetType') final  String budgetType;
@override@JsonKey(name: 'status') final  String status;
@override@JsonKey(name: 'assignedWorkerId') final  String? assignedWorkerId;
@override@JsonKey(name: 'assignedWorker') final  UserModel? assignedWorker;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'updatedAt') final  DateTime updatedAt;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobCopyWith<_Job> get copyWith => __$JobCopyWithImpl<_Job>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Job&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.household, household) || other.household == household)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.jobDate, jobDate) || other.jobDate == jobDate)&&(identical(other.jobTime, jobTime) || other.jobTime == jobTime)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.address, address) || other.address == address)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.budgetType, budgetType) || other.budgetType == budgetType)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedWorkerId, assignedWorkerId) || other.assignedWorkerId == assignedWorkerId)&&(identical(other.assignedWorker, assignedWorker) || other.assignedWorker == assignedWorker)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,householdId,household,title,description,category,jobDate,jobTime,latitude,longitude,address,budgetAmount,budgetType,status,assignedWorkerId,assignedWorker,createdAt,updatedAt);

@override
String toString() {
  return 'Job(id: $id, householdId: $householdId, household: $household, title: $title, description: $description, category: $category, jobDate: $jobDate, jobTime: $jobTime, latitude: $latitude, longitude: $longitude, address: $address, budgetAmount: $budgetAmount, budgetType: $budgetType, status: $status, assignedWorkerId: $assignedWorkerId, assignedWorker: $assignedWorker, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JobCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$JobCopyWith(_Job value, $Res Function(_Job) _then) = __$JobCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'householdId') String householdId,@JsonKey(name: 'household') UserModel household, String title, String description, String category,@JsonKey(name: 'jobDate') DateTime jobDate, String? jobTime, double latitude, double longitude, String? address,@JsonKey(name: 'budgetAmount') double budgetAmount,@JsonKey(name: 'budgetType') String budgetType,@JsonKey(name: 'status') String status,@JsonKey(name: 'assignedWorkerId') String? assignedWorkerId,@JsonKey(name: 'assignedWorker') UserModel? assignedWorker,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'updatedAt') DateTime updatedAt
});




}
/// @nodoc
class __$JobCopyWithImpl<$Res>
    implements _$JobCopyWith<$Res> {
  __$JobCopyWithImpl(this._self, this._then);

  final _Job _self;
  final $Res Function(_Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? householdId = null,Object? household = null,Object? title = null,Object? description = null,Object? category = null,Object? jobDate = null,Object? jobTime = freezed,Object? latitude = null,Object? longitude = null,Object? address = freezed,Object? budgetAmount = null,Object? budgetType = null,Object? status = null,Object? assignedWorkerId = freezed,Object? assignedWorker = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Job(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as String,household: null == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as UserModel,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,jobDate: null == jobDate ? _self.jobDate : jobDate // ignore: cast_nullable_to_non_nullable
as DateTime,jobTime: freezed == jobTime ? _self.jobTime : jobTime // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,budgetAmount: null == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double,budgetType: null == budgetType ? _self.budgetType : budgetType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assignedWorkerId: freezed == assignedWorkerId ? _self.assignedWorkerId : assignedWorkerId // ignore: cast_nullable_to_non_nullable
as String?,assignedWorker: freezed == assignedWorker ? _self.assignedWorker : assignedWorker // ignore: cast_nullable_to_non_nullable
as UserModel?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$JobFilter {

 double? get latitude; double? get longitude; double get radius; String? get category; DateTime? get date; String get status; int get page; int get limit;
/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobFilterCopyWith<JobFilter> get copyWith => _$JobFilterCopyWithImpl<JobFilter>(this as JobFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobFilter&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,radius,category,date,status,page,limit);

@override
String toString() {
  return 'JobFilter(latitude: $latitude, longitude: $longitude, radius: $radius, category: $category, date: $date, status: $status, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $JobFilterCopyWith<$Res>  {
  factory $JobFilterCopyWith(JobFilter value, $Res Function(JobFilter) _then) = _$JobFilterCopyWithImpl;
@useResult
$Res call({
 double? latitude, double? longitude, double radius, String? category, DateTime? date, String status, int page, int limit
});




}
/// @nodoc
class _$JobFilterCopyWithImpl<$Res>
    implements $JobFilterCopyWith<$Res> {
  _$JobFilterCopyWithImpl(this._self, this._then);

  final JobFilter _self;
  final $Res Function(JobFilter) _then;

/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = freezed,Object? longitude = freezed,Object? radius = null,Object? category = freezed,Object? date = freezed,Object? status = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JobFilter].
extension JobFilterPatterns on JobFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobFilter value)  $default,){
final _that = this;
switch (_that) {
case _JobFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobFilter value)?  $default,){
final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? latitude,  double? longitude,  double radius,  String? category,  DateTime? date,  String status,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
return $default(_that.latitude,_that.longitude,_that.radius,_that.category,_that.date,_that.status,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? latitude,  double? longitude,  double radius,  String? category,  DateTime? date,  String status,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _JobFilter():
return $default(_that.latitude,_that.longitude,_that.radius,_that.category,_that.date,_that.status,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? latitude,  double? longitude,  double radius,  String? category,  DateTime? date,  String status,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _JobFilter() when $default != null:
return $default(_that.latitude,_that.longitude,_that.radius,_that.category,_that.date,_that.status,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _JobFilter implements JobFilter {
  const _JobFilter({this.latitude, this.longitude, this.radius = 5.0, this.category, this.date, this.status = 'OPEN', this.page = 1, this.limit = 20});
  

@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey() final  double radius;
@override final  String? category;
@override final  DateTime? date;
@override@JsonKey() final  String status;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;

/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobFilterCopyWith<_JobFilter> get copyWith => __$JobFilterCopyWithImpl<_JobFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobFilter&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,radius,category,date,status,page,limit);

@override
String toString() {
  return 'JobFilter(latitude: $latitude, longitude: $longitude, radius: $radius, category: $category, date: $date, status: $status, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$JobFilterCopyWith<$Res> implements $JobFilterCopyWith<$Res> {
  factory _$JobFilterCopyWith(_JobFilter value, $Res Function(_JobFilter) _then) = __$JobFilterCopyWithImpl;
@override @useResult
$Res call({
 double? latitude, double? longitude, double radius, String? category, DateTime? date, String status, int page, int limit
});




}
/// @nodoc
class __$JobFilterCopyWithImpl<$Res>
    implements _$JobFilterCopyWith<$Res> {
  __$JobFilterCopyWithImpl(this._self, this._then);

  final _JobFilter _self;
  final $Res Function(_JobFilter) _then;

/// Create a copy of JobFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = freezed,Object? longitude = freezed,Object? radius = null,Object? category = freezed,Object? date = freezed,Object? status = null,Object? page = null,Object? limit = null,}) {
  return _then(_JobFilter(
latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
