import 'package:date_sketch_with_ai/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

import 'gemini_service.dart';

class RecommendationService {
  final GeminiService _geminiService = GeminiService();

  // 데이트 장소 추천 요청
  Future<String> getDateSpotRecommendations({
    required String location,
    required String preferences,
    required String budget,
    String? dateType,
    String? mood,
  }) async {
    try {
      final prompt = '''
      다음 조건에 맞는 데이트 장소 3곳을 추천해주세요:
      
      위치: $location
      선호도: $preferences
      예산: $budget
      ${dateType != null ? '데이트 유형: $dateType' : ''}
      ${mood != null ? '분위기: $mood' : ''}
      
      각 장소마다 다음 정보를 포함해주세요:
      1. 장소 이름
      2. 주소
      3. 이 장소가 좋은 이유
      4. 예상 비용
      5. 추천 방문 시간
      6. 근처 다른 볼거리
      
      결과는 각 장소마다 명확하게 구분되도록 해주세요.
      ''';

      AppLogger.d("prompt $prompt");
      String result = await _geminiService.generateContent(prompt);
      AppLogger.d("result $result");
      return result;
    } catch (e) {
      debugPrint('추천 서비스 오류: $e');
      return '추천을 가져오는 중 오류가 발생했습니다.';
    }
  }

  // 특정 장소에 대한 추가 정보 요청
  Future<String> getMoreInfoAboutPlace(String placeName, String location) async {
    try {
      final prompt = '''
      $location에 있는 $placeName에 대해 자세한 정보를 알려주세요.
      
      다음 내용을 포함해주세요:
      1. 인기 메뉴나 특별한 액티비티
      2. 방문객 리뷰 요약
      3. 예약이 필요한지 여부
      4. 특별한 이벤트나 프로모션
      5. 데이트에 적합한 시간대
      6. 내부 분위기 설명
      ''';

      return await _geminiService.generateContent(prompt);
    } catch (e) {
      debugPrint('장소 정보 오류: $e');
      return '장소 정보를 가져오는 중 오류가 발생했습니다.';
    }
  }
}