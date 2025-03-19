// lib/views/auth/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app.dart';
import '../../providers/auth_providers.dart';
import 'login_screen.dart';
import '../../utils/app_logger.dart'; // 로그 유틸 추가

/// 인증 상태를 감싸는 AuthWrapper 위젯
/// 사용자 인증 상태에 따라 적절한 화면을 반환함
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger.d("Building AuthWrapper...");
    final authState = ref.watch(authViewModelProvider);

    // 로딩 중 상태 처리
    if (authState.isLoading) {
      AppLogger.d("Auth state is loading...");
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        ),
      );
    }

    AppLogger.i("authState.isAuthenticated ${authState.isAuthenticated} ");
    AppLogger.i("authState.user ${authState.user} ");

    // 인증 상태에 따라 화면 반환
    if (authState.isAuthenticated && authState.user != null) {
      AppLogger.i("User is authenticated. Navigating to HomeScreen.");
      return const DatePlannerApp();
    } else {
      AppLogger.w("User is not authenticated. Navigating to LoginScreen.");
      return const LoginScreen();
    }
  }
}
