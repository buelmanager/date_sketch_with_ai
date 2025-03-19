// lib/repositories/user_profile_repository.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';
import '../utils/app_logger.dart';

class UserProfileRepository {
  static const String _profileKey = 'user_profile';

  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // 생성자에서 Firebase 인스턴스 주입 또는 기본값 사용
  UserProfileRepository({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // 현재 로그인한 사용자 정보 가져오기
  Future<UserProfile?> getUserProfile() async {
    try {
      // 현재 로그인한 사용자 확인
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        AppLogger.d('로그인된 사용자 없음');
        return null;
      }

      AppLogger.d('사용자 프로필 조회: ${currentUser.uid}');

      // Firestore에서 프로필 정보 조회
      final docSnapshot = await _firestore
          .collection('user_profiles')
          .doc(currentUser.uid)
          .get();

      // 로컬 캐시 가져오기
      final prefs = await SharedPreferences.getInstance();
      final cachedProfileJson = prefs.getString(_profileKey);

      if (docSnapshot.exists) {
        // Firestore에 프로필이 있는 경우
        final data = docSnapshot.data()!;
        final profile = UserProfile(
          id: currentUser.uid,
          name: data['name'] ?? currentUser.displayName ?? '사용자',
          email: currentUser.email ?? '',
          profileImage: currentUser.photoURL ?? data['profileImage'] ?? '',
          membershipType: data['membershipType'] ?? '일반',
          visitedPlaces: data['visitedPlaces'] ?? 0,
          favoritePlaces: data['favoritePlaces'] ?? 0,
          reviewCount: data['reviewCount'] ?? 0,
        );

        // 캐시 업데이트
        await saveUserProfile(profile);

        return profile;
      } else if (cachedProfileJson != null) {
        // Firestore에 없지만 로컬 캐시가 있는 경우
        try {
          final cachedProfile = UserProfile.fromJson(jsonDecode(cachedProfileJson));

          // 새 사용자 정보로 기본 정보 업데이트
          final updatedProfile = cachedProfile.copyWith(
            id: currentUser.uid,
            name: currentUser.displayName ?? cachedProfile.name,
            email: currentUser.email ?? cachedProfile.email,
            profileImage: currentUser.photoURL ?? cachedProfile.profileImage,
          );

          // Firestore에 기본 프로필 생성
          await _createDefaultProfile(updatedProfile);

          return updatedProfile;
        } catch (e) {
          AppLogger.e('캐시된 프로필 파싱 실패', e);
        }
      }

      // 새 사용자인 경우 기본 프로필 생성
      return await _createDefaultProfile(
        UserProfile(
          id: currentUser.uid,
          name: currentUser.displayName ?? '사용자',
          email: currentUser.email ?? '',
          profileImage: currentUser.photoURL ?? '',
          membershipType: '일반',
          visitedPlaces: 0,
          favoritePlaces: 0,
          reviewCount: 0,
        ),
      );
    } catch (e) {
      AppLogger.e('사용자 프로필 조회 실패', e);
      return null;
    }
  }

  // 기본 프로필 생성
  Future<UserProfile> _createDefaultProfile(UserProfile profile) async {
    AppLogger.d('새 사용자 기본 프로필 생성: ${profile.id}');

    try {
      // Firestore에 기본 프로필 저장
      await _firestore.collection('user_profiles').doc(profile.id).set({
        'name': profile.name,
        'email': profile.email,
        'profileImage': profile.profileImage,
        'membershipType': profile.membershipType,
        'visitedPlaces': profile.visitedPlaces,
        'favoritePlaces': profile.favoritePlaces,
        'reviewCount': profile.reviewCount,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 로컬 캐시에 저장
      await saveUserProfile(profile);

      return profile;
    } catch (e) {
      AppLogger.e('기본 프로필 생성 실패', e);
      // 오류 발생해도 기본 프로필 반환
      return profile;
    }
  }

  // 로컬 캐시에 프로필 정보 저장
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
      AppLogger.d('프로필 로컬 캐시 저장 완료');
    } catch (e) {
      AppLogger.e('프로필 로컬 캐시 저장 실패', e);
    }
  }

  // 프로필 정보 업데이트
  Future<UserProfile?> updateUserProfile(UserProfile updatedProfile) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        AppLogger.w('로그인되지 않은 상태에서 프로필 업데이트 시도');
        return null;
      }

