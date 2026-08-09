import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_profile_model.freezed.dart';
part 'worker_profile_model.g.dart';

@freezed
abstract class WorkerProfile with _$WorkerProfile {
  const WorkerProfile._();
  
  const factory WorkerProfile({
    required String id,
    required String userId,
    @JsonKey(name: 'skills') required List<String> skills,
    @JsonKey(name: 'expectedWage') double? expectedWage,
    @JsonKey(name: 'wageType') @Default('DAILY') String wageType,
    @JsonKey(name: 'isAvailable') @Default(true) bool isAvailable,
    @JsonKey(name: 'workRadius') @Default(5.0) double workRadius,
    @JsonKey(name: 'thumbsUp') @Default(0) int thumbsUp,
    @JsonKey(name: 'thumbsDown') @Default(0) int thumbsDown,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _WorkerProfile;

  factory WorkerProfile.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileFromJson(json);
  
  double get positiveRating {
    final total = thumbsUp + thumbsDown;
    if (total == 0) return 0.0;
    return (thumbsUp / total) * 100;
  }
}
