// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: (json['reviews'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      openingHours: (json['openingHours'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$PlaceImplToJson(_$PlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'address': instance.address,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'metadata': instance.metadata,
      'isFavorite': instance.isFavorite,
      'phoneNumber': instance.phoneNumber,
      'website': instance.website,
      'openingHours': instance.openingHours,
    };
