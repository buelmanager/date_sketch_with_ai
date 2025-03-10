import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/ai_course_request.dart';
import '../models/date_course.dart';
import '../utils/app_logger.dart';

/// Firebase Firestore에 코스 데이터를 저장하고 불러오는 서비스 클래스
class FirebaseCourseService {
  final FirebaseFirestore _firestore;

  FirebaseCourseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // 컬렉션 참조
  CollectionReference get _coursesCollection => _firestore.collection('date_courses');
  CollectionReference get _requestsCollection => _firestore.collection('course_requests');
  CollectionReference get _usersCollection => _firestore.collection('users');

  /// AI 코스 요청 데이터를 Firestore에 저장
  Future<String> saveAICourseRequest(AICourseRequest request, {String? userId}) async {
    try {
      // Freezed 모델을 toJson으로 변환
      final requestData = request.toJson();

      // 추가 메타데이터 포함
      requestData.addAll({
        'userId': userId ?? 'anonymous',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final docRef = await _requestsCollection.add(requestData);
      AppLogger.i('AI 코스 요청 저장 성공: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      AppLogger.e('AI 코스 요청 저장 실패', e);
      throw Exception('AI 코스 요청을 저장하는 중 오류가 발생했습니다: $e');
    }
  }

  /// 생성된 AI 코스를 Firestore에 저장
  Future<String> saveGeneratedCourse(DateCourse course, String requestId, {String? userId}) async {
    try {
      // DateCourse 모델을 Map으로 변환
      final courseData = course.toJson();

      // 추가 메타데이터 포함
      courseData.addAll({
        'requestId': requestId,
        'userId': userId ?? 'anonymous',
        'createdAt': FieldValue.serverTimestamp(),
        'isAIGenerated': true,
      });

      final docRef = await _coursesCollection.add(courseData);
      AppLogger.i('생성된 코스 저장 성공: ${docRef.id}');

      // 사용자가 로그인한 경우 사용자의 코스 목록에 추가
      if (userId != null && userId != 'anonymous') {
        await _usersCollection.doc(userId).collection('courses').doc(docRef.id).set({
          'courseId': docRef.id,
          'createdAt': FieldValue.serverTimestamp(),
          'isAIGenerated': true,
        });
      }

      return docRef.id;
    } catch (e) {
      AppLogger.e('생성된 코스 저장 실패', e);
      throw Exception('생성된 코스를 저장하는 중 오류가 발생했습니다: $e');
    }
  }

  /// AI 코스 요청 및 생성 결과를 한번에 저장
  Future<Map<String, String>> saveAICourseWithRequest(
      AICourseRequest request,
      DateCourse course,
      {String? userId}
      ) async {
    try {
      // 트랜잭션을 사용하여 요청과 코스를 함께 저장
      String requestId = '';
      String courseId = '';

      await _firestore.runTransaction((transaction) async {
        // 1. 요청 데이터 저장
        final requestData = request.toJson();
        requestData.addAll({
          'userId': userId ?? 'anonymous',
          'createdAt': FieldValue.serverTimestamp(),
        });

        final requestDocRef = _requestsCollection.doc();
        transaction.set(requestDocRef, requestData);
        requestId = requestDocRef.id;

        // 2. 코스 데이터 저장
        final courseData = course.toJson();
        courseData.addAll({
          'requestId': requestId,
          'userId': userId ?? 'anonymous',
          'createdAt': FieldValue.serverTimestamp(),
          'isAIGenerated': true,
        });

        final courseDocRef = _coursesCollection.doc();
        transaction.set(courseDocRef, courseData);
        courseId = courseDocRef.id;

        // 3. 사용자가 로그인한 경우 사용자의 코스 목록에 추가
        if (userId != null && userId != 'anonymous') {
          transaction.set(
              _usersCollection.doc(userId).collection('courses').doc(courseId),
              {
                'courseId': courseId,
                'createdAt': FieldValue.serverTimestamp(),
                'isAIGenerated': true,
              }
          );
        }
      });

      AppLogger.i('AI 코스 및 요청 저장 성공 - 요청: $requestId, 코스: $courseId');
      return {
        'requestId': requestId,
        'courseId': courseId,
      };
    } catch (e) {
      AppLogger.e('AI 코스 및 요청 저장 실패', e);
      throw Exception('AI 코스 및 요청을 저장하는 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자의 저장된 AI 코스 목록 가져오기
  Future<List<DateCourse>> getUserAICourses(String userId) async {
    try {
      final userCoursesSnapshot = await _usersCollection
          .doc(userId)
          .collection('courses')
          .where('isAIGenerated', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      final List<DateCourse> courses = [];

      for (var doc in userCoursesSnapshot.docs) {
        final courseId = doc.data()['courseId'] as String;
        final courseDoc = await _coursesCollection.doc(courseId).get();

        if (courseDoc.exists) {
          final courseData = courseDoc.data() as Map<String, dynamic>;
          courses.add(DateCourse.fromJson(courseData));
        }
      }

      return courses;
    } catch (e) {
      AppLogger.e('사용자의 AI 코스 목록 가져오기 실패', e);
      throw Exception('사용자의 AI 코스 목록을 가져오는 중 오류가 발생했습니다: $e');
    }
  }

  /// 코스 삭제하기
  Future<void> deleteCourse(String courseId, {String? userId}) async {
    try {
      await _coursesCollection.doc(courseId).delete();

      // 사용자가 로그인한 경우 사용자의 코스 목록에서도 삭제
      if (userId != null) {
        await _usersCollection
            .doc(userId)
            .collection('courses')
            .doc(courseId)
            .delete();
      }

      AppLogger.i('코스 삭제 성공: $courseId');
    } catch (e) {
      AppLogger.e('코스 삭제 실패', e);
      throw Exception('코스를 삭제하는 중 오류가 발생했습니다: $e');
    }
  }
}