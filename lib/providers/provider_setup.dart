// lib/providers/provider_setup.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/favorites_repository.dart';
import '../view_models/favorites_view_model.dart';
import '../utils/app_logger.dart'; // 로그 유틸 추가

/// 즐겨찾기 저장소 제공자
/// FavoritesRepository 인스턴스를 생성하여 제공
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  AppLogger.d("Initializing FavoritesRepository"); // 저장소 초기화 로그
  return FavoritesRepository();
});

/// 즐겨찾기 뷰모델 제공자
/// FavoritesViewModel을 상태 관리 객체로 제공
final favoritesViewModelProvider = StateNotifierProvider<FavoritesViewModel, FavoritesState>((ref) {
  AppLogger.d("Initializing FavoritesViewModel"); // 뷰모델 초기화 로그
  final repository = ref.watch(favoritesRepositoryProvider);
  AppLogger.i("FavoritesViewModel created with repository: \$repository");
  return FavoritesViewModel(repository);
});