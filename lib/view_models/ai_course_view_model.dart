import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_sketch_with_ai/models/date_course.dart';
import 'package:date_sketch_with_ai/models/date_place.dart';
import 'package:date_sketch_with_ai/services/ai/ai_course_service.dart';
import 'package:date_sketch_with_ai/utils/app_logger.dart';
import 'package:date_sketch_with_ai/models/ai_course_request.dart';
import 'package:date_sketch_with_ai/repositories/ai_course_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CourseCreationStatus {
  initial,
  generating,
  success,
  failure,
}

// AICourseState 클래스 정의
class AICourseState {
  final String location;
  final String theme;
  final int budget;
  final String? mood;
  final int duration;
  final String? additionalInfo;
  final List<String> recentLocations;
  final List<String> popularThemes;
  final CourseCreationStatus status;
  final String? errorMessage;
  final DateCourse? generatedCourse;
  final bool isLoadingLocations;

  const AICourseState({
    this.location = '', // 기본값 설정
    this.theme = '카페 데이트', // 기본값 설정
    this.budget = 50000, // 기본값 설정
    this.mood = '로맨틱한', // 기본값 설정
    this.duration = 2, // 기본값 설정
    this.additionalInfo,
    this.recentLocations = const [],
    this.popularThemes = const ['카페 데이트', '맛집 투어', '문화생활', '액티비티', '힐링'],
    this.status = CourseCreationStatus.initial,
    this.errorMessage,
    this.generatedCourse,
    this.isLoadingLocations = false,
  });

  bool get isFormValid => location.isNotEmpty && theme.isNotEmpty;

  AICourseState copyWith({
    String? location,
    String? theme,
    int? budget,
    String? mood,
    int? duration,
    String? additionalInfo,
    List<String>? recentLocations,
    List<String>? popularThemes,
    CourseCreationStatus? status,
    String? errorMessage,
    DateCourse? generatedCourse,
    bool? isLoadingLocations,
  }) {
    return AICourseState(
      location: location ?? this.location,
      theme: theme ?? this.theme,
      budget: budget ?? this.budget,
      mood: mood ?? this.mood,
      duration: duration ?? this.duration,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      recentLocations: recentLocations ?? this.recentLocations,
      popularThemes: popularThemes ?? this.popularThemes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      generatedCourse: generatedCourse ?? this.generatedCourse,
      isLoadingLocations: isLoadingLocations ?? this.isLoadingLocations,
    );
  }
}

// AICourseViewModel 정의
class AICourseViewModel extends StateNotifier<AICourseState> {
  final AICourseService _aiCourseService = AICourseService();
  final AICourseRepository _aiCourseRepository;

  AICourseViewModel(this._aiCourseRepository) : super(const AICourseState()) {
    // 초기화 시 사용자의 이전 선택 항목 로딩
    loadRecentLocations();
    loadPopularThemes();
  }

  // 최근 위치 목록 로드
  Future<void> loadRecentLocations() async {
    try {
      state = state.copyWith(isLoadingLocations: true);

      // AICourseRepository에서 최근 위치 가져오기
      final recentLocations = await _aiCourseRepository.getRecentLocations();

      state = state.copyWith(
        location: recentLocations[0],
        recentLocations: recentLocations,
        isLoadingLocations: false,
      );

      AppLogger.d("최근 위치 로드 성공: ${recentLocations.length}개");
    } catch (e) {
      AppLogger.e("최근 위치 로드 오류: $e");
      state = state.copyWith(isLoadingLocations: false);
    }
  }

  // 인기 테마 목록 로드
  Future<void> loadPopularThemes() async {
    try {
      final popularThemes = await _aiCourseRepository.getPopularThemes();
      state = state.copyWith(popularThemes: popularThemes);
      AppLogger.d("인기 테마 로드 성공: ${popularThemes.length}개");
    } catch (e) {
      AppLogger.e("인기 테마 로드 오류: $e");
    }
  }

  // 위치 업데이트
  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  // 테마 업데이트
  void updateTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  // 예산 업데이트
  void updateBudget(int budget) {
    state = state.copyWith(budget: budget);
  }

  // 분위기 업데이트
  void updateMood(String mood) {
    state = state.copyWith(mood: mood == state.mood ? null : mood);
  }

  // 시간 업데이트 - int 타입으로 변경
  void updateDuration(int duration) {
    state = state.copyWith(duration: duration);
  }

