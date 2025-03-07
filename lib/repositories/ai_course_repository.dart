import 'dart:async';
import 'dart:math';

import '../models/ai_course_request.dart';
import '../models/date_course.dart';
import '../models/date_place.dart';
import '../utils/app_logger.dart';

class AICourseRepository {
  // 실제 환경에서는 API 호출, DB 접근 등이 필요합니다.
  // 여기서는 예시로 더미 데이터를 반환합니다.

  // 최근 위치 가져오기
  Future<List<String>> getRecentLocations() async {
    // 실제로는 사용자의 이전 기록이나 위치 데이터베이스에서 가져와야 함
    await Future.delayed(const Duration(milliseconds: 300));
    return ['강남', '홍대', '이태원', '명동', '여의도', '잠실'];
  }

  // 인기 테마 가져오기
  Future<List<String>> getPopularThemes() async {
    // 실제로는 인기 테마 API나 DB에서 가져와야 함
    await Future.delayed(const Duration(milliseconds: 300));
    return ['맛집 투어', '카페 데이트', '문화생활', '자연 속 데이트', '액티비티', '쇼핑'];
  }

  // AI 코스 생성 요청
  Future<DateCourse> generateAICourse(AICourseRequest request) async {
    try {
      // 실제로는 AI API 호출
      AppLogger.d('AI 코스 생성 요청: ${request.toJson()}');

      // API 호출 시뮬레이션 (2-4초 딜레이)
      await Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(2000)));

      // 더미 데이터 반환
      final places = [
        DatePlace(
          id: 'place_${Random().nextInt(1000)}',
          name: '${request.mood} ${request.theme} 장소',
          category: _getCategoryFromTheme(request.theme),
          address: '${request.location} 어딘가',
          rating: 4.5 + (Random().nextDouble() / 2),
          reviewCount: 100 + Random().nextInt(900),
          imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
          description: '${request.mood} 분위기의 멋진 장소입니다. ${request.theme}을(를) 즐기기에 완벽한 곳이에요.', tags: [], latitude: 1, longitude: 1,
        ),
        DatePlace(
          id: 'place_${Random().nextInt(1000)}',
          name: '아늑한 ${_getCategoryFromTheme(request.theme)}',
          category: _getCategoryFromTheme(request.theme),
          address: '${request.location} 중심지',
          rating: 4.5 + (Random().nextDouble() / 2),
          reviewCount: 100 + Random().nextInt(900),
          imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
          description: '${request.location}의 중심부에 위치한 아늑한 장소입니다. ${request.budget ~/ 2}원 정도의 비용으로 즐길 수 있어요.', tags: [], latitude: 1, longitude: 1,
        ),
        DatePlace(
          id: 'place_${Random().nextInt(1000)}',
          name: '${request.mood} 특별 장소',
          category: _getRandomCategory(),
          address: '${request.location} 북쪽',
          rating: 4.5 + (Random().nextDouble() / 2),
          reviewCount: 100 + Random().nextInt(900),
          imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
          description: '${request.duration}시간 코스의 마지막을 장식할 완벽한 장소입니다. ${request.additionalInfo ?? '특별한 경험을 선사합니다.'}', tags: [], latitude: 1, longitude: 1,
        ),
      ];

      return DateCourse(
        id: 'course_${Random().nextInt(1000)}',
        title: '${request.location}의 ${request.mood} ${request.theme} 데이트',
        description: '${request.budget}원으로 즐기는 ${request.duration}시간 코스의 ${request.mood} 데이트입니다. ${request.additionalInfo ?? ''}',
        rating: 4.5 + (Random().nextDouble() / 2),
        reviewCount: 10 + Random().nextInt(90),
        imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
        category: request.theme,
        estimatedTime: request.duration,
        estimatedCost: request.budget,
        isFavorite: false,
        places: places, location: '', duration: 1, tags: [],
      );
    } catch (e) {
      AppLogger.e('AI 코스 생성 중 오류 발생', e);
      rethrow;
    }
  }

  // 테마에 따른 카테고리 반환
  String _getCategoryFromTheme(String theme) {
    switch (theme.toLowerCase()) {
      case '맛집 투어':
        return '맛집';
      case '카페 데이트':
        return '카페';
      case '문화생활':
        return '문화시설';
      case '자연 속 데이트':
        return '자연/공원';
      case '액티비티':
        return '액티비티';
      case '쇼핑':
        return '쇼핑';
      default:
        return '기타';
    }
  }

  // 랜덤 카테고리 반환
  String _getRandomCategory() {
    final categories = ['맛집', '카페', '문화시설', '자연/공원', '액티비티', '쇼핑'];
    return categories[Random().nextInt(categories.length)];
  }
}