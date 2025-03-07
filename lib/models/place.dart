import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

@freezed
class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    required String category,
    required String address,
    required String description,
    required String imageUrl,
    required double rating,
    required int reviews,
    required double latitude,
    required double longitude,
    Map<String, dynamic>? metadata,
    @Default(false) bool isFavorite,
    String? phoneNumber,
    String? website,
    Map<String, String>? openingHours,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}