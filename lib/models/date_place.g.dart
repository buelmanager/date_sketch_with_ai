// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DatePlaceImpl _$$DatePlaceImplFromJson(Map<String, dynamic> json) =>
    _$DatePlaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      address: json['address'] as String,
      description: json['description'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$DatePlaceImplToJson(_$DatePlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'address': instance.address,
      'description': instance.description,
      'tags': instance.tags,
      'reviewCount': instance.reviewCount,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'metadata': instance.metadata,
      'isFavorite': instance.isFavorite,
    };
