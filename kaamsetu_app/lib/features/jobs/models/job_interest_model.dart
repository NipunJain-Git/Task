import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kaamsetu_app/features/auth/models/user_model.dart';

part 'job_interest_model.freezed.dart';
part 'job_interest_model.g.dart';

@freezed
abstract class JobInterest with _$JobInterest {
  const factory JobInterest({
    required String id,
    @JsonKey(name: 'jobId') required String jobId,
    @JsonKey(name: 'workerId') required String workerId,
    @JsonKey(name: 'worker') required UserModel worker,
    @JsonKey(name: 'status') @Default('PENDING') String status,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _JobInterest;

  factory JobInterest.fromJson(Map<String, dynamic> json) =>
      _$JobInterestFromJson(json);
}
