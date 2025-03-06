import '../models/date_course.dart';
import '../models/date_place.dart';
import '../models/recommendation.dart';
import '../utils/app_logger.dart'; // 로그 유틸 추가

class DateRepository {
  // 실제 환경에서는 API 호출이나 로컬 데이터베이스를 사용할 것입니다.
  // 여기서는 예제를 위해 더미 데이터를 반환합니다.

  Future<Recommendation> getRecommendations() async {
    AppLogger.d("Fetching date recommendations...");

    // 네트워크 호출을 시뮬레이션하기 위한 딜레이
    await Future.delayed(const Duration(milliseconds: 800));

    AppLogger.i("Returning mock date recommendations");

    // 추천 데이트 코스
    final recommendedCourses = [
      const DateCourse(
        id: '1',
        title: '한강 피크닉 데이트',
        description: '한강에서 여유로운 피크닉과 자전거 라이딩을 즐기는 데이트 코스',
        imageUrl: 'assets/images/hangang.jpg',
        rating: 4.8,
        location: '서울 영등포구',
        category: '야외',
        duration: 180,
        tags: ['피크닉', '자전거', '한강'],
        places: [],
        isFavorite: false,
      ),
      const DateCourse(
        id: '2',
        title: '북촌 한옥마을 산책',
        description: '전통과 현대가 공존하는 북촌 한옥마을에서 한복체험과 전통 카페 데이트',
        imageUrl: 'assets/images/bukchon.jpg',
        rating: 4.7,
        location: '서울 종로구',
        category: '문화',
        duration: 240,
        tags: ['한옥', '전통', '문화'],
        places: [],
        isFavorite: true,
      ),
    ];

    // 인기 데이트 장소
    final popularPlaces = [
      const DatePlace(
        id: '1',
        name: '성수동 카페거리',
        category: '카페',
        imageUrl: 'assets/images/cafe_street.jpg',
        rating: 4.5,
        address: '서울 성동구 성수동',
        tags: ['카페', '인스타', '데이트'],
      ),
    ];

    return Recommendation(
      recommendedCourses: recommendedCourses,
      popularPlaces: popularPlaces,
      seasonalCourses: [],
    );
  }

  Future<List<DateCourse>> getRecommendedCourses() async {
    AppLogger.d("Fetching recommended date courses...");
    final recommendation = await getRecommendations();
    AppLogger.i("Recommended date courses retrieved: \${recommendation.recommendedCourses.length}");
    return recommendation.recommendedCourses;
  }

  Future<List<DatePlace>> getPopularPlaces() async {
    AppLogger.d("Fetching popular date places...");
    final recommendation = await getRecommendations();
    AppLogger.i("Popular places retrieved: \${recommendation.popularPlaces.length}");
    return recommendation.popularPlaces;
  }

  Future<void> toggleFavorite(String courseId) async {
    AppLogger.d("Toggling favorite for course ID: \$courseId");
    await Future.delayed(const Duration(milliseconds: 300));
    AppLogger.i("Favorite status updated for course ID: \$courseId");
    return;
  }
}
