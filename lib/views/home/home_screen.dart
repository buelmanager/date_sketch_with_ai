import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/view_model_providers.dart';
import '../../utils/theme.dart';
import '../common/app_bottom_navigation.dart';
import 'widgets/category_section.dart';
import 'widgets/date_course_card.dart';
import 'widgets/popular_place_card.dart';
import 'widgets/promotion_banner.dart';
import 'widgets/seasonal_date_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: homeState.isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        )
            : RefreshIndicator(
          onRefresh: () {
            return ref.read(homeViewModelProvider.notifier).refreshData();
          },
          color: AppTheme.primaryColor,
          child: ListView(
            children: [
              _buildHeader(context),
              _buildSearchBar(context),
              _buildQuickActions(context),
              PromotionBanner(
                onCreateCourse: () {
                  // TODO: AI 코스 생성 화면으로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('AI 코스 생성 기능 구현 예정')),
                  );
                },
              ),
              if (homeState.recommendedCourses != null && homeState.recommendedCourses!.isNotEmpty)
                CategorySection(
                  title: "오늘의 추천 데이트",
                  onViewAll: () {
                    // TODO: 추천 데이트 전체보기로 이동
                  },
                  child: SizedBox(
                    height: 270,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: homeState.recommendedCourses!.length,
                      itemBuilder: (context, index) {
                        return DateCourseCard(
                          course: homeState.recommendedCourses![index],
                        );
                      },
                    ),
                  ),
                ),
              if (homeState.popularPlaces != null && homeState.popularPlaces!.isNotEmpty)
                CategorySection(
                  title: "인기 데이트 장소",
                  onViewAll: () {
                    // TODO: 인기 장소 전체보기로 이동
                  },
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: homeState.popularPlaces!.length,
                      itemBuilder: (context, index) {
                        final place = homeState.popularPlaces![index];
                        return PopularPlaceCard(
                          place: place,
                          onTap: () {
                            // TODO: 장소 상세 페이지로 이동
                          },
                        );
                      },
                    ),
                  ),
                ),
              if (homeState.seasonalCourses != null && homeState.seasonalCourses!.isNotEmpty)
                CategorySection(
                  title: "계절별 데이트 코스",
                  onViewAll: () {
                    // TODO: 계절별 데이트 전체보기로 이동
                  },
                  child: SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: homeState.seasonalCourses!.length,
                      itemBuilder: (context, index) {
                        final course = homeState.seasonalCourses![index];
                        return SeasonalDateCard(
                          course: course,
                          backgroundColor: _getSeasonalColor(course.category),
                          onTap: () {
                            // TODO: 코스 상세 페이지로 이동
                          },
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "안녕하세요 💕",
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "오늘의 데이트 ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Text(
                    "어떻게 보낼까요?",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: AppTheme.textColor),
              onPressed: () {
                // TODO: 알림 화면으로 이동
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: '데이트 장소, 코스 검색하기',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.primaryColor),
            onPressed: () {
              // TODO: 검색 필터 다이얼로그 표시
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppTheme.primaryColor),
          ),
        ),
        onTap: () {
          // TODO: 검색 페이지로 이동
          // 포커스를 해제하고 검색 페이지로 이동
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.restaurant, 'label': '맛집'},
      {'icon': Icons.local_cafe, 'label': '카페'},
      {'icon': Icons.movie, 'label': '영화'},
      {'icon': Icons.park, 'label': '공원'},
      {'icon': Icons.attractions, 'label': '액티비티'},
    ];

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          return Container(
            width: 70,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      actions[index]['icon'] as IconData,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      // TODO: 카테고리별 데이트 장소 목록으로 이동
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${actions[index]['label']} 카테고리 선택')),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  actions[index]['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getSeasonalColor(String season) {
    switch (season.toLowerCase()) {
      case '봄':
        return const Color(0xFFFFC8DD); // 파스텔 핑크
      case '여름':
        return const Color(0xFF90E0EF); // 밝은 블루
      case '가을':
        return const Color(0xFFFFD670); // 노란색
      case '겨울':
        return const Color(0xFFCCE8DB); // 민트
      default:
        return const Color(0xFFFADCD9); // 기본 연한 핑크
    }
  }
}