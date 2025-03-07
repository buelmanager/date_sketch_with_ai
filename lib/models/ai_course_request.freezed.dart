// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_course_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AICourseRequest _$AICourseRequestFromJson(Map<String, dynamic> json) {
  return _AICourseRequest.fromJson(json);
}

/// @nodoc
mixin _$AICourseRequest {
  String get location => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  int get budget => throw _privateConstructorUsedError;
  String get mood => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String? get additionalInfo => throw _privateConstructorUsedError;

  /// Serializes this AICourseRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AICourseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AICourseRequestCopyWith<AICourseRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AICourseRequestCopyWith<$Res> {
  factory $AICourseRequestCopyWith(
          AICourseRequest value, $Res Function(AICourseRequest) then) =
      _$AICourseRequestCopyWithImpl<$Res, AICourseRequest>;
  @useResult
  $Res call(
      {String location,
      String theme,
      int budget,
      String mood,
      int duration,
      String? additionalInfo});
}

/// @nodoc
class _$AICourseRequestCopyWithImpl<$Res, $Val extends AICourseRequest>
    implements $AICourseRequestCopyWith<$Res> {
  _$AICourseRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AICourseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? theme = null,
    Object? budget = null,
    Object? mood = null,
    Object? duration = null,
    Object? additionalInfo = freezed,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int,
      mood: null == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AICourseRequestImplCopyWith<$Res>
    implements $AICourseRequestCopyWith<$Res> {
  factory _$$AICourseRequestImplCopyWith(_$AICourseRequestImpl value,
          $Res Function(_$AICourseRequestImpl) then) =
      __$$AICourseRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String location,
      String theme,
      int budget,
      String mood,
      int duration,
      String? additionalInfo});
}

/// @nodoc
class __$$AICourseRequestImplCopyWithImpl<$Res>
    extends _$AICourseRequestCopyWithImpl<$Res, _$AICourseRequestImpl>
    implements _$$AICourseRequestImplCopyWith<$Res> {
  __$$AICourseRequestImplCopyWithImpl(
      _$AICourseRequestImpl _value, $Res Function(_$AICourseRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AICourseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? theme = null,
    Object? budget = null,
    Object? mood = null,
    Object? duration = null,
    Object? additionalInfo = freezed,
  }) {
    return _then(_$AICourseRequestImpl(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int,
      mood: null == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AICourseRequestImpl implements _AICourseRequest {
  const _$AICourseRequestImpl(
      {required this.location,
      required this.theme,
      required this.budget,
      required this.mood,
      required this.duration,
      this.additionalInfo});

  factory _$AICourseRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AICourseRequestImplFromJson(json);

  @override
  final String location;
  @override
  final String theme;
  @override
  final int budget;
  @override
  final String mood;
  @override
  final int duration;
  @override
  final String? additionalInfo;

  @override
  String toString() {
    return 'AICourseRequest(location: $location, theme: $theme, budget: $budget, mood: $mood, duration: $duration, additionalInfo: $additionalInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AICourseRequestImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, location, theme, budget, mood, duration, additionalInfo);

  /// Create a copy of AICourseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AICourseRequestImplCopyWith<_$AICourseRequestImpl> get copyWith =>
      __$$AICourseRequestImplCopyWithImpl<_$AICourseRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AICourseRequestImplToJson(
      this,
    );
  }
}

abstract class _AICourseRequest implements AICourseRequest {
  const factory _AICourseRequest(
      {required final String location,
      required final String theme,
      required final int budget,
      required final String mood,
      required final int duration,
      final String? additionalInfo}) = _$AICourseRequestImpl;

  factory _AICourseRequest.fromJson(Map<String, dynamic> json) =
      _$AICourseRequestImpl.fromJson;

  @override
  String get location;
  @override
  String get theme;
  @override
  int get budget;
  @override
  String get mood;
  @override
  int get duration;
  @override
  String? get additionalInfo;

  /// Create a copy of AICourseRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AICourseRequestImplCopyWith<_$AICourseRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
