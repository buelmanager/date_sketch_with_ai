// lib/providers/view_model_providers.dart 에 추가
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ai_course_request.dart';
import '../repositories/user_profile_repository.dart';

import '../models/date_place.dart';
import '../models/user_profile.dart';
import '../providers/repository_providers.dart';
import '../utils/app_logger.dart';
import '../view_models/explore_view_model.dart';
import '../view_models/home_view_model.dart';
import '../repositories/ai_course_repository.dart';
import '../view_models/ai_course_view_model.dart';


// 사용자 프로필 저장소 프로바이더
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

// 사용자 프로필 뷰모델 프로바이더
final userProfileViewModelProvider = StateNotifierProvider<UserProfileViewModel, UserProfileState>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UserProfileViewModel(repository);
});


// HomeViewModel 제공자
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final dateRepository = ref.watch(dateRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return HomeViewModel(dateRepository, userRepository);
});

// 하단 네비게이션 바 상태를 관리하는 간단한 Provider
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// ExploreViewModel 프로바이더
final exploreViewModelProvider = StateNotifierProvider<ExploreViewModel, ExploreState>((ref) {
  final homeState = ref.watch(homeViewModelProvider);
  List<DatePlace> places = [];

  if (homeState.popularPlaces != null && homeState.popularPlaces!.isNotEmpty) {
    places = List.from(homeState.popularPlaces!);
    // 데이터가 부족한 경우 복제
    if (places.length < 6) {
      places.addAll(List.from(homeState.popularPlaces!));
    }
  } else {
    // 기본 더미 데이터
    places = [
       DatePlace(
        id: '1',
        name: '망원 한강공원',
        category: '야외',
        imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
        rating: 4.7,
        address: '서울 마포구 마포나루길 467',
        tags: ['피크닉', '야경', '자전거'], reviewCount: 1, description: '111', latitude: 1, longitude: 1,
      ),
      // 다른 더미 데이터...
    ];
  }

  return ExploreViewModel(allPlaces: places);
});


class UserProfileState {
  final UserProfile? profile;
  final bool isLoading;
  final String? errorMessage;

  UserProfileState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
  });

  UserProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class UserProfileViewModel extends StateNotifier<UserProfileState> {
  final UserProfileRepository _repository;

  UserProfileViewModel(this._repository) : super(UserProfileState(isLoading: true)) {
    // 초기화 시 사용자 프로필 로드
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final profile = await _repository.getUserProfile();
      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '프로필을 불러오는 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final profile = await _repository.updateUserProfile(updatedProfile);
      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '프로필 업데이트 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await _repository.logout();
      // 로그아웃 후 상태 초기화 또는 로그인 화면으로 이동 로직 추가
      state = UserProfileState(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그아웃 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }
}


// AI 코스 Repository Provider
final aiCourseRepositoryProvider = Provider<AICourseRepository>((ref) {
  return AICourseRepository();
});

// AI 코스 ViewModel Provider
final aiCourseViewModelProvider = StateNotifierProvider<AICourseViewModel, AICourseState>((ref) {
  final repository = ref.watch(aiCourseRepositoryProvider);
  return AICourseViewModel(repository);
});

// 7. HomeScreen 수정 (PromotionBanner의 onCreateCourse 콜백 수정)
// HomeScreen에서 PromotionBanner의 onCreateCourse 콜백을 수정해야 합니다.
// lib/views/home/widgets/promotion_banner.dart의 클릭 이벤트를 수정하고,
// HomeScreen에서 다음과 같이 콜백을 변경합니다:

/*
PromotionBanner(
  onCreateCourse: () {
    // AI 코스 생성 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AICourseCreatorScreen()),
    );
  },
),
*/
