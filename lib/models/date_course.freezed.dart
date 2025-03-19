// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DateCourse _$DateCourseFromJson(Map<String, dynamic> json) {
  return _DateCourse.fromJson(json);
}

/// @nodoc
mixin _$DateCourse {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError; // 분 단위 코스 소요 시간
  List<String> get tags => throw _privateConstructorUsedError;
  List<DatePlace> get places => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  int get estimatedTime => throw _privateConstructorUsedError;
  int get estimatedCost => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  String? get transportationInfo => throw _privateConstructorUsedError;
  String? get alternativeInfo => throw _privateConstructorUsedError;

  /// Serializes this DateCourse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DateCourse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DateCourseCopyWith<DateCourse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateCourseCopyWith<$Res> {
  factory $DateCourseCopyWith(
          DateCourse value, $Res Function(DateCourse) then) =
      _$DateCourseCopyWithImpl<$Res, DateCourse>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String imageUrl,
      double rating,
      String location,
      String category,
      int duration,
      List<String> tags,
      List<DatePlace> places,
      int reviewCount,
      int estimatedTime,
      int estimatedCost,
      String? createdBy,
      bool isFavorite,
      bool isFeatured,
      String? transportationInfo,
      String? alternativeInfo});
}

/// @nodoc
class _$DateCourseCopyWithImpl<$Res, $Val extends DateCourse>
    implements $DateCourseCopyWith<$Res> {
  _$DateCourseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DateCourse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? rating = null,
    Object? location = null,
    Object? category = null,
    Object? duration = null,
    Object? tags = null,
    Object? places = null,
    Object? reviewCount = null,
    Object? estimatedTime = null,
    Object? estimatedCost = null,
    Object? createdBy = freezed,
    Object? isFavorite = null,
    Object? isFeatured = null,
    Object? transportationInfo = freezed,
    Object? alternativeInfo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<DatePlace>,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedCost: null == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      transportationInfo: freezed == transportationInfo
          ? _value.transportationInfo
          : transportationInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      alternativeInfo: freezed == alternativeInfo
          ? _value.alternativeInfo
          : alternativeInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateCourseImplCopyWith<$Res>
    implements $DateCourseCopyWith<$Res> {
  factory _$$DateCourseImplCopyWith(
          _$DateCourseImpl value, $Res Function(_$DateCourseImpl) then) =
      __$$DateCourseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String imageUrl,
      double rating,
      String location,
      String category,
      int duration,
      List<String> tags,
      List<DatePlace> places,
      int reviewCount,
      int estimatedTime,
      int estimatedCost,
      String? createdBy,
      bool isFavorite,
      bool isFeatured,
      String? transportationInfo,
      String? alternativeInfo});
}

/// @nodoc
class __$$DateCourseImplCopyWithImpl<$Res>
    extends _$DateCourseCopyWithImpl<$Res, _$DateCourseImpl>
    implements _$$DateCourseImplCopyWith<$Res> {
  __$$DateCourseImplCopyWithImpl(
      _$DateCourseImpl _value, $Res Function(_$DateCourseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DateCourse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? rating = null,
    Object? location = null,
    Object? category = null,
    Object? duration = null,
    Object? tags = null,
    Object? places = null,
    Object? reviewCount = null,
    Object? estimatedTime = null,
    Object? estimatedCost = null,
    Object? createdBy = freezed,
    Object? isFavorite = null,
    Object? isFeatured = null,
    Object? transportationInfo = freezed,
    Object? alternativeInfo = freezed,
  }) {
    return _then(_$DateCourseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<DatePlace>,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedCost: null == estimatedCost
          ? _value.estimatedCost
          : estimatedCost // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      transportationInfo: freezed == transportationInfo
          ? _value.transportationInfo
          : transportationInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      alternativeInfo: freezed == alternativeInfo
          ? _value.alternativeInfo
          : alternativeInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DateCourseImpl implements _DateCourse {
  const _$DateCourseImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.rating,
      required this.location,
      required this.category,
      required this.duration,
      required final List<String> tags,
      required final List<DatePlace> places,
      required this.reviewCount,
      required this.estimatedTime,
      required this.estimatedCost,
      this.createdBy,
      this.isFavorite = false,
      this.isFeatured = false,
      required this.transportationInfo,
      required this.alternativeInfo})
      : _tags = tags,
        _places = places;

  factory _$DateCourseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DateCourseImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String imageUrl;
  @override
  final double rating;
  @override
  final String location;
  @override
  final String category;
  @override
  final int duration;
// 분 단위 코스 소요 시간
  final List<String> _tags;
// 분 단위 코스 소요 시간
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<DatePlace> _places;
  @override
  List<DatePlace> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  @override
  final int reviewCount;
  @override
  final int estimatedTime;
  @override
  final int estimatedCost;
  @override
  final String? createdBy;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  final String? transportationInfo;
  @override
  final String? alternativeInfo;

  @override
  String toString() {
    return 'DateCourse(id: $id, title: $title, description: $description, imageUrl: $imageUrl, rating: $rating, location: $location, category: $category, duration: $duration, tags: $tags, places: $places, reviewCount: $reviewCount, estimatedTime: $estimatedTime, estimatedCost: $estimatedCost, createdBy: $createdBy, isFavorite: $isFavorite, isFeatured: $isFeatured, transportationInfo: $transportationInfo, alternativeInfo: $alternativeInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateCourseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._places, _places) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.transportationInfo, transportationInfo) ||
                other.transportationInfo == transportationInfo) &&
            (identical(other.alternativeInfo, alternativeInfo) ||
                other.alternativeInfo == alternativeInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      imageUrl,
      rating,
      location,
      category,
      duration,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_places),
      reviewCount,
      estimatedTime,
      estimatedCost,
      createdBy,
      isFavorite,
      isFeatured,
      transportationInfo,
      alternativeInfo);

  /// Create a copy of DateCourse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DateCourseImplCopyWith<_$DateCourseImpl> get copyWith =>
      __$$DateCourseImplCopyWithImpl<_$DateCourseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DateCourseImplToJson(
      this,
    );
  }
}

abstract class _DateCourse implements DateCourse {
  const factory _DateCourse(
      {required final String id,
      required final String title,
      required final String description,
      required final String imageUrl,
      required final double rating,
      required final String location,
      required final String category,
      required final int duration,
      required final List<String> tags,
      required final List<DatePlace> places,
      required final int reviewCount,
      required final int estimatedTime,
      required final int estimatedCost,
      final String? createdBy,
      final bool isFavorite,
      final bool isFeatured,
      required final String? transportationInfo,
      required final String? alternativeInfo}) = _$DateCourseImpl;

  factory _DateCourse.fromJson(Map<String, dynamic> json) =
      _$DateCourseImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get imageUrl;
  @override
  double get rating;
  @override
  String get location;
  @override
  String get category;
  @override
  int get duration; // 분 단위 코스 소요 시간
  @override
  List<String> get tags;
  @override
  List<DatePlace> get places;
  @override
  int get reviewCount;
  @override
  int get estimatedTime;
  @override
  int get estimatedCost;
  @override
  String? get createdBy;
  @override
  bool get isFavorite;
  @override
  bool get isFeatured;
  @override
  String? get transportationInfo;
  @override
  String? get alternativeInfo;

  /// Create a copy of DateCourse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DateCourseImplCopyWith<_$DateCourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
