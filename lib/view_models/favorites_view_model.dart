import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/favorites_repository.dart';

// 즐겨찾기 상태를 위한 클래스
class FavoritesState {
  final List<String> favoritePlaceIds;
  final bool isLoading;
  final String? errorMessage;

  FavoritesState({
    this.favoritePlaceIds = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FavoritesState copyWith({
    List<String>? favoritePlaceIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FavoritesState(
      favoritePlaceIds: favoritePlaceIds ?? this.favoritePlaceIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class FavoritesViewModel extends StateNotifier<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesViewModel(this._repository) : super(FavoritesState()) {
    // 초기화 시 즐겨찾기 목록 로드
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final favoriteIds = await _repository.getFavoritePlaceIds();
      state = state.copyWith(
        favoritePlaceIds: favoriteIds,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '즐겨찾기 목록을 불러오는 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  Future<void> toggleFavorite(String placeId) async {
    try {
      final newStatus = await _repository.toggleFavorite(placeId);

      // 즐겨찾기 추가
      if (newStatus) {
        state = state.copyWith(
          favoritePlaceIds: [...state.favoritePlaceIds, placeId],
        );
      }
      // 즐겨찾기 해제
      else {
        state = state.copyWith(
          favoritePlaceIds: state.favoritePlaceIds.where((id) => id != placeId).toList(),
        );
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: '즐겨찾기 변경 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  bool isFavorite(String placeId) {
    return state.favoritePlaceIds.contains(placeId);
  }
}