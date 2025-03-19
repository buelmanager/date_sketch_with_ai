// lib/views/profile/profile_screen.dart
import 'package:date_sketch_with_ai/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_providers.dart';
import '../../providers/view_model_providers.dart';
import '../../utils/theme.dart';
import '../../view_models/auth_view_model.dart';
import '../auth/auth_wrapper.dart';
import '../auth/login_screen.dart';
import '../common/app_bottom_navigation.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    AppLogger.d("ProfileScreen build");

    final userProfileState = ref.watch(userProfileViewModelProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: userProfileState.isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      )
          : SafeArea(
        child: userProfileState.profile == null
            ? _buildNotLoggedIn(context, ref)
            : SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildProfileInfo(context, ref, userProfileState),
              _buildStatistics(context, userProfileState),
              _buildMenuSection(context, ref),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_circle, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 24),
          const Text(
            '로그인이 필요합니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // 로그인 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthWrapper(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text(
            '마이페이지',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, WidgetRef ref, userProfileState) {
    final profile = userProfileState.profile!;
    final initial = profile.name.isNotEmpty ? profile.name.substring(0, 1) : '?';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withOpacity(0.1),
              border: Border.all(color: AppTheme.primaryColor, width: 1),
            ),
            child: profile.profileImage.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.network(
                profile.profileImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                },
              ),
            )
                : Center(
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // 사용자 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // 프로필 수정 화면으로 이동
                      },
                      child: const Text(
                        '프로필 수정',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    profile.membershipType,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, userProfileState) {
    final profile = userProfileState.profile!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(context, '방문한 장소', profile.visitedPlaces.toString()),
          _verticalDivider(),
          _buildStatItem(context, '찜한 장소', profile.favoritePlaces.toString()),
          _verticalDivider(),
          _buildStatItem(context, '작성한 리뷰', profile.reviewCount.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String count) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _verticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    final menuItems = [
      {'icon': Icons.history, 'title': '방문 기록', 'subtitle': '최근 방문한 장소를 확인하세요'},
      {'icon': Icons.favorite, 'title': '찜 목록', 'subtitle': '즐겨찾기한 장소를 확인하세요'},
      {'icon': Icons.rate_review, 'title': '나의 리뷰', 'subtitle': '작성한 리뷰를 관리하세요'},
      {'icon': Icons.calendar_today, 'title': '데이트 일정', 'subtitle': '계획된 데이트를 확인하세요'},
      {'icon': Icons.auto_awesome, 'title': 'AI 추천 내역', 'subtitle': 'AI가 추천한 코스를 확인하세요'},
      {'icon': Icons.notifications, 'title': '알림 설정', 'subtitle': '알림 설정을 관리하세요'},
      {'icon': Icons.help_outline, 'title': '고객 지원', 'subtitle': '도움이 필요하신가요?'},
      {'icon': Icons.info_outline, 'title': '앱 정보', 'subtitle': '버전 1.0.0'},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '메뉴',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: menuItems.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey[200]),
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                title: Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
                onTap: () {
                  // 해당 메뉴 아이템 클릭 처리
                  print('Tapped on: ${item['title']}');
                },
              );
            },
          ),
          const SizedBox(height: 20),
          // Center(
          //   child: TextButton(
          //     onPressed: () {
          //       // 로그아웃 확인 다이얼로그 표시
          //       showDialog(
          //         context: context,
          //         builder: (context) => AlertDialog(
          //           title: const Text('로그아웃'),
          //           content: const Text('정말 로그아웃 하시겠습니까?'),
          //           actions: [
          //             TextButton(
          //               onPressed: () => Navigator.pop(context),
          //               child: const Text('취소'),
          //             ),
          //             TextButton(
          //               onPressed: () async {
          //                 Navigator.pop(context); // 다이얼로그 닫기
          //
          //                 // 로그아웃 처리 - 순서 변경 및 await 추가
          //                 try {
          //                   final authVM = ref.read(authViewModelProvider.notifier);
          //                   final profileVM = ref.read(userProfileViewModelProvider.notifier);
          //
          //                   // 1. 사용자 프로필 상태 초기화
          //                   await profileVM.clearProfile();
          //
          //                   // 2. Auth 로그아웃 (Firebase 인증 상태 제거)
          //                   await authVM.logout();
          //
          //                   // 스낵바로 로그아웃 성공 알림
          //                   if (context.mounted) {
          //                     ScaffoldMessenger.of(context).showSnackBar(
          //                       const SnackBar(content: Text('로그아웃되었습니다')),
          //                     );
          //                   }
          //                 } catch (e) {
          //                   // 에러 처리
          //                   if (context.mounted) {
          //                     ScaffoldMessenger.of(context).showSnackBar(
          //                       SnackBar(content: Text('로그아웃 중 오류가 발생했습니다: $e')),
          //                     );
          //                   }
          //                 }
          //               },
          //               child: Text(
          //                 '로그아웃',
          //                 style: TextStyle(color: Colors.red[700]),
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //     child: Text(
          //       '로그아웃',
          //       style: TextStyle(
          //         color: Colors.red[700],
          //         fontSize: 16,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}