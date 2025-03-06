import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/view_model_providers.dart';
import 'utils/theme.dart';
import 'utils/app_logger.dart'; // 로그 라이브러리 사용
import 'views/explore/explore_screen.dart';
import 'views/favorites/favorites_screen.dart';
import 'views/home/home_screen.dart';
import 'views/profile/profile_screen.dart';

/// 앱의 메인 위젯인 DatePlannerApp 클래스
/// ConsumerWidget을 상속받아 Riverpod 상태 관리를 활용함
class DatePlannerApp extends ConsumerWidget {
  const DatePlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // 현재 선택된 하단 네비게이션 바의 인덱스를 구독
    final selectedTabIndex = ref.watch(bottomNavIndexProvider);

    // 앱 시작 시 로그 출력
    AppLogger.i("DatePlannerApp initialized");
    AppLogger.d("Current selected tab index: $selectedTabIndex");

    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
      title: '데이트 플래너', // 앱 타이틀 설정
      theme: AppTheme.lightTheme, // 앱의 테마 설정
      home: _getScreenForIndex(selectedTabIndex), // 선택된 인덱스에 따라 화면 변경
    );
  }

  /// 현재 선택된 탭 인덱스에 따라 화면을 반환하는 메서드
  Widget _getScreenForIndex(int index) {
    AppLogger.d("Navigating to screen with index: $index"); // 네비게이션 로그 추가
    switch (index) {
      case 0:
        AppLogger.i("Loading HomeScreen");
        return const HomeScreen(); // 홈 화면
      case 1:
        AppLogger.i("Loading ExploreScreen");
        return const ExploreScreen(); // 탐색 화면
      case 2:
        AppLogger.i("Loading FavoritesScreen");
        return const FavoritesScreen(); // 즐겨찾기 화면
      case 3:
        AppLogger.i("Loading ProfileScreen");
        return const ProfileScreen(); // 프로필 화면
      default:
        AppLogger.w("Invalid index: $index, defaulting to HomeScreen");
        return const HomeScreen(); // 기본적으로 홈 화면 반환
    }
  }
}