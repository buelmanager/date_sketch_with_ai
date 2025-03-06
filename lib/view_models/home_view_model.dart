import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/date_course.dart';
import '../models/date_place.dart';
import '../repositories/date_repository.dart';
import '../repositories/user_repository.dart';

// HomeViewModel 상태를 위한 클래스
class HomeState {
  final List<DateCourse>? recommendedCourses;
  final List<DatePlace>? popularPlaces;
  final List<DateCourse>? seasonalCourses;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.recommendedCourses,
    this.popularPlaces,
    this.seasonalCourses,
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    List<DateCourse>? recommendedCourses,
    List<DatePlace>? popularPlaces,
    List<DateCourse>? seasonalCourses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      recommendedCourses: recommendedCourses ?? this.recommendedCourses,
      popularPlaces: popularPlaces ?? this.popularPlaces,
      seasonalCourses: seasonalCourses ?? this.seasonalCourses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  final DateRepository _dateRepository;
  final UserRepository _userRepository;

  HomeViewModel(this._dateRepository, this._userRepository) : super(const HomeState(isLoading: true)) {
    // 초기화시 데이터 로드
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final recommendation = await _dateRepository.getRecommendations();

      // 사용자의 즐겨찾기 상태를 적용
      final favoriteIds = await _userRepository.getFavoriteCourseIds();
      final updatedRecommendedCourses = recommendation.recommendedCourses.map((course) {
        return course.copyWith(isFavorite: favoriteIds.contains(course.id));
      }).toList();

      final updatedSeasonalCourses = recommendation.seasonalCourses.map((course) {
        return course.copyWith(isFavorite: favoriteIds.contains(course.id));
      }).toList();

      state = state.copyWith(
        recommendedCourses: updatedRecommendedCourses,
        popularPlaces: recommendation.popularPlaces,
        seasonalCourses: updatedSeasonalCourses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '데이터를 불러오는 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  Future<void> toggleFavorite(String courseId) async {
    try {
      // 즐겨찾기 상태 변경
      await _userRepository.toggleFavoriteCourse(courseId);

      // 추천 코스 업데이트
      if (state.recommendedCourses != null) {
        final updatedRecommendedCourses = state.recommendedCourses!.map((course) {
          if (course.id == courseId) {
            return course.copyWith(isFavorite: !course.isFavorite);
          }
          return course;
        }).toList();

        state = state.copyWith(recommendedCourses: updatedRecommendedCourses);
      }

      // 계절별 코스 업데이트
      if (state.seasonalCourses != null) {
        final updatedSeasonalCourses = state.seasonalCourses!.map((course) {
          if (course.id == courseId) {
            return course.copyWith(isFavorite: !course.isFavorite);
          }
          return course;
        }).toList();

        state = state.copyWith(seasonalCourses: updatedSeasonalCourses);
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: '즐겨찾기 변경 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  Future<void> refreshData() async {
    await loadInitialData();
  }
}