import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  // 사용자 설정 및 즐겨찾기 관련 기능을 처리합니다.

  static const String _favoriteCoursesKey = 'favorite_courses';

  Future<List<String>> getFavoriteCourseIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteCoursesKey) ?? [];
    return favorites;
  }

  Future<void> toggleFavoriteCourse(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteCoursesKey) ?? [];

    if (favorites.contains(courseId)) {
      favorites.remove(courseId);
    } else {
      favorites.add(courseId);
    }

    await prefs.setStringList(_favoriteCoursesKey, favorites);
  }

  Future<bool> isFavoriteCourse(String courseId) async {
    final favorites = await getFavoriteCourseIds();
    return favorites.contains(courseId);
  }
}