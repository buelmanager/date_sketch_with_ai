// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) {
  return _Recommendation.fromJson(json);
}

/// @nodoc
mixin _$Recommendation {
  List<DateCourse> get recommendedCourses => throw _privateConstructorUsedError;
  List<DatePlace> get popularPlaces => throw _privateConstructorUsedError;
  List<DateCourse> get seasonalCourses => throw _privateConstructorUsedError;

  /// Serializes this Recommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationCopyWith<Recommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationCopyWith<$Res> {
  factory $RecommendationCopyWith(
          Recommendation value, $Res Function(Recommendation) then) =
      _$RecommendationCopyWithImpl<$Res, Recommendation>;
  @useResult
  $Res call(
      {List<DateCourse> recommendedCourses,
      List<DatePlace> popularPlaces,
      List<DateCourse> seasonalCourses});
}

/// @nodoc
class _$RecommendationCopyWithImpl<$Res, $Val extends Recommendation>
    implements $RecommendationCopyWith<$Res> {
  _$RecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendedCourses = null,
    Object? popularPlaces = null,
    Object? seasonalCourses = null,
  }) {
    return _then(_value.copyWith(
      recommendedCourses: null == recommendedCourses
          ? _value.recommendedCourses
          : recommendedCourses // ignore: cast_nullable_to_non_nullable
              as List<DateCourse>,
      popularPlaces: null == popularPlaces
          ? _value.popularPlaces
          : popularPlaces // ignore: cast_nullable_to_non_nullable
              as List<DatePlace>,
      seasonalCourses: null == seasonalCourses
          ? _value.seasonalCourses
          : seasonalCourses // ignore: cast_nullable_to_non_nullable
              as List<DateCourse>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationImplCopyWith<$Res>
    implements $RecommendationCopyWith<$Res> {
  factory _$$RecommendationImplCopyWith(_$RecommendationImpl value,
          $Res Function(_$RecommendationImpl) then) =
      __$$RecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<DateCourse> recommendedCourses,
      List<DatePlace> popularPlaces,
      List<DateCourse> seasonalCourses});
}

/// @nodoc
class __$$RecommendationImplCopyWithImpl<$Res>
    extends _$RecommendationCopyWithImpl<$Res, _$RecommendationImpl>
    implements _$$RecommendationImplCopyWith<$Res> {
  __$$RecommendationImplCopyWithImpl(
      _$RecommendationImpl _value, $Res Function(_$RecommendationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recommendedCourses = null,
    Object? popularPlaces = null,
    Object? seasonalCourses = null,
  }) {
    return _then(_$RecommendationImpl(
      recommendedCourses: null == recommendedCourses
          ? _value._recommendedCourses
          : recommendedCourses // ignore: cast_nullable_to_non_nullable
              as List<DateCourse>,
      popularPlaces: null == popularPlaces
          ? _value._popularPlaces
          : popularPlaces // ignore: cast_nullable_to_non_nullable
              as List<DatePlace>,
      seasonalCourses: null == seasonalCourses
          ? _value._seasonalCourses
          : seasonalCourses // ignore: cast_nullable_to_non_nullable
              as List<DateCourse>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationImpl implements _Recommendation {
  const _$RecommendationImpl(
      {required final List<DateCourse> recommendedCourses,
      required final List<DatePlace> popularPlaces,
      required final List<DateCourse> seasonalCourses})
      : _recommendedCourses = recommendedCourses,
        _popularPlaces = popularPlaces,
        _seasonalCourses = seasonalCourses;

  factory _$RecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationImplFromJson(json);

  final List<DateCourse> _recommendedCourses;
  @override
  List<DateCourse> get recommendedCourses {
    if (_recommendedCourses is EqualUnmodifiableListView)
      return _recommendedCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedCourses);
  }

  final List<DatePlace> _popularPlaces;
  @override
  List<DatePlace> get popularPlaces {
    if (_popularPlaces is EqualUnmodifiableListView) return _popularPlaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularPlaces);
  }

  final List<DateCourse> _seasonalCourses;
  @override
  List<DateCourse> get seasonalCourses {
    if (_seasonalCourses is EqualUnmodifiableListView) return _seasonalCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_seasonalCourses);
  }

  @override
  String toString() {
    return 'Recommendation(recommendedCourses: $recommendedCourses, popularPlaces: $popularPlaces, seasonalCourses: $seasonalCourses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationImpl &&
            const DeepCollectionEquality()
                .equals(other._recommendedCourses, _recommendedCourses) &&
            const DeepCollectionEquality()
                .equals(other._popularPlaces, _popularPlaces) &&
            const DeepCollectionEquality()
                .equals(other._seasonalCourses, _seasonalCourses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_recommendedCourses),
      const DeepCollectionEquality().hash(_popularPlaces),
      const DeepCollectionEquality().hash(_seasonalCourses));

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationImplCopyWith<_$RecommendationImpl> get copyWith =>
      __$$RecommendationImplCopyWithImpl<_$RecommendationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationImplToJson(
      this,
    );
  }
}

abstract class _Recommendation implements Recommendation {
  const factory _Recommendation(
      {required final List<DateCourse> recommendedCourses,
      required final List<DatePlace> popularPlaces,
      required final List<DateCourse> seasonalCourses}) = _$RecommendationImpl;

  factory _Recommendation.fromJson(Map<String, dynamic> json) =
      _$RecommendationImpl.fromJson;

  @override
  List<DateCourse> get recommendedCourses;
  @override
  List<DatePlace> get popularPlaces;
  @override
  List<DateCourse> get seasonalCourses;

  /// Create a copy of Recommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationImplCopyWith<_$RecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
