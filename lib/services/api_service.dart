import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import '../models/date_course.dart';
import '../models/date_place.dart';
import '../utils/app_logger.dart';

/// API 서비스 더미 구현 클래스
/// 실제 서버 요청 대신 가짜 응답을 생성합니다.
class APIService {
  final Dio _dio;
  final bool _useMockData;

  APIService({
    required Dio dio,
    bool useMockData = true,
  })  : _dio = dio,
        _useMockData = useMockData;

  /// GET 요청
  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    if (_useMockData) {
      return _mockResponse(path, queryParameters);
    }

    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      AppLogger.e('GET 요청 실패: $path', e);
      throw Exception('API 요청 실패: ${e.toString()}');
    }
  }

  /// POST 요청
  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    if (_useMockData) {
      // 더미 데이터 생성
      return _mockResponse(path, data);
    }

    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      AppLogger.e('POST 요청 실패: $path', e);
      throw Exception('API 요청 실패: ${e.toString()}');
    }
  }

  /// PUT 요청
  Future<Response> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    if (_useMockData) {
      return _mockResponse(path, data);
    }

    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      AppLogger.e('PUT 요청 실패: $path', e);
      throw Exception('API 요청 실패: ${e.toString()}');
    }
  }

  /// DELETE 요청
  Future<Response> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    if (_useMockData) {
      return _mockResponse(path, data);
    }

    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      AppLogger.e('DELETE 요청 실패: $path', e);
      throw Exception('API 요청 실패: ${e.toString()}');
    }
  }

  /// 더미 응답 생성
  Future<Response> _mockResponse(String path, dynamic data) async {
    // 응답 지연 시뮬레이션 (0.5초 ~ 2초)
    await Future.delayed(
        Duration(milliseconds: Random().nextInt(1500) + 500));

    if (path == '/generate-course') {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: _generateMockCourse(data),
      );
    }

    // 기본 더미 응답
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'success': true, 'message': '더미 응답입니다.'},
    );
  }

  /// 더미 코스 생성
  Map<String, dynamic> _generateMockCourse(dynamic requestData) {
    Map<String, dynamic> request = {};

    if (requestData is Map) {
      // Map<dynamic, dynamic>을 Map<String, dynamic>으로 변환
      request = Map<String, dynamic>.from(requestData as Map);
    } else if (requestData != null) {
      request = jsonDecode(jsonEncode(requestData));
    }

    final location = request['location'] ?? '강남';
    final theme = request['theme'] ?? '맛집 투어';
    final mood = request['mood'] ?? '로맨틱한';

    // 더미 장소 생성
    final places = <Map<String, dynamic>>[];

    // 음식점
    places.add({
      'id': 'place_${Random().nextInt(1000)}',
      'name': '${location}의 ${_getRandomItem(_restaurantNames)}',
      'description': '${mood} 분위기의 맛집으로, 특별한 요리와 함께 로맨틱한 시간을 보낼 수 있는 곳입니다.',
      'address': '${location} ${Random().nextInt(30) + 1}길 ${Random().nextInt(50) + 1}',
      'imageUrl': 'https://via.placeholder.com/500x300?text=Restaurant',
      'type': '음식점',
      'order': 1,
      'estimatedTime': 90,
      'estimatedCost': Random().nextInt(30000) + 20000,
    });

    // 카페
    places.add({
      'id': 'place_${Random().nextInt(1000)}',
      'name': '${_getRandomItem(_cafeNames)}',
      'description': '분위기 좋은 카페에서 디저트와 음료를 즐기며 대화를 나눠보세요.',
      'address': '${location} ${Random().nextInt(30) + 1}길 ${Random().nextInt(50) + 1}',
      'imageUrl': 'https://via.placeholder.com/500x300?text=Cafe',
      'type': '카페',
      'order': 2,
      'estimatedTime': 60,
      'estimatedCost': Random().nextInt(10000) + 10000,
    });

    // 액티비티
    places.add({
      'id': 'place_${Random().nextInt(1000)}',
      'name': '${_getRandomItem(_activityNames)}',
      'description': '특별한 체험을 통해 잊지 못할 추억을 만들어보세요.',
      'address': '${location} ${Random().nextInt(30) + 1}길 ${Random().nextInt(50) + 1}',
      'imageUrl': 'https://via.placeholder.com/500x300?text=Activity',
      'type': '액티비티',
      'order': 3,
      'estimatedTime': 120,
      'estimatedCost': Random().nextInt(20000) + 15000,
    });

    // 더미 코스 데이터 반환
    return {
      'id': 'course_${DateTime.now().millisecondsSinceEpoch}',
      'title': '${location}에서 ${mood} ${theme}',
      'description': '${location}에서 즐기는 ${mood} 데이트 코스입니다. ${theme}을(를) 테마로 특별한 시간을 보내보세요.',
      'imageUrl': 'https://via.placeholder.com/800x400?text=DateCourse',
      'rating': 4.5 + (Random().nextDouble() * 0.5),
      'location': location,
      'category': theme,
      'duration': 180 + Random().nextInt(120),
      'tags': [theme, mood, '데이트코스', location],
      'places': places,
      'reviewCount': Random().nextInt(100) + 50,
      'estimatedTime': 270,
      'estimatedCost': places.fold(0, (sum, place) => sum + (place['estimatedCost'] as int)),
      'isFavorite': false,
      'isFeatured': Random().nextBool(),
    };
  }

  // 더미 데이터용 랜덤 이름 목록
  final List<String> _restaurantNames = [
    '아리따움', '블루포트', '라메종', '세레니티', '더테이블',
    '오차드가든', '솔티드', '라벤더', '블루밍', '라피네'
  ];

  final List<String> _cafeNames = [
    '카페오네', '브루웍스', '커피밀', '어반로스터스', '인사이드커피',
    '카페노트', '트렌디커피', '브라운웨이브', '리버벤드카페', '스위트블룸'
  ];

  final List<String> _activityNames = [
    '원더랜드', '플레이타임', '익스피리언스 존', '어드벤처랩', '펀팩토리',
    '아트스튜디오', '더플레이하우스', '핸드메이드클래스', '뮤직스페이스', '크리에이티브존'
  ];

  String _getRandomItem(List<String> items) {
    return items[Random().nextInt(items.length)];
  }
}