  // 추가 정보 업데이트
  void updateAdditionalInfo(String additionalInfo) {
    state = state.copyWith(additionalInfo: additionalInfo);
  }

  // 최근 위치 선택
  void selectRecentLocation(String location) {
    state = state.copyWith(location: location);
  }

  // 인기 테마 선택
  void selectPopularTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  // 상태 초기화
  void resetState() {
    state = const AICourseState();
    loadRecentLocations(); // 위치 목록 다시 로딩
    loadPopularThemes(); // 테마 목록 다시 로딩
  }

  // 사용자의 현재 선택 정보 저장
  Future<void> saveCurrentSelections() async {
    try {
      final request = AICourseRequest(
        location: state.location,
        theme: state.theme,
        budget: state.budget,
        mood: state.mood ?? '로맨틱한',
        duration: _getDurationMinutes(state.duration), // minutes로 변환
        additionalInfo: state.additionalInfo,
      );

      await _aiCourseRepository.saveUserSelections(request);
      AppLogger.d("사용자 선택 정보 저장 성공");

      // 저장 후 최근 위치 목록 갱신
      await loadRecentLocations();
    } catch (e) {
      AppLogger.e("사용자 선택 정보 저장 오류: $e");
      // 오류가 발생해도 앱 실행은 계속
    }
  }

  // AI 코스 생성 요청
  Future<void> generateCourse() async {
    if (!state.isFormValid) {
      state = state.copyWith(
        status: CourseCreationStatus.failure,
        errorMessage: '위치와 테마를 모두 입력해주세요.',
      );
      return;
    }

    try {
      // 상태를 생성 중으로 변경
      state = state.copyWith(
        status: CourseCreationStatus.generating,
        errorMessage: null,
      );

      // 현재 사용자 선택 정보 저장
      await saveCurrentSelections();

      // AI 서비스로 코스 생성
      final String formattedBudget = '${state.budget}원';
      // duration을 문자열로 변환
      final String formattedDuration = _getDurationString(state.duration);

      // AI 서비스 호출
      AppLogger.d("AI 코스 생성 시작: 위치=${state.location}, 테마=${state.theme}, 예산=$formattedBudget");

      final result = await _aiCourseService.generateDateCourse(
        location: state.location,
        preferences: state.theme,
        budget: formattedBudget,
        duration: formattedDuration, // 변환된 값 사용
        dateType: null,
        mood: state.mood,
        transportMethod: null,
        specialRequirements: state.additionalInfo,
      );

      AppLogger.d("AI 코스 생성 완료: 응답 길이=${result.length}");

      // 결과 파싱
      final parsedResult = _aiCourseService.parseDateCourseResult(result);

      // 파싱 결과 확인
      if (parsedResult.containsKey('error')) {
        AppLogger.e("AI 응답 파싱 오류: ${parsedResult['error']}");
        throw Exception(parsedResult['error']);
      }

      if ((parsedResult['places'] as List).isEmpty) {
        AppLogger.e("파싱된 장소 정보가 없습니다.");
        throw Exception("코스 내 장소 정보를 찾을 수 없습니다.");
      }

      // DateCourse 객체로 변환
      final dateCourse = _convertToDateCourse(parsedResult);

      // 생성된 코스 저장
      await _aiCourseRepository.saveGeneratedCourse(dateCourse);

      // 성공 상태로 업데이트
      state = state.copyWith(
        status: CourseCreationStatus.success,
        generatedCourse: dateCourse,
        errorMessage: null,
      );

      AppLogger.d("AI 코스 생성 성공: ${dateCourse.title}");
    } catch (e) {
      AppLogger.e("AI 코스 생성 오류: $e");
      state = state.copyWith(
        status: CourseCreationStatus.failure,
        errorMessage: '코스 생성 중 오류가 발생했습니다: $e',
      );
    }
  }

  // 생성된 코스 저장 메서드 추가
  Future<bool> saveCourse() async {
    try {
      if (state.generatedCourse == null) {
        AppLogger.e("저장할 코스가 없습니다.");
        return false;
      }

      AppLogger.d("코스 저장 시작: ${state.generatedCourse!.title}");

      // AICourseRepository를 통해 저장
      await _aiCourseRepository.saveGeneratedCourse(state.generatedCourse!);

      AppLogger.d("코스 저장 성공: ${state.generatedCourse!.id}");
      return true;
    } catch (e) {
      AppLogger.e("코스 저장 오류: $e");
      return false;
    }
  }

