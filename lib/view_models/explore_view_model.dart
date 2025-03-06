// lib/view_models/explore_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/date_place.dart';
import '../models/explore_filter.dart';

class ExploreState {
  final ExploreFilter filter;
  final List<DatePlace> filteredPlaces;
  final bool isLoading;
  final String? errorMessage;

  ExploreState({
    required this.filter,
    this.filteredPlaces = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ExploreState copyWith({
    ExploreFilter? filter,
    List<DatePlace>? filteredPlaces,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExploreState(
      filter: filter ?? this.filter,
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ExploreViewModel extends StateNotifier<ExploreState> {
  final List<DatePlace> allPlaces;
  final List<String> categories = ['전체', '맛집', '카페', '문화', '액티비티', '야외', '실내'];

  ExploreViewModel({required this.allPlaces})
      : super(ExploreState(filter: const ExploreFilter())) {
    // 초기화 시 필터링 적용
    filterPlaces();
  }

  void filterPlaces() {
    final filter = state.filter;
    var result = List<DatePlace>.from(allPlaces);

    // 카테고리 필터링
    if (filter.category != '전체') {
      result = result.where((place) => place.category == filter.category).toList();
    }

    // 검색어 필터링
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();
      result = result.where((place) =>
      place.name.toLowerCase().contains(query) ||
          place.address.toLowerCase().contains(query) ||
          place.tags.any((tag) => tag.toLowerCase().contains(query))
      ).toList();
    }

    // 평점 필터링
    if (filter.minRating > 0) {
      result = result.where((place) => place.rating >= filter.minRating).toList();
    }

    state = state.copyWith(filteredPlaces: result);
  }

  void updateCategory(String category) {
    state = state.copyWith(
      filter: state.filter.copyWith(category: category),
    );
    filterPlaces();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(
      filter: state.filter.copyWith(searchQuery: query),
    );
    filterPlaces();
  }

  void clearSearch() {
    state = state.copyWith(
      filter: state.filter.copyWith(searchQuery: ''),
    );
    filterPlaces();
  }

  void updateTabIndex(int index) {
    state = state.copyWith(
      filter: state.filter.copyWith(tabIndex: index),
    );
  }

  void updateMinRating(double rating) {
    state = state.copyWith(
      filter: state.filter.copyWith(minRating: rating),
    );
    filterPlaces();
  }

  void updateMaxDistance(double distance) {
    state = state.copyWith(
      filter: state.filter.copyWith(maxDistance: distance),
    );
    filterPlaces();
  }

  void resetFilters() {
    state = state.copyWith(
      filter: const ExploreFilter(),
    );
    filterPlaces();
  }
}