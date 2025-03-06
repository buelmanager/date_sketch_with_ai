// lib/repositories/favorites_repository.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_logger.dart'; // 로그 유틸 추가

class FavoritesRepository {
  static const String _favoritesKey = 'favorite_places';

  /// 즐겨찾기 목록 가져오기
  Future<List<String>> getFavoritePlaceIds() async {
    AppLogger.d("Fetching favorite place IDs...");
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    AppLogger.i("Retrieved \${favorites.length} favorite places.");
    return favorites;
  }

  /// 즐겨찾기 추가/제거
  Future<bool> toggleFavorite(String placeId) async {
    AppLogger.d("Toggling favorite status for place ID: \$placeId");
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    bool isFavorite = favorites.contains(placeId);
    if (isFavorite) {
      favorites.remove(placeId);
      AppLogger.i("Removed from favorites: \$placeId");
    } else {
      favorites.add(placeId);
      AppLogger.i("Added to favorites: \$placeId");
    }

    await prefs.setStringList(_favoritesKey, favorites);
    return !isFavorite; // 토글 후 상태 반환
  }

  /// 특정 장소가 즐겨찾기인지 확인
  Future<bool> isFavorite(String placeId) async {
    AppLogger.d("Checking if place ID is favorite: \$placeId");
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    final result = favorites.contains(placeId);
    AppLogger.i("Favorite status for \$placeId: \$result");
    return result;
  }
}
