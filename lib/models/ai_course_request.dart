import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_course_request.freezed.dart';
part 'ai_course_request.g.dart';

@freezed
class AICourseRequest with _$AICourseRequest {
  const factory AICourseRequest({
    required String location,
    required String theme,
    required int budget,
    required String mood,
    required int duration,
    String? additionalInfo,
  }) = _AICourseRequest;

  factory AICourseRequest.fromJson(Map<String, dynamic> json) =>
      _$AICourseRequestFromJson(json);
}