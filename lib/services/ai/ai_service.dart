import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/ai_course_request.dart';
import '../../models/date_course.dart';
import '../../models/date_place.dart';
import '../../utils/app_logger.dart';

/// AI를 통한 데이트 코스 생성 서비스
class AIService {
  final String _apiUrl;
  final String _apiKey;

  AIService({
    required String apiUrl,
    required String apiKey,
  }) : _apiUrl = apiUrl,
        _apiKey = apiKey;

  /// AI API를 통해 데이트 코스 생성
  Future<DateCourse> generateCourse(AICourseRequest request) async {
    try {
      // API에 요청할 데이터 준비
      final requestData = {
        'location': request.location,
        'theme': request.theme,
        'budget': request.budget,
        'mood': request.mood,
        'duration': request.duration,
        'additionalInfo': request.additionalInfo,
      };

      // API 호출
      final response = await http.post(
        Uri.parse('$_apiUrl/generate-course'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(requestData),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return DateCourse.fromJson(jsonResponse['course']);
      } else {
        throw Exception('API 호출 실패: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      AppLogger.e('AI 코스 생성 API 호출 실패', e);

      // 개발 중이거나 API가 준비되지 않은 경우 더미 데이터 반환
      return _generateFallbackCourse(request);
    }
  }

  /// API 호출 실패 시 폴백용 더미 코스 생성
  DateCourse _generateFallbackCourse(AICourseRequest request) {
    // 더미 장소 데이터
    final places = <DatePlace>[];

    // 테마에 따라 장소 유형 결정
    final placeTypes = _getPlaceTypes(request.theme);

    // 코스 시간에 따라 장소 수 결정
    final placeCount = (request.duration * 1.5).round().clamp(2, 5);

    // 더미 장소 생성
    for (int i = 0; i < placeCount; i++) {
      places.add(DatePlace(
        id: 'place-$i',
        name: '${placeTypes[i % placeTypes.length]} ${i + 1}',
        category: placeTypes[i % placeTypes.length],
        imageUrl: 'https://picsum.photos/500/300?random=${i+1}',
        rating: 4.5 + (i * 0.1).clamp(0.0, 0.4),
        address: '${request.location} 어딘가 ${i + 1}',
        description: '${request.mood} 분위기의 ${placeTypes[i % placeTypes.length]}입니다.',
        tags: [request.mood, request.theme, placeTypes[i % placeTypes.length]],
        reviewCount: (i + 5) * 10,
        latitude: 37.5 + (i * 0.01),
        longitude: 127.0 + (i * 0.01),
        metadata: {
          'priceLevel': (i % 3) + 1,
        },
        isFavorite: false,
      ));
    }

    // 더미 코스 생성
    return DateCourse(
      id: 'dummy-${DateTime.now().millisecondsSinceEpoch}',
      title: '${request.mood} ${request.theme} 데이트 코스',
      description: '${request.location}에서 ${request.duration}시간 동안 즐기는 ${request.mood} 데이트 코스입니다. 총 예산은 약 ${request.budget}원으로 준비했습니다.',
      imageUrl: 'https://picsum.photos/800/500',
      rating: 4.8,
      location: request.location,
      category: request.theme,
      duration: request.duration * 60, // 시간 → 분 변환
      tags: [request.mood, request.theme, request.location],
      places: places,
      reviewCount: 0,
      estimatedTime: request.duration * 60,
      estimatedCost: request.budget,
      createdBy: 'AI',
      isFavorite: false,
      isFeatured: false, transportationInfo: '', alternativeInfo: '',
    );
  }

  /// 테마에 따른 장소 유형 가져오기
  List<String> _getPlaceTypes(String theme) {
    switch (theme.toLowerCase()) {
      case '맛집 탐방':
        return ['레스토랑', '카페', '디저트'];
      case '카페 투어':
        return ['카페', '베이커리', '디저트 카페'];
      case '한강 데이트':
        return ['공원', '카페', '레스토랑'];
      case '전시회':
        return ['미술관', '갤러리', '카페'];
      case '영화 데이트':
        return ['영화관', '카페', '레스토랑'];
      case '쇼핑':
        return ['쇼핑몰', '카페', '레스토랑'];
      default:
        return ['카페', '레스토랑', '문화공간', '공원'];
    }
  }
}