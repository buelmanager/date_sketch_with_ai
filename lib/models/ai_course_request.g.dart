// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_course_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AICourseRequestImpl _$$AICourseRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AICourseRequestImpl(
      location: json['location'] as String,
      theme: json['theme'] as String,
      budget: (json['budget'] as num).toInt(),
      mood: json['mood'] as String,
      duration: (json['duration'] as num).toInt(),
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$$AICourseRequestImplToJson(
        _$AICourseRequestImpl instance) =>
    <String, dynamic>{
      'location': instance.location,
      'theme': instance.theme,
      'budget': instance.budget,
      'mood': instance.mood,
      'duration': instance.duration,
      'additionalInfo': instance.additionalInfo,
    };
