import 'package:date_sketch_with_ai/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

import 'gemini_service.dart';

class AICourseService {
  final GeminiService _geminiService = GeminiService();

  // AI 데이트 코스 생성 요청
  Future<String> generateDateCourse({
    required String location,
    required String preferences,
    required String budget,
    required String duration,
    String? dateType,
    String? mood,
    String? transportMethod,
    String? specialRequirements,
  }) async {
    try {
      final prompt = '''
      당신은 데이트 코스 전문가입니다. 다음 조건에 맞는 최적의 데이트 코스를 설계해주세요:
      
      위치: $location
      테마/선호도: $preferences
      예산: $budget
      소요 시간: $duration
      ${mood != null ? '원하는 분위기: $mood' : ''}
      ${specialRequirements != null && specialRequirements.isNotEmpty ? '특별 요청사항: $specialRequirements' : ''}
      
      아래 형식과 정확히 일치하게 마크다운으로 응답해주세요. 장소는 3개 정도 추천해주세요.
      
      ## 데이트 코스 요약
      (전체 코스의 간략한 설명, 2-3문장)
      
      ## 상세 일정
      
      ### 1. [시간] - [장소명] 
      - 주소: [정확한 주소]
      - 활동 설명: [이 장소에서 무엇을 할지 설명]
      - 예상 비용: [비용 범위]
      - 추천 이유: [왜 이 장소가 데이트에 적합한지]
      
      ### 2. [시간] - [장소명]
      - 주소: [정확한 주소]
      - 활동 설명: [이 장소에서 무엇을 할지 설명]
      - 예상 비용: [비용 범위]
      - 추천 이유: [왜 이 장소가 데이트에 적합한지]
      
      ### 3. [시간] - [장소명]
      - 주소: [정확한 주소]
      - 활동 설명: [이 장소에서 무엇을 할지 설명]
      - 예상 비용: [비용 범위]
      - 추천 이유: [왜 이 장소가 데이트에 적합한지]
      
      ## 이동 계획
      (장소 간 이동 방법 및 소요 시간)
      
      ## 대안 계획
      (날씨나 상황에 따른 대안 제안)
      
      응답은 정확히 위 형식을 따라야 합니다. 제시된 항목 외에 다른 정보나 설명을 추가하지 마세요.
      ''';

      AppLogger.d("AI 코스 생성 프롬프트: $prompt");
      String result = await _geminiService.generateContent(prompt);
      AppLogger.d("AI 코스 생성 결과: $result");
      return result;
    } catch (e) {
      debugPrint('AI 코스 생성 오류: $e');
      return '코스를 생성하는 중 오류가 발생했습니다: $e';
    }
  }

