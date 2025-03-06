import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

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
    required List<String> tags,
  }) = _DatePlace;

  factory DatePlace.fromJson(Map<String, dynamic> json) => _$DatePlaceFromJson(json);
}