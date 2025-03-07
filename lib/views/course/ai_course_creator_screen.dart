import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/date_course.dart';
import '../../../providers/view_model_providers.dart';
import '../../../utils/theme.dart';
import '../../../view_models/ai_course_view_model.dart';
import '../common/loading_overlay.dart';
import 'widgets/budget_slider.dart';
import 'widgets/chip_selection.dart';
import 'widgets/duration_selector.dart';
import 'widgets/generated_course_preview.dart';

class AICourseCreatorScreen extends ConsumerWidget {
  const AICourseCreatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseState = ref.watch(aiCourseViewModelProvider);
    final courseViewModel = ref.read(aiCourseViewModelProvider.notifier);

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
                _buildDurationSection(context, courseState, courseViewModel),
                const SizedBox(height: 20),
                _buildAdditionalInfoSection(context, courseState, courseViewModel),
                const SizedBox(height: 30),
                _buildGenerateButton(context, courseState, courseViewModel),
                const SizedBox(height: 30),

                // 생성된 코스가 있을 경우 표시
                if (courseState.status == CourseCreationStatus.success && courseState.generatedCourse != null)
                  GeneratedCoursePreview(course: courseState.generatedCourse!),
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
        TextField(
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
          ),
          onChanged: viewModel.updateLocation,
          controller: TextEditingController(text: state.location),
        ),
        const SizedBox(height: 12),
        if (state.recentLocations.isNotEmpty)
          ChipSelection(
            title: '최근 위치',
            items: state.recentLocations,
            selectedItem: state.location,
            onSelected: viewModel.selectRecentLocation,
          ),
      ],
    );
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
          ),
          onChanged: viewModel.updateTheme,
          controller: TextEditingController(text: state.theme),
        ),
        const SizedBox(height: 12),
        if (state.popularThemes.isNotEmpty)
          ChipSelection(
            title: '인기 테마',
            items: state.popularThemes,
            selectedItem: state.theme,
            onSelected: viewModel.selectPopularTheme,
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
          selectedItem: state.mood,
          onSelected: viewModel.updateMood,
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
          onChanged: viewModel.updateDuration,
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
          controller: TextEditingController(text: state.additionalInfo ?? ''),
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
}