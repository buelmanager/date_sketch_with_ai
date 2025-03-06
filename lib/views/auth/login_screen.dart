// lib/views/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/auth_request.dart';
import '../../providers/auth_providers.dart';
import '../../utils/theme.dart';
import '../../view_models/auth_view_model.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildEmailField(context, ref, loginState),
                  const SizedBox(height: 20),
                  _buildPasswordField(context, ref, loginState),
                  const SizedBox(height: 12),
                  _buildForgotPassword(context),
                  const SizedBox(height: 40),
                  _buildLoginButton(context, ref, loginState, authState),
                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildSocialLoginButtons(context,ref),
                  const SizedBox(height: 30),
                  _buildRegisterLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '로그인',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '데이트 플래너에 로그인하고\n다양한 데이트 코스를 탐색해보세요!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context, WidgetRef ref, LoginFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '이메일',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '이메일 주소를 입력하세요',
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: state.emailError,
            prefixIcon: const Icon(Icons.email, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[300]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[300]!),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            ref.read(loginViewModelProvider.notifier).updateEmail(value);
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context, WidgetRef ref, LoginFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '비밀번호',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '비밀번호를 입력하세요',
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: state.passwordError,
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                state.showPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                ref.read(loginViewModelProvider.notifier).toggleShowPassword();
              },
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[300]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[300]!),
            ),
          ),
          obscureText: !state.showPassword,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            ref.read(loginViewModelProvider.notifier).updatePassword(value);
          },
        ),
      ],
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // 비밀번호 찾기 화면으로 이동
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          '비밀번호를 잊으셨나요?',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, WidgetRef ref, LoginFormState loginState, AuthState authState) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
        onPressed: authState.isLoading
        ? null
        : () async {
      // 키보드 닫기
      FocusScope.of(context).unfocus();

      final result = await ref.read(loginViewModelProvider.notifier).login();

      if (result == LoginResult.success) {
        // 로그인 성공 시 AuthViewModel 업데이트
        await ref.read(authViewModelProvider.notifier).login(
          LoginRequest(
            email: loginState.email,
            password: loginState.password,
          ),
        );

        // 홈 화면으로 이동
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (result == LoginResult.invalidCredentials) {
        // 잘못된 인증 정보
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이메일 또는 비밀번호가 올바르지 않습니다.')),
        );
      } else if (result == LoginResult.error) {
        // 기타 오류
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
        );
      }
        },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: authState.isLoading
              ? const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          )
              : const Text(
            '로그인',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '또는',
            style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey[300], thickness: 1),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(
          onPressed: () {
            // 카카오 로그인 처리 (지금은 구현하지 않음)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('카카오 로그인은 현재 지원되지 않습니다.')),
            );
          },
          icon: 'assets/icons/kakao.png',
          color: const Color(0xFFFEE500),
          title: '카카오',
        ),
        _buildSocialButton(
          onPressed: () {
            // 네이버 로그인 처리 (지금은 구현하지 않음)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('네이버 로그인은 현재 지원되지 않습니다.')),
            );
          },
          icon: 'assets/icons/naver.png',
          color: const Color(0xFF03C75A),
          title: '네이버',
        ),
        _buildSocialButton(
          onPressed: () async {
            // 구글 로그인 처리
            try {
              await authViewModel.loginWithGoogle();
              // 홈 화면으로 이동
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Google 로그인 실패: ${e.toString()}')),
                );
              }
            }
          },
          icon: 'assets/icons/google.png',
          color: Colors.white,
          title: '구글',
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required String icon,
    required Color color,
    required String title,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                icon,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  // 아이콘 로드 오류 시 대체 아이콘
                  return Icon(
                    Icons.login,
                    color: title == '카카오' ? Colors.black : Colors.white,
                    size: 24,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '계정이 없으신가요?',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: () {
            // 회원가입 화면으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            ' 가입하기',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}