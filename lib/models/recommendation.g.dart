// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationImpl _$$RecommendationImplFromJson(Map<String, dynamic> json) =>
    _$RecommendationImpl(
      recommendedCourses: (json['recommendedCourses'] as List<dynamic>)
          .map((e) => DateCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularPlaces: (json['popularPlaces'] as List<dynamic>)
          .map((e) => DatePlace.fromJson(e as Map<String, dynamic>))
          .toList(),
      seasonalCourses: (json['seasonalCourses'] as List<dynamic>)
          .map((e) => DateCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RecommendationImplToJson(
        _$RecommendationImpl instance) =>
    <String, dynamic>{
      'recommendedCourses': instance.recommendedCourses,
      'popularPlaces': instance.popularPlaces,
      'seasonalCourses': instance.seasonalCourses,
    };