  // int 타입의 duration을 String으로 변환하는 도우미 메서드
  String _getDurationString(int duration) {
    switch (duration) {
      case 1:
        return '1시간';
      case 2:
        return '2시간';
      case 3:
        return '3시간';
      case 4:
        return '반나절';
      case 5:
        return '하루종일';
      default:
        return '2시간'; // 기본값
    }
  }

  // int 타입의 duration을 분 단위로 변환하는 도우미 메서드
  int _getDurationMinutes(int duration) {
    switch (duration) {
      case 1:
        return 60;   // 1시간
      case 2:
        return 120;  // 2시간
      case 3:
        return 180;  // 3시간
      case 4:
        return 240;  // 반나절 (4시간)
      case 5:
        return 480;  // 하루종일 (8시간)
      default:
        return 120;  // 기본값 2시간
    }
  }

  // 파싱된 결과를 DateCourse 객체로 변환
  DateCourse _convertToDateCourse(Map<String, dynamic> parsedResult) {
    try {
      final places = (parsedResult['places'] as List<dynamic>).map((place) {
        // 고유 ID 생성
        final String placeId = 'place_${DateTime.now().millisecondsSinceEpoch}_${place['name']}';

        return DatePlace(
          id: placeId,
          name: place['name'] as String,
          category: '데이트 장소', // 기본 카테고리 설정
          imageUrl: 'https://picsum.photos/400/300', // 임시 이미지 URL
          rating: 4.5, // 기본 평점
          address: place['address'] as String,
          description: place['reason'] as String,
          tags: [(place['cost'] as String).trim()], // 비용 정보를 태그로 추가
          reviewCount: 0, // 리뷰 없음
          latitude: 0.0, // 기본값 설정
          longitude: 0.0, // 기본값 설정
          metadata: {
            'activityDescription': place['activity'] as String,
            'recommendedTime': place['time'] as String,
            'estimatedCost': place['cost'] as String,
          },
        );
      }).toList();

      // 예상 소요 시간 계산 (분 단위)
      int estimatedTimeInMinutes = _getDurationMinutes(state.duration);

      // 예상 비용 추정 (예산에서 약 90% 정도 사용한다고 가정)
      int estimatedCost = (state.budget * 0.9).toInt();

      // 태그 생성 (테마 + 분위기 + 기타 관련 태그)
      List<String> tags = [state.theme];
      if (state.mood != null) tags.add(state.mood!);

      // DateCourse 생성
      return DateCourse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "AI 코스: ${state.location} ${state.theme} 데이트",
        description: parsedResult['summary'] as String,
        imageUrl: 'https://picsum.photos/800/400', // 임시 이미지 URL
        rating: 4.8, // 기본 평점
        location: state.location,
        category: state.theme,
        duration: estimatedTimeInMinutes, // 분 단위 소요 시간
        tags: tags,
        places: places,
        reviewCount: 0, // 리뷰 없음
        estimatedTime: estimatedTimeInMinutes,
        estimatedCost: estimatedCost,
        createdBy: 'AI',
        isFavorite: false,
        isFeatured: false,
        transportationInfo: parsedResult['transportPlan'] as String,
        alternativeInfo: parsedResult['alternativePlan'] as String,
      );
    } catch (e) {
      AppLogger.e("DateCourse 변환 오류: $e");
      // 오류 시 기본 DateCourse 반환
      return DateCourse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "AI 코스: ${state.location} ${state.theme} 데이트",
        description: "AI로 생성된 데이트 코스입니다.",
        imageUrl: 'https://picsum.photos/800/400',
        rating: 4.0,
        location: state.location,
        category: state.theme,
        duration: 120, // 기본 2시간
        tags: [state.theme],
        places: [],
        reviewCount: 0,
        estimatedTime: 120,
        estimatedCost: state.budget,
        createdBy: 'AI',
        isFavorite: false,
        isFeatured: false,
        transportationInfo: "",
        alternativeInfo: "",
      );
    }
  }
}

// Provider 등록 (providers/view_model_providers.dart에 사용됨)
final aiCourseRepositoryProvider = Provider<AICourseRepository>((ref) {
  // 실제 앱에서는 여기서 Firebase 인스턴스 등을 주입해야 함
  return AICourseRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final aiCourseViewModelProvider = StateNotifierProvider<AICourseViewModel, AICourseState>((ref) {
  final repository = ref.watch(aiCourseRepositoryProvider);
  return AICourseViewModel(repository);
});