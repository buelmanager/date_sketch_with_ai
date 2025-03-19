// lib/views/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_providers.dart';
import '../../utils/app_logger.dart';
import '../../utils/theme.dart';
import '../../view_models/auth_view_model.dart';

// 비밀번호 재설정 상태 관리
final forgotPasswordEmailProvider = StateProvider<String>((ref) => '');
final forgotPasswordEmailErrorProvider = StateProvider<String?>((ref) => null);
final forgotPasswordLoadingProvider = StateProvider<bool>((ref) => false);
final forgotPasswordSuccessProvider = StateProvider<bool>((ref) => false);

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(forgotPasswordEmailProvider);
    final emailError = ref.watch(forgotPasswordEmailErrorProvider);
    final isLoading = ref.watch(forgotPasswordLoadingProvider);
    final isSuccess = ref.watch(forgotPasswordSuccessProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '비밀번호 재설정',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSuccess) ...[
                  _buildSuccessMessage(context, email , ref),
                ] else ...[
                  _buildInstructions(context),
                  const SizedBox(height: 24),
                  _buildEmailField(context, ref, email, emailError),
                  const SizedBox(height: 32),
                  _buildResetButton(context, ref, email, isLoading),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          //'비밀번호를 잊으셨나요?',
          "",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '가입 시 등록한 이메일 주소를 입력하시면 비밀번호 재설정 링크를 보내드립니다.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context, WidgetRef ref, String email, String? emailError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '이메일 주소',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '가입한 이메일을 입력하세요',
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: emailError,
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
          onChanged: (value) {
            ref.read(forgotPasswordEmailProvider.notifier).state = value;

            // 이메일 입력 시 오류 초기화
            if (emailError != null) {
              ref.read(forgotPasswordEmailErrorProvider.notifier).state = null;
            }
          },
        ),
      ],
    );
  }

  Widget _buildResetButton(BuildContext context, WidgetRef ref, String email, bool isLoading) {
    final authRepository = ref.read(authRepositoryProvider);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
          // 이메일 유효성 검사
          if (email.isEmpty) {
            ref.read(forgotPasswordEmailErrorProvider.notifier).state = '이메일을 입력해주세요.';
            return;
          }

          if (!authRepository.isValidEmail(email)) {
            ref.read(forgotPasswordEmailErrorProvider.notifier).state = '유효한 이메일 주소를 입력해주세요.';
            return;
          }

          // 키보드 숨기기
          FocusScope.of(context).unfocus();

          // 로딩 상태 시작
          ref.read(forgotPasswordLoadingProvider.notifier).state = true;

          try {
            AppLogger.d('비밀번호 재설정 이메일 전송 시도: $email');

            // 비밀번호 재설정 이메일 전송
            //await authRepository.sendPasswordResetEmail(email);

            // 성공 상태로 변경
            ref.read(forgotPasswordSuccessProvider.notifier).state = true;
            AppLogger.d('비밀번호 재설정 이메일 전송 성공');

          } catch (e) {
            AppLogger.e('비밀번호 재설정 이메일 전송 실패', e);

            // 오류 메시지 설정
            String errorMessage = '비밀번호 재설정 이메일 전송에 실패했습니다.';

            if (e.toString().contains('user-not-found')) {
              errorMessage = '해당 이메일로 가입된 계정이 없습니다.';
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } finally {
            // 로딩 상태 종료
            ref.read(forgotPasswordLoadingProvider.notifier).state = false;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.5),
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Text(
          '비밀번호 재설정 링크 받기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context, String email , ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Icon(
          Icons.check_circle_outline,
          size: 100,
          color: Colors.green[600],
        ),
        const SizedBox(height: 24),
        Text(
          '비밀번호 재설정 이메일이 전송되었습니다',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '$email 주소로 비밀번호 재설정 링크를 발송했습니다.\n이메일을 확인하여 링크를 클릭하고 새 비밀번호를 설정해주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              '로그인 화면으로 돌아가기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // 다시 이메일 입력 화면으로 돌아가기
            ref.read(forgotPasswordSuccessProvider.notifier).state = false;
          },
          child: const Text(
            '다른 이메일로 시도하기',
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