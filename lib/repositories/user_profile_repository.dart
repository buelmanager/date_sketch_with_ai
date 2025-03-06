// lib/repositories/user_profile_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class UserProfileRepository {
  static const String _profileKey = 'user_profile';

  // 프로필 정보 가져오기
  Future<UserProfile> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);

    if (profileJson == null) {
      // 더미 데이터 반환 (실제로는 로그인 상태에 따라 처리)
      return const UserProfile(
        id: 'user123',
        name: '김데이트',
        email: 'couple_love@example.com',
        membershipType: '프리미엄',
        visitedPlaces: 23,
        favoritePlaces: 12,
        reviewCount: 8,
      );
    }

    try {
      return UserProfile.fromJson(jsonDecode(profileJson));
    } catch (e) {
      // 오류 시 기본 프로필 반환
      return const UserProfile(
        id: 'user123',
        name: '김데이트',
        email: 'couple_love@example.com',
      );
    }
  }

  // 프로필 정보 저장
  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  // 프로필 정보 업데이트
  Future<UserProfile> updateUserProfile(UserProfile updatedProfile) async {
    await saveUserProfile(updatedProfile);
    return updatedProfile;
  }

  // 로그아웃 (프로필 정보 삭제)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}