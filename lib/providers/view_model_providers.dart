// lib/providers/view_model_providers.dart 에 추가
import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../repositories/auth_repository.dart';
import '../repositories/user_profile_repository.dart';

import '../models/date_place.dart';
import '../models/user_profile.dart';
import '../providers/repository_providers.dart';
import '../services/auth_service.dart';
import '../utils/app_logger.dart';
import '../view_models/explore_view_model.dart';
import '../view_models/home_view_model.dart';
import '../repositories/ai_course_repository.dart';
import '../view_models/ai_course_view_model.dart';
import '../services/api_service.dart';


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
  StreamSubscription<User?>? _authSubscription;

  UserProfileViewModel(this._repository) : super(UserProfileState(isLoading: true)) {
    // 초기화 시 사용자 프로필 로드
    loadUserProfile();

    // Firebase Auth 상태 변경 감지
    _subscribeToAuthChanges();
  }

  // UserProfileViewModel 클래스에 추가할 메서드
  Future<void> clearProfile() async {
    AppLogger.d("Clearing user profile state");
    state = UserProfileState(isLoading: false, profile: null);
  }

  // Firebase Auth 상태 변경 구독
  void _subscribeToAuthChanges() async {

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      AppLogger.d("Auth state changed: ${user != null ? 'User logged in' : 'User logged out'}");
      if (user != null) {
        // 사용자가 로그인한 경우 프로필 로드
        loadUserProfile();
      } else {
        // 사용자가 로그아웃한 경우 상태 초기화
        state = UserProfileState(isLoading: false);
      }
    });
  }

  Future<void> loadUserProfile() async {

    AppLogger.d("loadUserProfile start");
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
      await AuthService().signOut();
      await GoogleSignIn().signOut();
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

// Firebase 서비스 프로바이더
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Dio 프로바이더
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://your-api-base-url.com/api', // 실제 API URL로 변경
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 인터셉터 추가 (필요시)
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
});

// API 서비스 프로바이더
final apiServiceProvider = Provider<APIService>((ref) {
  final dio = ref.watch(dioProvider);
  return APIService(
    dio: dio,
    useMockData: true, // 테스트용 더미 데이터 사용 (실제 API 연동 시 false로 변경)
  );
});

// AI 코스 Repository Provider
final aiCourseRepositoryProvider = Provider<AICourseRepository>((ref) {
  // 개발 환경에 따라 선택적으로 의존성 주입
  final apiService = ref.watch(apiServiceProvider);

  // Firebase 사용 여부에 따라 선택적으로 주입
  try {
    final firestore = ref.watch(firebaseFirestoreProvider);
    final auth = ref.watch(firebaseAuthProvider);

    return AICourseRepository(
      apiService: apiService,
      firestore: firestore,
      auth: auth,
    );
  } catch (e) {
    AppLogger.w('Firebase 초기화 실패, 더미 데이터만 사용합니다: $e');
    return AICourseRepository(
      apiService: apiService,
    );
  }
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