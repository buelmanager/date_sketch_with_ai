// lib/models/explore_filter.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_filter.freezed.dart';
part 'explore_filter.g.dart';

@freezed
class ExploreFilter with _$ExploreFilter {
  const factory ExploreFilter({
    @Default('전체') String category,
    @Default('') String searchQuery,
    @Default(0) int tabIndex,
    @Default(0.0) double minRating,
    @Default(5.0) double maxDistance,
  }) = _ExploreFilter;

  factory ExploreFilter.fromJson(Map<String, dynamic> json) => _$ExploreFilterFromJson(json);
}