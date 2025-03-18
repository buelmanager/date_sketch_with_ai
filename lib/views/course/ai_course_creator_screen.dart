import 'package:date_sketch_with_ai/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/theme.dart';
import '../../../view_models/ai_course_view_model.dart';
import '../common/loading_overlay.dart';
import '../timeline_tile/timeline_course_preview.dart';
import 'widgets/budget_slider.dart';
import 'widgets/chip_selection.dart';
import 'widgets/duration_selector.dart';
import 'map_selection_screen.dart'; // 지도 선택 화면 import

class AICourseCreatorScreen extends ConsumerStatefulWidget {
  const AICourseCreatorScreen({super.key});

  @override
  AICourseCreatorScreenState createState() => AICourseCreatorScreenState();
}

class AICourseCreatorScreenState extends ConsumerState<AICourseCreatorScreen> {
  late TextEditingController locationController;
  late TextEditingController themeController;
  late TextEditingController additionalInfoController;
  List<String> savedLocations = [];
  bool isLoadingLocations = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _resultKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final courseState = ref.read(aiCourseViewModelProvider);
    locationController = TextEditingController(text: courseState.location);
    themeController = TextEditingController(text: courseState.theme);
    additionalInfoController = TextEditingController(text: courseState.additionalInfo ?? '');

