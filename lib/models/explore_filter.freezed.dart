// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExploreFilter _$ExploreFilterFromJson(Map<String, dynamic> json) {
  return _ExploreFilter.fromJson(json);
}

/// @nodoc
mixin _$ExploreFilter {
  String get category => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  int get tabIndex => throw _privateConstructorUsedError;
  double get minRating => throw _privateConstructorUsedError;
  double get maxDistance => throw _privateConstructorUsedError;

  /// Serializes this ExploreFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExploreFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExploreFilterCopyWith<ExploreFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExploreFilterCopyWith<$Res> {
  factory $ExploreFilterCopyWith(
          ExploreFilter value, $Res Function(ExploreFilter) then) =
      _$ExploreFilterCopyWithImpl<$Res, ExploreFilter>;
  @useResult
  $Res call(
      {String category,
      String searchQuery,
      int tabIndex,
      double minRating,
      double maxDistance});
}

/// @nodoc
class _$ExploreFilterCopyWithImpl<$Res, $Val extends ExploreFilter>
    implements $ExploreFilterCopyWith<$Res> {
  _$ExploreFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExploreFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? searchQuery = null,
    Object? tabIndex = null,
    Object? minRating = null,
    Object? maxDistance = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      tabIndex: null == tabIndex
          ? _value.tabIndex
          : tabIndex // ignore: cast_nullable_to_non_nullable
              as int,
      minRating: null == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double,
      maxDistance: null == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExploreFilterImplCopyWith<$Res>
    implements $ExploreFilterCopyWith<$Res> {
  factory _$$ExploreFilterImplCopyWith(
          _$ExploreFilterImpl value, $Res Function(_$ExploreFilterImpl) then) =
      __$$ExploreFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String category,
      String searchQuery,
      int tabIndex,
      double minRating,
      double maxDistance});
}

/// @nodoc
class __$$ExploreFilterImplCopyWithImpl<$Res>
    extends _$ExploreFilterCopyWithImpl<$Res, _$ExploreFilterImpl>
    implements _$$ExploreFilterImplCopyWith<$Res> {
  __$$ExploreFilterImplCopyWithImpl(
      _$ExploreFilterImpl _value, $Res Function(_$ExploreFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExploreFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? searchQuery = null,
    Object? tabIndex = null,
    Object? minRating = null,
    Object? maxDistance = null,
  }) {
    return _then(_$ExploreFilterImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      tabIndex: null == tabIndex
          ? _value.tabIndex
          : tabIndex // ignore: cast_nullable_to_non_nullable
              as int,
      minRating: null == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double,
      maxDistance: null == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExploreFilterImpl implements _ExploreFilter {
  const _$ExploreFilterImpl(
      {this.category = '전체',
      this.searchQuery = '',
      this.tabIndex = 0,
      this.minRating = 0.0,
      this.maxDistance = 5.0});

  factory _$ExploreFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExploreFilterImplFromJson(json);

  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final int tabIndex;
  @override
  @JsonKey()
  final double minRating;
  @override
  @JsonKey()
  final double maxDistance;

  @override
  String toString() {
    return 'ExploreFilter(category: $category, searchQuery: $searchQuery, tabIndex: $tabIndex, minRating: $minRating, maxDistance: $maxDistance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExploreFilterImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.tabIndex, tabIndex) ||
                other.tabIndex == tabIndex) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.maxDistance, maxDistance) ||
                other.maxDistance == maxDistance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, category, searchQuery, tabIndex, minRating, maxDistance);

  /// Create a copy of ExploreFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExploreFilterImplCopyWith<_$ExploreFilterImpl> get copyWith =>
      __$$ExploreFilterImplCopyWithImpl<_$ExploreFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExploreFilterImplToJson(
      this,
    );
  }
}

abstract class _ExploreFilter implements ExploreFilter {
  const factory _ExploreFilter(
      {final String category,
      final String searchQuery,
      final int tabIndex,
      final double minRating,
      final double maxDistance}) = _$ExploreFilterImpl;

  factory _ExploreFilter.fromJson(Map<String, dynamic> json) =
      _$ExploreFilterImpl.fromJson;

  @override
  String get category;
  @override
  String get searchQuery;
  @override
  int get tabIndex;
  @override
  double get minRating;
  @override
  double get maxDistance;

  /// Create a copy of ExploreFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExploreFilterImplCopyWith<_$ExploreFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
