// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DateCourseImpl _$$DateCourseImplFromJson(Map<String, dynamic> json) =>
    _$DateCourseImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      location: json['location'] as String,
      category: json['category'] as String,
      duration: (json['duration'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      places: (json['places'] as List<dynamic>)
          .map((e) => DatePlace.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$DateCourseImplToJson(_$DateCourseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'location': instance.location,
      'category': instance.category,
      'duration': instance.duration,
      'tags': instance.tags,
      'places': instance.places,
      'isFavorite': instance.isFavorite,
    };