      // 기본값 설정을 위해 현재 프로필 가져오기
      final docSnapshot = await _firestore
          .collection('user_profiles')
          .doc(currentUser.uid)
          .get();

      // 업데이트할 데이터 준비
      final updateData = {
        'name': updatedProfile.name,
        'profileImage': updatedProfile.profileImage,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // 현재 값이 있는 필드만 업데이트 (0이나 빈 값을 덮어쓰지 않도록)
      if (updatedProfile.membershipType.isNotEmpty) {
        updateData['membershipType'] = updatedProfile.membershipType;
      }

      if (updatedProfile.visitedPlaces > 0 ||
          (docSnapshot.exists && (docSnapshot.data()?['visitedPlaces'] ?? 0) == 0)) {
        updateData['visitedPlaces'] = updatedProfile.visitedPlaces;
      }

      if (updatedProfile.favoritePlaces > 0 ||
          (docSnapshot.exists && (docSnapshot.data()?['favoritePlaces'] ?? 0) == 0)) {
        updateData['favoritePlaces'] = updatedProfile.favoritePlaces;
      }

      if (updatedProfile.reviewCount > 0 ||
          (docSnapshot.exists && (docSnapshot.data()?['reviewCount'] ?? 0) == 0)) {
        updateData['reviewCount'] = updatedProfile.reviewCount;
      }

      // Firestore에 업데이트
      await _firestore
          .collection('user_profiles')
          .doc(currentUser.uid)
          .update(updateData);

      // 최신 정보로 로컬 캐시 업데이트
      await saveUserProfile(updatedProfile);

      AppLogger.d('프로필 업데이트 완료: ${currentUser.uid}');
      return updatedProfile;
    } catch (e) {
      AppLogger.e('프로필 업데이트 실패', e);
      return null;
    }
  }

  // 로그아웃 (로컬 프로필 정보 삭제)
  Future<void> logout() async {
    AppLogger.d('사용자 로그아웃: 프로필 캐시 삭제');
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
    } catch (e) {
      AppLogger.e('로컬 프로필 캐시 삭제 실패', e);
    }
  }

  // 프로필 통계 업데이트
  Future<void> incrementStats({
    int visitedPlaces = 0,
    int favoritePlaces = 0,
    int reviewCount = 0,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        AppLogger.w('로그인되지 않은 상태에서 통계 업데이트 시도');
        return;
      }

      if (visitedPlaces == 0 && favoritePlaces == 0 && reviewCount == 0) {
        return; // 업데이트할 내용이 없음
      }

      final updates = <String, dynamic>{};

      if (visitedPlaces > 0) {
        updates['visitedPlaces'] = FieldValue.increment(visitedPlaces);
      }

      if (favoritePlaces > 0) {
        updates['favoritePlaces'] = FieldValue.increment(favoritePlaces);
      }

      if (reviewCount > 0) {
        updates['reviewCount'] = FieldValue.increment(reviewCount);
      }

      await _firestore
          .collection('user_profiles')
          .doc(currentUser.uid)
          .update(updates);

      AppLogger.d('프로필 통계 업데이트 완료');

      // 로컬 캐시도 업데이트
      final currentProfile = await getUserProfile();
      if (currentProfile != null) {
        await saveUserProfile(currentProfile.copyWith(
          visitedPlaces: currentProfile.visitedPlaces + visitedPlaces,
          favoritePlaces: currentProfile.favoritePlaces + favoritePlaces,
          reviewCount: currentProfile.reviewCount + reviewCount,
        ));
      }
    } catch (e) {
      AppLogger.e('프로필 통계 업데이트 실패', e);
    }
  }
}