  // 코스 결과 파싱 메서드
  Map<String, dynamic> parseDateCourseResult(String aiResponse) {
    try {
      AppLogger.d("AI 응답 파싱 시작");

      // 기본 구조 생성
      Map<String, dynamic> courseData = {
        'summary': '',
        'places': <Map<String, String>>[],
        'transportPlan': '',
        'alternativePlan': '',
      };

      // 요약 추출
      final summaryRegex = RegExp(r'## 데이트 코스 요약\s+(.*?)(?=##|\Z)', dotAll: true);
      final summaryMatch = summaryRegex.firstMatch(aiResponse);
      if (summaryMatch != null) {
        courseData['summary'] = summaryMatch.group(1)?.trim() ?? '';
      } else {
        AppLogger.w("요약 정보를 찾을 수 없습니다.");
      }

      // 장소 정보 추출 (다양한 포맷 지원)
      // 패턴 1: [시간] - [장소명] 형식
      final pattern1 = RegExp(r'### \d+\.\s+\[([^\]]+)\]\s*-\s*\[([^\]]+)\][\s\n]+-\s*주소:\s*([^\n]+)[\s\n]+-\s*활동 설명:\s*([^\n]+)[\s\n]+-\s*예상 비용:\s*([^\n]+)[\s\n]+-\s*추천 이유:\s*([^\n]+)', dotAll: true);

      // 패턴 2: 숫자. 장소명 형식
      final pattern2 = RegExp(r'###\s*\d+\.\s*([^\n\[]+)[\s\n]+-\s*주소:\s*([^\n]+)[\s\n]+-\s*활동 설명:\s*([^\n]+)[\s\n]+-\s*예상 비용:\s*([^\n]+)[\s\n]+-\s*추천 이유:\s*([^\n]+)', dotAll: true);

      // 패턴 3: [시간] - [장소명] 형식 (선형 구조)
      final pattern3 = RegExp(r'###\s*\d+\.\s*\[([^\]]+)\]\s*-\s*([^\n]+)[\s\n]+-\s*주소:\s*([^\n]+)[\s\n]+-\s*활동 설명:\s*([^\n]+)[\s\n]+-\s*예상 비용:\s*([^\n]+)[\s\n]+-\s*추천 이유:\s*([^\n]+)', dotAll: true);

      // 패턴 4: 가장 유연한 패턴
      final pattern4 = RegExp(r'###.*?\d+\..*?([^\n]+)[\s\n]+-\s*주소:([^\n]+)[\s\n]+-\s*활동.*?:([^\n]+)[\s\n]+-\s*예상.*?:([^\n]+)[\s\n]+-\s*추천.*?:([^\n]+)', dotAll: true);

      // 모든 패턴 시도
      var places = <Map<String, String>>[];

      // 패턴 1 시도
      final matches1 = pattern1.allMatches(aiResponse);
      if (matches1.isNotEmpty) {
        AppLogger.d("패턴 1로 장소 정보 파싱 성공");
        for (var match in matches1) {
          places.add({
            'time': match.group(1)?.trim() ?? '정보 없음',
            'name': match.group(2)?.trim() ?? '정보 없음',
            'address': match.group(3)?.trim() ?? '정보 없음',
            'activity': match.group(4)?.trim() ?? '정보 없음',
            'cost': match.group(5)?.trim() ?? '정보 없음',
            'reason': match.group(6)?.trim() ?? '정보 없음',
          });
        }
      }

      // 패턴 2 시도
      if (places.isEmpty) {
        final matches2 = pattern2.allMatches(aiResponse);
        if (matches2.isNotEmpty) {
          AppLogger.d("패턴 2로 장소 정보 파싱 성공");
          for (var match in matches2) {
            places.add({
              'time': '정보 없음',
              'name': match.group(1)?.trim() ?? '정보 없음',
              'address': match.group(2)?.trim() ?? '정보 없음',
              'activity': match.group(3)?.trim() ?? '정보 없음',
              'cost': match.group(4)?.trim() ?? '정보 없음',
              'reason': match.group(5)?.trim() ?? '정보 없음',
            });
          }
        }
      }

      // 패턴 3 시도
      if (places.isEmpty) {
        final matches3 = pattern3.allMatches(aiResponse);
        if (matches3.isNotEmpty) {
          AppLogger.d("패턴 3으로 장소 정보 파싱 성공");
          for (var match in matches3) {
            places.add({
              'time': match.group(1)?.trim() ?? '정보 없음',
              'name': match.group(2)?.trim() ?? '정보 없음',
              'address': match.group(3)?.trim() ?? '정보 없음',
              'activity': match.group(4)?.trim() ?? '정보 없음',
              'cost': match.group(5)?.trim() ?? '정보 없음',
              'reason': match.group(6)?.trim() ?? '정보 없음',
            });
          }
        }
      }

      // 패턴 4 시도 (가장 유연한 패턴)
      if (places.isEmpty) {
        final matches4 = pattern4.allMatches(aiResponse);
        if (matches4.isNotEmpty) {
          AppLogger.d("패턴 4(유연한 패턴)으로 장소 정보 파싱 성공");
          for (var match in matches4) {
            final nameText = match.group(1)?.trim() ?? '정보 없음';
            // 시간과 장소명을 분리하려고 시도
            String time = '정보 없음';
            String name = nameText;

            // 시간-장소명 패턴을 찾아봄
            final timeNamePattern = RegExp(r'\[([^\]]+)\]\s*-\s*(.+)');
            final timeNameMatch = timeNamePattern.firstMatch(nameText);
            if (timeNameMatch != null) {
              time = timeNameMatch.group(1)?.trim() ?? '정보 없음';
              name = timeNameMatch.group(2)?.trim() ?? '정보 없음';
            }

            places.add({
              'time': time,
              'name': name,
              'address': match.group(2)?.trim() ?? '정보 없음',
              'activity': match.group(3)?.trim() ?? '정보 없음',
              'cost': match.group(4)?.trim() ?? '정보 없음',
              'reason': match.group(5)?.trim() ?? '정보 없음',
            });
          }
        }
      }

      // 최후의 방법: 섹션으로 나눠서 처리
      if (places.isEmpty) {
        AppLogger.w("모든 정규식으로 장소 파싱 실패. 섹션 기반 파싱 시도");

        // 상세 일정 섹션 추출
        final scheduleRegex = RegExp(r'## 상세 일정\s+(.*?)(?=##|\Z)', dotAll: true);
        final scheduleMatch = scheduleRegex.firstMatch(aiResponse);

        if (scheduleMatch != null) {
          final scheduleContent = scheduleMatch.group(1) ?? '';

          // 각 항목 번호로 분리
          final placeBlocks = scheduleContent.split(RegExp(r'###\s*\d+\.'));

          for (var i = 1; i < placeBlocks.length; i++) {  // 첫 번째는 빈 문자열일 수 있으므로 건너뜀
            final block = placeBlocks[i].trim();

            // 각 항목에서 필요한 정보 추출
            String name = '정보 없음';
            String time = '정보 없음';
            String address = '정보 없음';
            String activity = '정보 없음';
            String cost = '정보 없음';
            String reason = '정보 없음';

            // 이름 추출 시도
            final nameMatch = RegExp(r'^([^\n-]+)').firstMatch(block);
            if (nameMatch != null) {
              name = nameMatch.group(1)?.trim() ?? '정보 없음';
            }

            // 주소 추출 시도
            final addressMatch = RegExp(r'주소:([^\n]+)').firstMatch(block);
            if (addressMatch != null) {
              address = addressMatch.group(1)?.trim() ?? '정보 없음';
            }

            // 활동 설명 추출 시도
            final activityMatch = RegExp(r'활동.*?:([^\n]+)').firstMatch(block);
            if (activityMatch != null) {
              activity = activityMatch.group(1)?.trim() ?? '정보 없음';
            }

            // 비용 추출 시도
            final costMatch = RegExp(r'예상.*?:([^\n]+)').firstMatch(block);
            if (costMatch != null) {
              cost = costMatch.group(1)?.trim() ?? '정보 없음';
            }

            // 추천 이유 추출 시도
            final reasonMatch = RegExp(r'추천.*?:([^\n]+)').firstMatch(block);
            if (reasonMatch != null) {
              reason = reasonMatch.group(1)?.trim() ?? '정보 없음';
            }

            places.add({
              'time': time,
              'name': name,
              'address': address,
              'activity': activity,
              'cost': cost,
              'reason': reason,
            });
          }
        }
      }

      // 파싱된 장소 정보를 저장
      courseData['places'] = places;

      AppLogger.d("파싱 결과: ${places.length}개 장소 발견");

      // 파싱된 장소가 없으면 최후의 수단으로 단순히 번호와 이름만 추출
      if (places.isEmpty) {
        AppLogger.e("모든 파싱 방법 실패. 최소한의 정보만 추출");

        final simpleRegex = RegExp(r'(\d+)\.\s+([^\n]+)');
        final simpleMatches = simpleRegex.allMatches(aiResponse);

        for (var match in simpleMatches) {
          final placeName = match.group(2)?.trim() ?? '';
          if (placeName.isNotEmpty) {
            courseData['places'].add({
              'time': '정보 없음',
              'name': placeName,
              'address': '정보 없음',
              'activity': '정보 없음',
              'cost': '정보 없음',
              'reason': '정보 없음',
            });
          }
        }
      }

      // 이동 계획 추출
      final transportRegex = RegExp(r'## 이동 계획\s+(.*?)(?=##|\Z)', dotAll: true);
      final transportMatch = transportRegex.firstMatch(aiResponse);
      if (transportMatch != null) {
        courseData['transportPlan'] = transportMatch.group(1)?.trim() ?? '';
      } else {
        AppLogger.w("이동 계획 정보를 찾을 수 없습니다.");
        courseData['transportPlan'] = '상세 이동 계획 정보가 제공되지 않았습니다.';
      }

      // 대안 계획 추출 (수정된 코드)
      final alternativeRegex = RegExp(r'## 대안 계획\s+([\s\S]*?)(?=##|$)', dotAll: true);
      final alternativeMatch = alternativeRegex.firstMatch(aiResponse);

      AppLogger.w("alternativeMatch $alternativeMatch");

      if (alternativeMatch != null) {
        courseData['alternativePlan'] = alternativeMatch.group(1)?.trim() ?? '';
      } else {
        AppLogger.w("대안 계획 정보를 찾을 수 없습니다.");
        courseData['alternativePlan'] = '날씨나 상황에 따른 대안 계획 정보가 제공되지 않았습니다.';
      }
      // 파싱된 데이터 반환
      return courseData;

    } catch (e) {
      debugPrint('결과 파싱 오류: $e');
      // 오류 시 기본값 반환
      return {
        'error': '코스 데이터 파싱 중 오류가 발생했습니다: $e',
        'rawResponse': aiResponse,
        'summary': '코스 요약 정보를 파싱할 수 없습니다.',
        'places': <Map<String, String>>[],
        'transportPlan': '이동 계획 정보를 파싱할 수 없습니다.',
        'alternativePlan': '대안 계획 정보를 파싱할 수 없습니다.'
      };
    }
  }
}