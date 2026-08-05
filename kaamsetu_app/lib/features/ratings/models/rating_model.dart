import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_model.freezed.dart';
part 'rating_model.g.dart';

@freezed
abstract class Rating with _$Rating {
  const factory Rating({
    required String id,
    @JsonKey(name: 'jobId') required String jobId,
    @JsonKey(name: 'raterId') required String raterId,
    @JsonKey(name: 'ratedUserId') required String ratedUserId,
    @JsonKey(name: 'value') required String value, // THUMBS_UP | THUMBS_DOWN
    String? comment,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _Rating;

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
}
