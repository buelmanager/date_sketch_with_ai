import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';
import '../models/ai_course_request.dart';
import '../models/date_course.dart';
import '../models/date_place.dart';
import '../utils/app_logger.dart';

class AICourseRepository {
  final APIService? _apiService;
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;

  AICourseRepository({
    APIService? apiService,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _apiService = apiService,
        _firestore = firestore,
        _auth = auth;

  // 최근 위치 가져오기
  Future<List<String>> getRecentLocations() async {
    try {
      // Firestore가 있으면 사용자의 최근 위치를 가져옴
      if (_firestore != null && _auth != null && _auth!.currentUser != null) {

        final userId = _auth!.currentUser!.uid;

        AppLogger.d("userId : $userId");

        final snapshot = await _firestore!
            .collection('user_selections')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .limit(5)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final locations = snapshot.docs
              .map((doc) => doc.data()['location'] as String)
              .toSet() // 중복 제거
              .toList();
          return locations;
        }
      }

      // Firestore 없거나 데이터가 없으면 더미 데이터 반환
      await Future.delayed(const Duration(milliseconds: 300));
      return ['강남', '홍대', '이태원', '명동', '여의도', '잠실'];
    } catch (e) {
      AppLogger.e('최근 위치 조회 실패', e);
      return ['강남', '홍대', '이태원', '명동', '여의도', '잠실'];
    }
  }

  // 인기 테마 가져오기
  Future<List<String>> getPopularThemes() async {
    // 실제로는 인기 테마 API나 DB에서 가져와야 함
    await Future.delayed(const Duration(milliseconds: 300));
    return ['맛집 투어', '카페 데이트', '문화생활', '자연 속 데이트', '액티비티', '쇼핑'];
  }

  // AI 코스 생성 요청
  Future<DateCourse> generateAICourse(AICourseRequest request) async {
    try {
      // API 서비스가 있으면 실제 API 호출
      if (_apiService != null) {
        try {
          final response = await _apiService!.post(
            '/generate-course',
            data: request.toJson(),
          );
          return DateCourse.fromJson(response.data);
        } catch (e) {
          AppLogger.e('API 서비스를 통한 코스 생성 실패', e);
          // API 호출 실패 시 더미 데이터로 대체
        }
      }

      // API 서비스가 없거나 실패 시 더미 데이터 생성
      AppLogger.d('AI 코스 생성 요청: ${request.toJson()}');

      // API 호출 시뮬레이션 (2-4초 딜레이)
      await Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(2000)));

      // 더미 데이터 반환
      final places = [
        DatePlace(
          id: 'place_${Random().nextInt(1000)}',
          name: '${request.mood} ${request.theme} 장소',
          category: _getCategoryFromTheme(request.theme),
          address: '${request.location} 어딘가',
          rating: 4.5,
          reviewCount: 100 + Random().nextInt(900),
          imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
          description: '${request.mood} 분위기의 멋진 장소입니다. ${request.theme}을(를) 즐기기에 완벽한 곳이에요.', tags: [], latitude: 1, longitude: 1,
        ),
        DatePlace(
          id: 'place_${Random().nextInt(1000)}',
          name: '아늑한 ${_getCategoryFromTheme(request.theme)}',
          category: _getCategoryFromTheme(request.theme),
          address: '${request.location} 중심지',
          rating: 4.5 + (Random().nextDouble() / 2),
          reviewCount: 100 + Random().nextInt(900),
          imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
          description: '${request.location}의 중심부에 위치한 아늑한 장소입니다. ${request.budget ~/ 2}원 정도의 비용으로 즐길 수 있어요.', tags: [], latitude: 1, longitude: 1,
        ),
        DatePlace(
          id: 'place_${Random().nextInt(1000)}',
          name: '${request.mood} 특별 장소',
          category: _getRandomCategory(),
          address: '${request.location} 북쪽',
          rating: 4.5 ,
          reviewCount: 100 + Random().nextInt(900),
          imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
          description: '${request.duration}시간 코스의 마지막을 장식할 완벽한 장소입니다. ${request.additionalInfo ?? '특별한 경험을 선사합니다.'}', tags: [], latitude: 1, longitude: 1,
        ),
      ];

      return DateCourse(
        id: 'course_${Random().nextInt(1000)}',
        title: '${request.location}의 ${request.mood} ${request.theme} 데이트',
        description: '${request.budget}원으로 즐기는 ${request.duration}시간 코스의 ${request.mood} 데이트입니다. ${request.additionalInfo ?? ''}',
        rating: 4.5,
        reviewCount: 10 + Random().nextInt(90),
        imageUrl: 'https://picsum.photos/500/300?random=${Random().nextInt(100)}',
        category: request.theme,
        estimatedTime: request.duration,
        estimatedCost: request.budget,
        isFavorite: false,
        places: places, location: request.location, duration: request.duration, tags: [request.theme, request.mood], transportationInfo: '', alternativeInfo: '',
      );
    } catch (e) {
      AppLogger.e('AI 코스 생성 중 오류 발생', e);
      rethrow;
    }
  }

  // 사용자 선택 정보 저장
  Future<void> saveUserSelections(AICourseRequest request) async {
    try {
      // Firestore와 Auth가 없으면 작업 스킵
      if (_firestore == null || _auth == null || _auth!.currentUser == null) {
        AppLogger.w('Firestore 또는 Auth가 초기화되지 않았거나 로그인되지 않음');
        return;
      }

      final userId = _auth!.currentUser!.uid;
      final timestamp = DateTime.now();
      final selectionData = {
        'userId': userId,
        'location': request.location,
        'theme': request.theme,
        'budget': request.budget,
        'mood': request.mood,
        'duration': request.duration,
        'additionalInfo': request.additionalInfo,
        'timestamp': timestamp,
      };

      await _firestore!
          .collection('user_selections')
          .doc('${userId}_${timestamp.millisecondsSinceEpoch}')
          .set(selectionData);

      AppLogger.d('사용자 선택 정보 저장 완료');
    } catch (e) {
      AppLogger.e('사용자 선택 정보 저장 실패', e);
      // 저장 실패해도 코스 생성은 계속 진행
    }
  }

  Future<void> saveGeneratedCourse(DateCourse course) async {
    try {
      final userId = _auth!.currentUser?.uid;
      if (userId == null) {
        AppLogger.w('비로그인 상태에서 코스 정보 저장 시도');
        return;
      }

      final timestamp = DateTime.now();

      // 객체를 JSON으로 변환 후 다시 Map으로 파싱 (중첩 객체 처리)
      final jsonString = jsonEncode(course.toJson());
      final courseData = jsonDecode(jsonString) as Map<String, dynamic>;

      courseData['userId'] = userId;
      courseData['generatedAt'] = timestamp;

      await _firestore!
          .collection('generated_courses')
          .doc(course.id)
          .set(courseData);

      AppLogger.d('생성된 코스 정보 저장 완료');
    } catch (e) {
      AppLogger.e('생성된 코스 정보 저장 실패', e);
      // 저장 실패해도 UI 표시는 계속 진행
    }
  }

  // 테마에 따른 카테고리 반환
  String _getCategoryFromTheme(String theme) {
    switch (theme.toLowerCase()) {
      case '맛집 투어':
        return '맛집';
      case '카페 데이트':
        return '카페';
      case '문화생활':
        return '문화시설';
      case '자연 속 데이트':
        return '자연/공원';
      case '액티비티':
        return '액티비티';
      case '쇼핑':
        return '쇼핑';
      default:
        return '기타';
    }
  }

  // 랜덤 카테고리 반환
  String _getRandomCategory() {
    final categories = ['맛집', '카페', '문화시설', '자연/공원', '액티비티', '쇼핑'];
    return categories[Random().nextInt(categories.length)];
  }
}