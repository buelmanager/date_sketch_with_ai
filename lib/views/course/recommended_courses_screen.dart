import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/view_model_providers.dart';
import '../../utils/theme.dart';
import 'course_detail_screen.dart';

class RecommendedCoursesScreen extends ConsumerWidget {
  final String title;

  const RecommendedCoursesScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: Text(title),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // 필터 기능 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('필터 기능이 곧 추가될 예정입니다')),
              );
            },
          ),
        ],
      ),
      body: homeState.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
        ),
      )
          : homeState.recommendedCourses == null ||
          homeState.recommendedCourses!.isEmpty
          ? _buildEmptyState()
          : _buildCoursesList(context, homeState.recommendedCourses!),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            '추천 데이트 코스가 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '잠시 후 다시 시도해주세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(BuildContext context, List courses) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCourseCard(context, courses[index]),
        );
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, dynamic course) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(course: course),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Stack(
              children: [
                // 이미지
                Hero(
                  tag: 'course_image_${course.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: Image.network(
                      course.imageUrl ?? 'https://picsum.photos/id/237/400/200',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 50,
                              color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                // 카테고리 표시
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      course.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // 북마크 버튼
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      color: AppTheme.primaryColor,
                      onPressed: () {
                        // 북마크 기능 구현
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('저장 기능이 곧 구현될 예정입니다')),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // 텍스트 정보 영역
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.star, size: 20, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '리뷰 ${course.reviews}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          '${course.places.length}곳',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}