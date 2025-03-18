// lib/views/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_providers.dart';
import '../../utils/app_logger.dart';
import '../../utils/theme.dart';
import '../auth/auth_wrapper.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          '설정',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  title: '계정',
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.person_outline,
                      title: '프로필 편집',
                      onTap: () {
                        // 프로필 편집 화면으로 이동
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('프로필 편집 기능은 준비 중입니다.')),
                        );
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.password_outlined,
                      title: '비밀번호 변경',
                      onTap: () {
                        // 비밀번호 변경 화면으로 이동
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('비밀번호 변경 기능은 준비 중입니다.')),
                        );
                      },
                    ),
                  ],
                ),

                _buildSection(
                  title: '알림',
                  children: [
                    _buildSwitchItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: '푸시 알림',
                      value: true,
                      onChanged: (value) {
                        // 푸시 알림 설정 변경
                        AppLogger.d('푸시 알림 설정: $value');
                      },
                    ),
                    _buildSwitchItem(
                      context,
                      icon: Icons.email_outlined,
                      title: '이메일 알림',
                      value: false,
                      onChanged: (value) {
                        // 이메일 알림 설정 변경
                        AppLogger.d('이메일 알림 설정: $value');
                      },
                    ),
                  ],
                ),

                _buildSection(
                  title: '앱 설정',
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.language_outlined,
                      title: '언어',
                      subtitle: '한국어',
                      onTap: () {
                        // 언어 설정 화면으로 이동
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('언어 설정 기능은 준비 중입니다.')),
                        );
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.color_lens_outlined,
                      title: '테마',
                      subtitle: '시스템 설정',
                      onTap: () {
                        // 테마 설정 화면으로 이동
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('테마 설정 기능은 준비 중입니다.')),
                        );
                      },
                    ),
                    _buildSwitchItem(
                      context,
                      icon: Icons.location_on_outlined,
                      title: '위치 서비스',
                      value: true,
                      onChanged: (value) {
                        // 위치 서비스 설정 변경
                        AppLogger.d('위치 서비스 설정: $value');
                      },
                    ),
                  ],
                ),

                _buildSection(
                  title: '정보',
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.help_outline,
                      title: '고객 지원',
                      onTap: () {
                        // 고객 지원 화면으로 이동
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('고객 지원 기능은 준비 중입니다.')),
                        );
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: '개인정보 처리방침',
                      onTap: () {
                        // 개인정보 처리방침 화면으로 이동
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('개인정보 처리방침 기능은 준비 중입니다.')),
                        );
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.description_outlined,
                      title: '이용약관',
                      onTap: () {
                        // 이용약관 화면으로 이동
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이용약관 기능은 준비 중입니다.')),
                        );
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.info_outline,
                      title: '앱 버전',
                      subtitle: '1.0.0',
                      onTap: null,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildLogoutButton(context, ref),

                const SizedBox(height: 16),

                _buildDeleteAccountButton(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 섹션 위젯
  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  // 일반 설정 아이템
  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      )
          : null,
      trailing: onTap != null
          ? const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      )
          : null,
      onTap: onTap,
    );
  }

  // 스위치 설정 아이템
  Widget _buildSwitchItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        required bool value,
        required ValueChanged<bool> onChanged,
      }) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      )
          : null,
      value: value,
      activeColor: AppTheme.primaryColor,
      onChanged: onChanged,
    );
  }

  // 로그아웃 버튼
  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // 로그아웃 확인 다이얼로그
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('로그아웃'),
              content: const Text('정말 로그아웃 하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('로그아웃'),
                ),
              ],
            ),
          );

          if (shouldLogout == true && context.mounted) {
            try {
              // 로그아웃 처리
              await ref.read(authViewModelProvider.notifier).logout();

              // 로그인 화면으로 이동
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthWrapper()),
                      (route) => false,
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('로그아웃 중 오류가 발생했습니다: ${e.toString()}')),
                );
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red[300]!),
          ),
        ),
        child: const Text(
          '로그아웃',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 계정 삭제 버튼
  Widget _buildDeleteAccountButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('계정 삭제'),
              content: const Text(
                '계정을 삭제하면 모든 데이터가 영구적으로 사라집니다. 정말 삭제하시겠습니까?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('계정 삭제 기능은 준비 중입니다.')),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('삭제'),
                ),
              ],
            ),
          );
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey[700],
        ),
        child: const Text(
          '계정 삭제',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}