import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? phoneNumber,
    String? photoUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserExtension on User {
  String toJsonString() {
    return jsonEncode(toJson());
  }

  static User? fromJsonString(String? jsonString) {
    if (jsonString == null) return null;
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}