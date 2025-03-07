import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'place.dart';

part 'date_place.freezed.dart';
part 'date_place.g.dart';

@freezed
class DatePlace with _$DatePlace {
  const factory DatePlace({
    required String id,
    required String name,
    required String category,
    required String imageUrl,
    required double rating,
    required String address,
    required String description,
    required List<String> tags,
    required int reviewCount,

    // 추가 필드
    required double latitude,
    required double longitude,
    Map<String, dynamic>? metadata,
    @Default(false) bool isFavorite,
  }) = _DatePlace;

  factory DatePlace.fromJson(Map<String, dynamic> json) => _$DatePlaceFromJson(json);
}

extension DatePlaceExtension on DatePlace {
  /// DatePlace를 Place 객체로 변환
  Place toPlace() {
    return Place(
      id: id,
      name: name,
      category: category,
      address: address,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      reviews: reviewCount,
      latitude: latitude,
      longitude: longitude,
      isFavorite: isFavorite,
      // 추가 필드는 필요에 따라 설정
      phoneNumber: metadata?['phoneNumber'] as String?,
      website: metadata?['website'] as String?,
      openingHours: metadata?['openingHours'] != null
          ? Map<String, String>.from(metadata!['openingHours'] as Map)
          : null,
    );
  }
}