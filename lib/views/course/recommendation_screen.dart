import 'package:flutter/material.dart';
import '../../services/ai/recommendation_service.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final RecommendationService _recommendationService = RecommendationService();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dateTypeController = TextEditingController();

  String _recommendations = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _locationController.dispose();
    _preferencesController.dispose();
    _budgetController.dispose();
    _dateTypeController.dispose();
    super.dispose();
  }

  Future<void> _getRecommendations() async {
    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치를 입력해주세요'))
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _recommendations = '';
    });

    try {
      final results = await _recommendationService.getDateSpotRecommendations(
        location: _locationController.text,
        preferences: _preferencesController.text,
        budget: _budgetController.text,
        dateType: _dateTypeController.text.isNotEmpty ? _dateTypeController.text : null,
      );

      setState(() {
        _recommendations = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _recommendations = '오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('데이트 장소 추천'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: '위치',
                hintText: '예: 서울 강남, 부산 해운대',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _preferencesController,
              decoration: const InputDecoration(
                labelText: '선호도',
                hintText: '예: 조용한 카페, 야외 활동, 미술관',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: '예산',
                hintText: '예: 5만원 이하, 10만원 대',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dateTypeController,
              decoration: const InputDecoration(
                labelText: '데이트 유형 (선택사항)',
                hintText: '예: 첫 데이트, 기념일, 캐주얼한 만남',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _getRecommendations,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('추천받기'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _recommendations.isEmpty && !_isLoading
                  ? const Center(
                child: Text('위 정보를 입력하고 추천받기를 눌러주세요'),
              )
                  : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_recommendations),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}