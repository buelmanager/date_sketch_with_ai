import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  // 싱글톤 패턴
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  // API 키 가져오기
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  // 모델 인스턴스
  late final GenerativeModel _model;
  late final GenerativeModel _visionModel;

  // 초기화 메서드
  Future<void> initialize() async {
    try {
      // 올바른 모델명 사용
      _model = GenerativeModel(
        model: 'gemini-1.5-pro', // 수정된 모델명
        apiKey: apiKey,
      );

      _visionModel = GenerativeModel(
        model: 'gemini-1.5-pro-vision', // 수정된 모델명
        apiKey: apiKey,
      );

      debugPrint('Gemini 서비스가 초기화되었습니다.');
    } catch (e) {
      debugPrint('Gemini 서비스 초기화 오류: $e');
      rethrow;
    }
  }

  // 텍스트 기반 콘텐츠 생성
  Future<String> generateContent(String prompt) async {
    try {
      final response = await _model.generateContent(
        [Content.text(prompt)],
      );

      return response.text ?? '응답을 생성할 수 없습니다.';
    } catch (e) {
      debugPrint('콘텐츠 생성 오류: $e');
      return '오류 발생: $e';
    }
  }

  // 대화 시작
  ChatSession startChat() {
    return _model.startChat();
  }

  // 이미지와 함께 콘텐츠 생성 (Vision API)
  Future<String> generateContentWithImage(String prompt, Uint8List imageBytes) async {
    try {
      final response = await _visionModel.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ]);

      return response.text ?? '이미지 분석 결과를 생성할 수 없습니다.';
    } catch (e) {
      debugPrint('이미지 콘텐츠 생성 오류: $e');
      return '오류 발생: $e';
    }
  }
}