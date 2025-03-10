import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/app_logger.dart';

/// 사용자 인증 서비스
class AuthService {
  final FirebaseAuth _auth;

  /// 생성자
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  /// 현재 로그인한 사용자 가져오기
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  /// 현재 사용자의 ID 가져오기
  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }

  /// 이메일/비밀번호로 회원가입
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      AppLogger.e('이메일 회원가입 실패', e);
      rethrow;
    }
  }

  /// 이메일/비밀번호로 로그인
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      AppLogger.e('이메일 로그인 실패', e);
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {

    try {

      await _auth.signOut();
    } catch (e) {
      AppLogger.e('로그아웃 실패', e);
      rethrow;
    }
  }

  /// 익명 로그인
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      AppLogger.e('익명 로그인 실패', e);
      rethrow;
    }
  }

  /// 사용자 삭제
  Future<void> deleteUser() async {


    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      AppLogger.e('사용자 삭제 실패', e);
      rethrow;
    }
  }

  /// 비밀번호 재설정 이메일 전송
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      AppLogger.e('비밀번호 재설정 이메일 전송 실패', e);
      rethrow;
    }
  }


  /// 인증 상태 변경 리스너
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}