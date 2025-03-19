import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'date_place.dart';

part 'date_course.freezed.dart';
part 'date_course.g.dart';

@freezed
class DateCourse with _$DateCourse {
  const factory DateCourse({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required double rating,
    required String location,
    required String category,
    required int duration, // 분 단위 코스 소요 시간
    required List<String> tags,
    required List<DatePlace> places,
    required int reviewCount,
    required int estimatedTime,
    required int estimatedCost,
    String? createdBy,
    @Default(false) bool isFavorite,
    @Default(false) bool isFeatured, required String? transportationInfo, required String? alternativeInfo,
  }) = _DateCourse;

  factory DateCourse.fromJson(Map<String, dynamic> json) => _$DateCourseFromJson(json);
}