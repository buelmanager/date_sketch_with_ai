// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String? ?? '',
      membershipType: json['membershipType'] as String? ?? '일반',
      visitedPlaces: (json['visitedPlaces'] as num?)?.toInt() ?? 0,
      favoritePlaces: (json['favoritePlaces'] as num?)?.toInt() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profileImage': instance.profileImage,
      'membershipType': instance.membershipType,
      'visitedPlaces': instance.visitedPlaces,
      'favoritePlaces': instance.favoritePlaces,
      'reviewCount': instance.reviewCount,
    };
