import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_course_request.dart';
import '../models/date_course.dart';
import '../repositories/ai_course_repository.dart';
import '../utils/app_logger.dart';

// 코스 생성 상태
enum CourseCreationStatus {
  initial,
  generating,
  success,
  failure
}

// 코스 생성 화면 상태
class AICourseState {
  final String location;
  final String theme;
  final int budget;
  final String mood;
  final int duration;
  final String? additionalInfo;
  final CourseCreationStatus status;
  final String? errorMessage;
  final DateCourse? generatedCourse;
  final List<String> recentLocations;
  final List<String> popularThemes;

  AICourseState({
    this.location = '',
    this.theme = '',
    this.budget = 50000,
    this.mood = '',
    this.duration = 3,
    this.additionalInfo,
    this.status = CourseCreationStatus.initial,
    this.errorMessage,
    this.generatedCourse,
    this.recentLocations = const [],
    this.popularThemes = const [],
  });

  bool get isFormValid {
    return location.isNotEmpty &&
        theme.isNotEmpty &&
        budget > 0 &&
        mood.isNotEmpty &&
        duration > 0;
  }

  AICourseState copyWith({
    String? location,
    String? theme,
    int? budget,
    String? mood,
    int? duration,
    String? additionalInfo,
    CourseCreationStatus? status,
    String? errorMessage,
    DateCourse? generatedCourse,
    List<String>? recentLocations,
    List<String>? popularThemes,
  }) {
    return AICourseState(
      location: location ?? this.location,
      theme: theme ?? this.theme,
      budget: budget ?? this.budget,
      mood: mood ?? this.mood,
      duration: duration ?? this.duration,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      status: status ?? this.status,
      errorMessage: errorMessage,
      generatedCourse: generatedCourse ?? this.generatedCourse,
      recentLocations: recentLocations ?? this.recentLocations,
      popularThemes: popularThemes ?? this.popularThemes,
    );
  }
}

// AI 코스 생성 ViewModel
class AICourseViewModel extends StateNotifier<AICourseState> {
  final AICourseRepository _repository;

  AICourseViewModel(this._repository) : super(AICourseState()) {
    _loadInitialData();
  }

  // 초기 데이터 로드 (최근 위치, 인기 테마 등)
  Future<void> _loadInitialData() async {
    try {
      final recentLocations = await _repository.getRecentLocations();
      final popularThemes = await _repository.getPopularThemes();

      state = state.copyWith(
        recentLocations: recentLocations,
        popularThemes: popularThemes,
        // 기본값 설정
        mood: '로맨틱한',
        theme: popularThemes.isNotEmpty ? popularThemes.first : '',
      );
    } catch (e) {
      AppLogger.e('초기 데이터 로드 실패', e);
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
    state = state.copyWith(mood: mood);
  }

  // 소요 시간 업데이트
  void updateDuration(int duration) {
    state = state.copyWith(duration: duration);
  }

  // 추가 정보 업데이트
  void updateAdditionalInfo(String additionalInfo) {
    state = state.copyWith(additionalInfo: additionalInfo);
  }

  // AI 코스 생성 요청
  Future<void> generateCourse() async {
    if (!state.isFormValid) {
      state = state.copyWith(
        errorMessage: '모든 필수 항목을 입력해주세요.',
        status: CourseCreationStatus.failure,
      );
      return;
    }

    try {
      state = state.copyWith(
        status: CourseCreationStatus.generating,
        errorMessage: null,
      );

      final request = AICourseRequest(
        location: state.location,
        theme: state.theme,
        budget: state.budget,
        mood: state.mood,
        duration: state.duration,
        additionalInfo: state.additionalInfo,
      );

      AppLogger.d(request.toString());

      // 사용자 선택 데이터 저장
      //await _repository.saveUserSelections(request);

      final course = await _repository.generateAICourse(request);

      state = state.copyWith(
        generatedCourse: course,
        status: CourseCreationStatus.success,
      );

      // 생성된 코스 정보 Firestore에 저장
      //await _repository.saveGeneratedCourse(course);
    } catch (e) {
      AppLogger.e('AI 코스 생성 실패', e);
      state = state.copyWith(
        errorMessage: '코스 생성 중 오류가 발생했습니다: ${e.toString()}',
        status: CourseCreationStatus.failure,
      );
    }
  }

  // 상태 초기화
  void resetState() {
    state = AICourseState(
      recentLocations: state.recentLocations,
      popularThemes: state.popularThemes,
      mood: '로맨틱한',
      theme: state.popularThemes.isNotEmpty ? state.popularThemes.first : '',
      budget: 50000,
      duration: 3,
    );
  }

  // 최근 위치 선택
  void selectRecentLocation(String location) {
    state = state.copyWith(location: location);
  }

  // 인기 테마 선택
  void selectPopularTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  // AICourseViewModel에 메서드 추가
// ai_course_view_model.dart 파일에 아래 메서드 추가

// 코스 수동 저장 (사용자가 "저장하기" 버튼 클릭 시)
  Future<bool> saveCourse() async {
    try {
      if (state.generatedCourse == null) {
        return false;
      }

      // 코스 정보 Firestore에 저장
      await _repository.saveGeneratedCourse(state.generatedCourse!);

      return true;
    } catch (e) {
      AppLogger.e('코스 저장 실패', e);
      return false;
    }
  }
}