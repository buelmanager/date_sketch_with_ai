// lib/repositories/auth_repository.dart
import 'dart:async';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/auth_request.dart';
import '../utils/app_logger.dart';
class AuthRepository {
  static const String _userKey = 'user_data';
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  // 이메일/비밀번호 로그인
  Future<User> login(LoginRequest request) async {
    try {
      // Firebase 이메일/비밀번호 로그인
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      // Firebase 사용자 정보로 앱 User 모델 생성
      final user = _createUserFromFirebaseUser(userCredential.user);

      // 로컬 저장소에 사용자 정보 저장
      await _saveUserData(user);

      return user;
    } on firebase.FirebaseAuthException catch (e) {
      AppLogger.e('로그인 오류: ${e.code}', e);
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception('이메일 또는 비밀번호가 올바르지 않습니다.');
      } else {
        throw Exception('로그인 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      AppLogger.e('로그인 중 예상치 못한 오류', e);
      throw Exception('로그인 중 오류가 발생했습니다.');
    }
  }

  // Google 로그인
  Future<User> loginWithGoogle() async {
    try {
      // Google 로그인 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google 로그인이 취소되었습니다.');
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase에 Google 인증 정보로 로그인
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Firebase 사용자 정보로 앱 User 모델 생성
      final user = _createUserFromFirebaseUser(userCredential.user);

      // 로컬 저장소에 사용자 정보 저장
      await _saveUserData(user);

      return user;
    } on firebase.FirebaseAuthException catch (e) {
      AppLogger.e('Google 로그인 Firebase 오류: ${e.code}', e);
      throw Exception('Google 로그인 중 오류가 발생했습니다: ${e.message}');
    } catch (e) {
      AppLogger.e('Google 로그인 중 예상치 못한 오류', e);
      throw Exception('Google 로그인 중 오류가 발생했습니다.');
    }
  }

  // 회원가입 기능
  Future<User> register(RegisterRequest request) async {

      isLoading = true;
      try {

        AppLogger.d("email : ${request.email}");
        AppLogger.d("password : ${request.password}");

        // Firebase 이메일/비밀번호 회원가입
        final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: request.email,
          password: request.password,
        );

        // 사용자 프로필 업데이트 (이름 설정)
        await userCredential.user?.updateDisplayName(request.name);

        // Firebase 사용자 정보로 앱 User 모델 생성
        final user = User(
          id: userCredential.user?.uid ?? '',
          email: request.email,
          name: request.name,
          phoneNumber: request.phoneNumber,
        );

        // 로컬 저장소에 사용자 정보 저장
        await _saveUserData(user);

        return user;
      } on firebase.FirebaseAuthException catch (e) {
        AppLogger.e('회원가입 오류: ${e.code}', e);
        if (e.code == 'email-already-in-use') {
          throw Exception('이미 사용 중인 이메일입니다.');
        } else if (e.code == 'weak-password') {
          throw Exception('비밀번호가 너무 약합니다.');
        } else {
          throw Exception('회원가입 중 오류가 발생했습니다: ${e.message}');
        }
      } catch (e) {
        AppLogger.e('회원가입 중 예상치 못한 오류', e);
        throw Exception('회원가입 중 오류가 발생했습니다.');
      }


  }




  // 로그아웃 기능
  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      AppLogger.e('로그아웃 중 오류', e);
      throw Exception('로그아웃 중 오류가 발생했습니다.');
    }
  }

  // 현재 로그인된 사용자 정보 가져오기
  Future<User?> getCurrentUser() async {
    try {
      // 현재 Firebase 인증 사용자 확인
      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser != null) {
        // Firebase 사용자가 있으면 앱 User 모델 반환
        return _createUserFromFirebaseUser(firebaseUser);
      }

      // Firebase 사용자가 없으면 SharedPreferences 확인
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);

      if (userData == null) {
        return null;
      }

      // SharedPreferences에 저장된 사용자 정보로 User 모델 생성
      return User.fromJson(Map<String, dynamic>.from(
        _parseJsonString(userData),
      ));
    } catch (e) {
      AppLogger.e('현재 사용자 정보 확인 중 오류', e);
      return null;
    }
  }

  // Firebase 사용자 정보로 앱 User 모델 생성
  User _createUserFromFirebaseUser(firebase.User? firebaseUser) {
    if (firebaseUser == null) {
      throw Exception('사용자 정보가 없습니다.');
    }

    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '사용자',
      photoUrl: firebaseUser.photoURL,
    );
  }

  // 사용자 정보 저장
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, _stringifyJson(user.toJson()));
  }

  // 이메일 유효성 검사
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  // 비밀번호 유효성 검사
  bool isValidPassword(String password) {
    return password.length >= 6; // Firebase 비밀번호 최소 길이는 6자
  }

  // JSON 문자열화 (실제로는 json.encode 사용)
  String _stringifyJson(Map<String, dynamic> json) {
    return json.toString();
  }

  // JSON 파싱 (실제로는 json.decode 사용)
  Map<String, dynamic> _parseJsonString(String jsonString) {
    // 실제 구현에서는 json.decode 사용
    return {
      'id': '',
      'email': '',
      'name': '',
    };
  }
}