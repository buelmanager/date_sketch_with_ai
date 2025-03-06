// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExploreFilterImpl _$$ExploreFilterImplFromJson(Map<String, dynamic> json) =>
    _$ExploreFilterImpl(
      category: json['category'] as String? ?? '전체',
      searchQuery: json['searchQuery'] as String? ?? '',
      tabIndex: (json['tabIndex'] as num?)?.toInt() ?? 0,
      minRating: (json['minRating'] as num?)?.toDouble() ?? 0.0,
      maxDistance: (json['maxDistance'] as num?)?.toDouble() ?? 5.0,
    );

Map<String, dynamic> _$$ExploreFilterImplToJson(_$ExploreFilterImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'searchQuery': instance.searchQuery,
      'tabIndex': instance.tabIndex,
      'minRating': instance.minRating,
      'maxDistance': instance.maxDistance,
    };
