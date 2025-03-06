// lib/views/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/auth_request.dart';
import '../../providers/auth_providers.dart';
import '../../utils/theme.dart';
import '../../view_models/auth_view_model.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

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
          '회원가입',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildNameField(context, ref, registerState),
                const SizedBox(height: 20),
                _buildEmailField(context, ref, registerState),
                const SizedBox(height: 20),
                _buildPasswordField(context, ref, registerState),
                const SizedBox(height: 20),
                _buildConfirmPasswordField(context, ref, registerState),
                const SizedBox(height: 20),
                _buildPhoneNumberField(context, ref, registerState),
                const SizedBox(height: 20),
                _buildTermsAgreement(context),
                const SizedBox(height: 40),
                _buildRegisterButton(context, ref, registerState, authState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context, WidgetRef ref, RegisterFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '이름',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '이름을 입력하세요',
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: state.nameError,
            prefixIcon: const Icon(Icons.person, color: Colors.grey),
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
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            ref.read(registerViewModelProvider.notifier).updateName(value);
          },
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context, WidgetRef ref, RegisterFormState state) {
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
            ref.read(registerViewModelProvider.notifier).updateEmail(value);
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context, WidgetRef ref, RegisterFormState state) {
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
                ref.read(registerViewModelProvider.notifier).toggleShowPassword();
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
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            ref.read(registerViewModelProvider.notifier).updatePassword(value);
          },
        ),
        const SizedBox(height: 6),
        Text(
          '비밀번호는 6자 이상이어야 합니다.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context, WidgetRef ref, RegisterFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '비밀번호 확인',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '비밀번호를 다시 입력하세요',
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: state.confirmPasswordError,
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                state.showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                ref.read(registerViewModelProvider.notifier).toggleShowConfirmPassword();
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
          obscureText: !state.showConfirmPassword,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            ref.read(registerViewModelProvider.notifier).updateConfirmPassword(value);
          },
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(BuildContext context, WidgetRef ref, RegisterFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '휴대폰 번호',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(선택)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '휴대폰 번호를 입력하세요',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
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
          ),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            ref.read(registerViewModelProvider.notifier).updatePhoneNumber(value);
          },
        ),
      ],
    );
  }

  Widget _buildTermsAgreement(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: true, // 실제 앱에서는 상태 관리 필요
          onChanged: (value) {
            // 동의 상태 변경 처리
          },
          activeColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '서비스 이용약관',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: ' 및 ',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: '개인정보 처리방침',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '에 동의합니다.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context, WidgetRef ref, RegisterFormState registerState, AuthState authState) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: authState.isLoading || !registerState.isValid
            ? null
            : () async {
          // 키보드 닫기
          FocusScope.of(context).unfocus();

          final result = await ref.read(registerViewModelProvider.notifier).register();

          if (result == RegisterResult.success) {
            // 회원가입 성공 시 AuthViewModel 업데이트
            await ref.read(authViewModelProvider.notifier).register(
              RegisterRequest(
                email: registerState.email,
                password: registerState.password,
                name: registerState.name,
                phoneNumber: registerState.phoneNumber,
              ),
            );

            // 홈 화면으로 이동
            if (!context.mounted) return;
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (result == RegisterResult.emailAlreadyExists) {
            // 이미 사용 중인 이메일
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('이미 사용 중인 이메일입니다.')),
            );
          } else if (result == RegisterResult.error) {
            // 기타 오류
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('회원가입 중 오류가 발생했습니다.')),
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
          disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.5),
        ),
        child: authState.isLoading
            ? const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        )
            : const Text(
          '회원가입',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}