    // 한글 입력 방식 설정
    SystemChannels.textInput.invokeMethod('TextInput.setImeConfig', {
      'type': 'TextInputType.text',
      'autocorrect': false,
    });
  }

  @override
  void dispose() {
    locationController.dispose();
    themeController.dispose();
    additionalInfoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(aiCourseViewModelProvider);
    final courseViewModel = ref.read(aiCourseViewModelProvider.notifier);

    // 한글 입력 문제를 해결하기 위해 상태 변경 시 컨트롤러 업데이트 처리 수정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 포커스가 없는 필드만 업데이트
      if (FocusManager.instance.primaryFocus?.context?.widget is! TextField) {
        _updateControllerValueIfNeeded(locationController, courseState.location);
        _updateControllerValueIfNeeded(themeController, courseState.theme);
        _updateControllerValueIfNeeded(additionalInfoController, courseState.additionalInfo ?? '');
      }

      // 코스 생성 완료 시 결과 영역으로 애니메이션 스크롤
      if (courseState.status == CourseCreationStatus.success &&
          courseState.generatedCourse != null &&
          _resultKey.currentContext != null) {
        // 약간의 지연을 두어 UI가 완전히 렌더링된 후 스크롤
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_resultKey.currentContext != null) {
            Scrollable.ensureVisible(
              _resultKey.currentContext!,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'AI 맞춤 데이트 코스',
          style: TextStyle(color: AppTheme.textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
            onPressed: () {
              courseViewModel.resetState();
              // 컨트롤러 값도 초기화
              locationController.clear();
              themeController.clear();
              additionalInfoController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('입력 내용이 초기화되었습니다.')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                const SizedBox(height: 24),
                _buildLocationSection(context, courseState, courseViewModel),
                const SizedBox(height: 20),
                _buildThemeSection(context, courseState, courseViewModel),
                const SizedBox(height: 20),
                _buildBudgetSection(context, courseState, courseViewModel),
                const SizedBox(height: 20),
                _buildMoodSection(context, courseState, courseViewModel),
                const SizedBox(height: 20),
                _buildDurationSection(context, courseState, courseViewModel), // 데이트 시간 섹션
                const SizedBox(height: 20),
                _buildAdditionalInfoSection(context, courseState, courseViewModel),
                const SizedBox(height: 30),
                _buildGenerateButton(context, courseState, courseViewModel),
                const SizedBox(height: 30),

                // 생성된 코스가 있을 경우 타임라인 UI로 표시
                if (courseState.status == CourseCreationStatus.success && courseState.generatedCourse != null)
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    key: _resultKey,
                    child: TimelineCoursePreview(
                      course: courseState.generatedCourse!,
                      formattedDuration: _getFormattedDuration(courseState.duration),
                      onSave: () async {
                        final success = await courseViewModel.saveCourse();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? '코스가 저장되었습니다.' : '코스 저장에 실패했습니다.'),
                              backgroundColor: success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),

          // 로딩 오버레이
          if (courseState.status == CourseCreationStatus.generating)
            const LoadingOverlay(message: 'AI가 데이트 코스를 생성중입니다...\n잠시만 기다려주세요!'),
        ],
      ),
    );
  }

  // 소요 시간 포맷팅
  String _getFormattedDuration(int duration) {
    switch (duration) {
      case 1:
        return '1시간';
      case 2:
        return '2시간';
      case 3:
        return '3시간';
      case 4:
        return '반나절 (4시간)';
      case 5:
        return '하루종일 (8시간)';
      default:
        return '2시간';
    }
  }

  // 한글 입력 문제를 해결하기 위해 수정된 메서드
  // 컨트롤러 값이 상태와 다를 경우에만 갱신하고 커서 위치 유지
  void _updateControllerValueIfNeeded(TextEditingController controller, String newValue) {
    // 현재 텍스트 필드에 포커스가 있다면 업데이트하지 않음
    // 한글 조합 중에는 컨트롤러 값을 강제로 업데이트하지 않도록 함
    if (FocusManager.instance.primaryFocus?.hasFocus == true &&
        controller == FocusManager.instance.primaryFocus?.context?.widget is TextField) {
      return;
    }

    if (controller.text != newValue) {
      final selection = controller.selection;
      controller.text = newValue;
      // 커서 위치 복원 시도
      try {
        if (selection.baseOffset < newValue.length) {
          controller.selection = selection;
        }
      } catch (e) {
        // 커서 위치 복원 실패 시 무시
      }
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '나만의 데이트 코스 만들기',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'AI가 당신에게 딱 맞는 데이트 코스를 추천해드려요!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context, AICourseState state, AICourseViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어디에서 데이트를 할 계획인가요?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: '장소를 입력하세요 (예: 강남, 홍대)',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.location_on, color: AppTheme.primaryColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                  ),
                  // 오류 메시지 표시를 위한 설정
                  errorText: _hasKoreanJamoError(locationController.text) ? '완성된 한글을 입력해주세요' : null,
                ),
                onChanged: viewModel.updateLocation,
                // 한글 입력 처리 개선
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                // IME 전환 옵션 추가
                enableIMEPersonalizedLearning: true,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.map, color: AppTheme.primaryColor),
              onPressed: () => _gotoMapScreen(context, viewModel),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.isLoadingLocations)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (state.recentLocations.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ChipSelection(
              title: '최근 위치',
              items: state.recentLocations,
              selectedItem: state.location,
              onSelected: (location) {
                locationController.text = location;
                viewModel.selectRecentLocation(location);
              },
            ),
          ),
      ],
    );
  }

  Future<void> _gotoMapScreen(BuildContext context, AICourseViewModel viewModel) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => MapSelectionScreen(
          initialAddress: locationController.text,
        ),
      ),
    );

    // 위치가 선택되었으면 텍스트 필드 업데이트
    if (result != null && result.containsKey('address')) {
      final selectedAddress = result['address'] as String;
      setState(() {
        locationController.text = selectedAddress;
      });
      viewModel.updateLocation(selectedAddress);
    }
  }

  Widget _buildThemeSection(BuildContext context, AICourseState state, AICourseViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 테마의 데이트를 원하시나요?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: themeController,
          decoration: InputDecoration(
            hintText: '테마를 입력하세요 (예: 맛집 투어, 카페 데이트)',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.category, color: AppTheme.primaryColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
            // 오류 메시지 표시를 위한 설정
            errorText: _hasKoreanJamoError(themeController.text) ? '완성된 한글을 입력해주세요' : null,
          ),
          onChanged: viewModel.updateTheme,
          // 한글 입력 처리 개선
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,

          // IME 전환 옵션 추가
          enableIMEPersonalizedLearning: true,
        ),
        const SizedBox(height: 12),
        if (state.popularThemes.isNotEmpty)
          ChipSelection(
            title: '인기 테마',
            items: state.popularThemes,
            selectedItem: state.theme,
            onSelected: (theme) {
              themeController.text = theme;
              viewModel.selectPopularTheme(theme);
            },
          ),
      ],
    );
  }

  Widget _buildBudgetSection(BuildContext context, AICourseState state, AICourseViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '예산은 얼마로 계획하고 계신가요?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        BudgetSlider(
          value: state.budget.toDouble(),
          onChanged: (value) => viewModel.updateBudget(value.toInt()),
        ),
      ],
    );
  }

  Widget _buildMoodSection(BuildContext context, AICourseState state, AICourseViewModel viewModel) {
    final moods = ['로맨틱한', '편안한', '활동적인', '럭셔리한', '아늑한', '특별한'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 분위기를 원하시나요?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ChipSelection(
          title: '',
          items: moods,
          selectedItem: state.mood ?? '로맨틱한', // 기본값 설정
          onSelected: (mood) {
            viewModel.updateMood(mood);
          },
        ),
      ],
    );
  }

  Widget _buildDurationSection(BuildContext context, AICourseState state, AICourseViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '데이트 시간은 얼마나 계획하고 계신가요?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        DurationSelector(
          value: state.duration,
          onChanged: (value) => viewModel.updateDuration(value),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection(BuildContext context, AICourseState state, AICourseViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '추가 요청사항 (선택사항)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: additionalInfoController,
          decoration: InputDecoration(
            hintText: '특별한 요청이 있으신가요? (예: 반려동물 동반 가능한 장소)',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
          ),
          maxLines: 3,
          onChanged: viewModel.updateAdditionalInfo,
          // 한글 입력 처리 개선
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          // IME 전환 옵션 추가
          enableIMEPersonalizedLearning: true,
        ),
      ],
    );
  }

  Widget _buildGenerateButton(BuildContext context, AICourseState state, AICourseViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !state.isFormValid || state.status == CourseCreationStatus.generating
            ? null
            : () async {
          await viewModel.generateCourse();
          if (state.status == CourseCreationStatus.failure) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? '오류가 발생했습니다.')),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'AI 코스 생성하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 한글 자/모음 검사 함수
  bool _hasKoreanJamoError(String text) {
    // 한글 자모음(낱자) 범위: ㄱ-ㅎ, ㅏ-ㅣ (유니코드 범위: 0x3131-0x318E)
    final RegExp jamoPattern = RegExp(r'[\u3131-\u318E]');
    return jamoPattern.hasMatch(text);
  }
}