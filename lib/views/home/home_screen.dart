import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/place.dart';
import '../../providers/view_model_providers.dart';
import '../../utils/theme.dart';
import '../common/app_bottom_navigation.dart';
import '../course/ai_course_creator_screen.dart';
import '../course/course_detail_screen.dart';
import '../course/recommended_courses_screen.dart';
import '../place/place_detail_screen.dart';
import '../place/popular_places_screen.dart';
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
                    //_buildSearchBar(context),
                    _buildQuickActions(context),
                    PromotionBanner(
                      onCreateCourse: () {
                        // AI 코스 생성 화면으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AICourseCreatorScreen()),
                        );
                      },
                    ),
                    if (homeState.recommendedCourses != null &&
                        homeState.recommendedCourses!.isNotEmpty)
                      CategorySection(
                        title: "오늘의 추천 데이트",
                        onViewAll: () {
                          // 추천 데이트 전체보기 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RecommendedCoursesScreen(
                                title: "오늘의 추천 데이트",
                              ),
                            ),
                          );
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
                    if (homeState.popularPlaces != null &&
                        homeState.popularPlaces!.isNotEmpty)
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "인기 데이트 장소",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // 인기 장소 전체보기 화면으로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PopularPlacesScreen(
                                          title: "인기 데이트 장소",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      const Text(
                                        "전체보기",
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              itemCount: homeState.popularPlaces!.length,
                              itemBuilder: (context, index) {
                                final place = homeState.popularPlaces![index];
                                return PopularPlaceCard(
                                  place: place,
                                  onTap: () {
                                    // 장소 상세 페이지로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaceDetailScreen(
                                          place: Place(
                                            id: place.id,
                                            name: place.name,
                                            category: place.category,
                                            address: place.address,
                                            description: place.description,
                                            imageUrl: place.imageUrl,
                                            rating: place.rating,
                                            reviews: place.reviewCount,
                                            latitude: place.latitude,
                                            longitude: place.longitude,
                                            isFavorite: place.isFavorite,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    if (homeState.seasonalCourses != null &&
                        homeState.seasonalCourses!.isNotEmpty)
                      CategorySection(
                        title: "계절별 데이트 코스",
                        onViewAll: () {
                          // 계절별 데이트 전체보기로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RecommendedCoursesScreen(
                                title: "계절별 데이트 코스",
                              ),
                            ),
                          );
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
                                backgroundColor:
                                    _getSeasonalColor(course.category),
                                onTap: () {
                                  // 코스 상세 페이지로 이동
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CourseDetailScreen(
                                        course: course,
                                      ),
                                    ),
                                  );
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
              icon: const Icon(Icons.notifications_none,
                  color: AppTheme.textColor),
              onPressed: () {
                // 알림 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('알림 기능이 곧 추가될 예정입니다')),
                );
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
              // 검색 필터 다이얼로그 표시
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('검색 필터 기능이 곧 추가될 예정입니다')),
              );
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
          // 포커스를 해제하고 검색 페이지로 이동
          FocusScope.of(context).unfocus();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const SearchScreen()),
          // );
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.restaurant,
        'label': '맛집',
        'color': const Color(0xFFFD6B68),
        'background': const Color(0xFFFDE7E6),
      },
      {
        'icon': Icons.local_cafe,
        'label': '카페',
        'color': const Color(0xFF8D6E63),
        'background': const Color(0xFFEEE5E1),
      },
      {
        'icon': Icons.movie,
        'label': '영화',
        'color': const Color(0xFF5C6BC0),
        'background': const Color(0xFFE0E4F5),
      },
      {
        'icon': Icons.park,
        'label': '공원',
        'color': const Color(0xFF66BB6A),
        'background': const Color(0xFFE3F3E4),
      },
      {
        'icon': Icons.attractions,
        'label': '액티비티',
        'color': const Color(0xFFFFB74D),
        'background': const Color(0xFFFFF3E0),
      },
    ];

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // 카테고리별 데이트 장소 목록으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PopularPlacesScreen(
                          title: '${actions[index]['label']} 장소',
                          category: actions[index]['label'] as String,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: actions[index]['background'] as Color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (actions[index]['color'] as Color)
                              .withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      actions[index]['icon'] as IconData,
                      color: actions[index]['color'] as Color,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  actions[index]['label'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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

  // Widget _buildQuickActions(BuildContext context) {
  //   final actions = [
  //     {'icon': Icons.restaurant, 'label': '맛집'},
  //     {'icon': Icons.local_cafe, 'label': '카페'},
  //     {'icon': Icons.movie, 'label': '영화'},
  //     {'icon': Icons.park, 'label': '공원'},
  //     {'icon': Icons.attractions, 'label': '액티비티'},
  //   ];
  //
  //   return Container(
  //     height: 100,
  //     margin: const EdgeInsets.symmetric(vertical: 15),
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 15),
  //       itemCount: actions.length,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           width: 70,
  //           margin: const EdgeInsets.symmetric(horizontal: 5),
  //           child: Column(
  //             children: [
  //               Container(
  //                 width: 60,
  //                 height: 60,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(16),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: AppTheme.primaryColor.withOpacity(0.15),
  //                       blurRadius: 10,
  //                       offset: const Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: IconButton(
  //                   icon: Icon(
  //                     actions[index]['icon'] as IconData,
  //                     color: AppTheme.primaryColor,
  //                   ),
  //                   onPressed: () {
  //                     // 카테고리별 데이트 장소 목록으로 이동
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PopularPlacesScreen(
  //                           title: '${actions[index]['label']} 장소',
  //                           category: actions[index]['label'] as String,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 actions[index]['label'] as String,
  //                 style: const TextStyle(
  //                   fontSize: 12,
  //                   color: AppTheme.textColor,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

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
