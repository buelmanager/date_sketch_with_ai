// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DatePlace _$DatePlaceFromJson(Map<String, dynamic> json) {
  return _DatePlace.fromJson(json);
}

/// @nodoc
mixin _$DatePlace {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this DatePlace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DatePlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DatePlaceCopyWith<DatePlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DatePlaceCopyWith<$Res> {
  factory $DatePlaceCopyWith(DatePlace value, $Res Function(DatePlace) then) =
      _$DatePlaceCopyWithImpl<$Res, DatePlace>;
  @useResult
  $Res call(
      {String id,
      String name,
      String category,
      String imageUrl,
      double rating,
      String address,
      List<String> tags});
}

/// @nodoc
class _$DatePlaceCopyWithImpl<$Res, $Val extends DatePlace>
    implements $DatePlaceCopyWith<$Res> {
  _$DatePlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DatePlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? imageUrl = null,
    Object? rating = null,
    Object? address = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DatePlaceImplCopyWith<$Res>
    implements $DatePlaceCopyWith<$Res> {
  factory _$$DatePlaceImplCopyWith(
          _$DatePlaceImpl value, $Res Function(_$DatePlaceImpl) then) =
      __$$DatePlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String category,
      String imageUrl,
      double rating,
      String address,
      List<String> tags});
}

/// @nodoc
class __$$DatePlaceImplCopyWithImpl<$Res>
    extends _$DatePlaceCopyWithImpl<$Res, _$DatePlaceImpl>
    implements _$$DatePlaceImplCopyWith<$Res> {
  __$$DatePlaceImplCopyWithImpl(
      _$DatePlaceImpl _value, $Res Function(_$DatePlaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of DatePlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? imageUrl = null,
    Object? rating = null,
    Object? address = null,
    Object? tags = null,
  }) {
    return _then(_$DatePlaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DatePlaceImpl implements _DatePlace {
  const _$DatePlaceImpl(
      {required this.id,
      required this.name,
      required this.category,
      required this.imageUrl,
      required this.rating,
      required this.address,
      required final List<String> tags})
      : _tags = tags;

  factory _$DatePlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DatePlaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final String imageUrl;
  @override
  final double rating;
  @override
  final String address;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'DatePlace(id: $id, name: $name, category: $category, imageUrl: $imageUrl, rating: $rating, address: $address, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatePlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, category, imageUrl,
      rating, address, const DeepCollectionEquality().hash(_tags));

  /// Create a copy of DatePlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatePlaceImplCopyWith<_$DatePlaceImpl> get copyWith =>
      __$$DatePlaceImplCopyWithImpl<_$DatePlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DatePlaceImplToJson(
      this,
    );
  }
}

abstract class _DatePlace implements DatePlace {
  const factory _DatePlace(
      {required final String id,
      required final String name,
      required final String category,
      required final String imageUrl,
      required final double rating,
      required final String address,
      required final List<String> tags}) = _$DatePlaceImpl;

  factory _DatePlace.fromJson(Map<String, dynamic> json) =
      _$DatePlaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get category;
  @override
  String get imageUrl;
  @override
  double get rating;
  @override
  String get address;
  @override
  List<String> get tags;

  /// Create a copy of DatePlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatePlaceImplCopyWith<_$DatePlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
