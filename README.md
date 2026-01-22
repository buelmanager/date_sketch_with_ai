# Date Sketch AI

> 🎨 AI가 그려주는 완벽한 데이트 플래너 Flutter 앱

<p align="center">
  <img src="assets/icons/app_icon.png" alt="Date Sketch AI Logo" width="120"/>
</p>

## 프로젝트 소개

**Date Sketch AI**는 **Google Gemini AI**를 활용하여 사용자 맞춤형 데이트 코스를 자동으로 생성하는 크로스 플랫폼 앱입니다. 위치, 예산, 선호도를 입력하면 AI가 최적의 데이트 일정을 설계해주며, 네이버 지도와 연동하여 실시간 동선을 제공합니다.

---

## 주요 기능

### 🤖 AI 맞춤 데이트 코스 생성
- **Google Gemini 1.5 Pro** 기반 코스 추천
- 위치, 예산, 분위기, 테마에 따른 개인화 추천
- 상세 일정 및 이동 계획 자동 생성
- 날씨/상황 대비 대안 계획 제공

### 🗺️ 지도 기반 탐색
- **네이버 지도** 연동
- GPS 기반 현재 위치 인식
- 실시간 동선 시각화
- 장소별 상세 정보 제공

### 🔐 소셜 로그인 & 인증
- **Firebase Authentication** 연동
- **Google 소셜 로그인** 지원
- 사용자 프로필 관리

### ⭐ 즐겨찾기 & 저장
- 마음에 드는 장소 즐겨찾기
- 생성한 코스 저장 및 관리
- **Cloud Firestore** 실시간 동기화

### 📍 장소 탐색
- 카테고리별 장소 탐색
- 필터링 및 검색 기능
- 상세 장소 정보 (주소, 비용, 추천 이유)

---

## 기술 스택

### 핵심 프레임워크

| 기술 | 버전 | 설명 |
|------|------|------|
| **Flutter** | 3.4+ | 크로스 플랫폼 UI 프레임워크 |
| **Dart** | ^3.4.3 | 프로그래밍 언어 |

### 상태 관리

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **flutter_riverpod** | ^2.6.1 | 반응형 상태 관리 |
| **provider** | ^6.1.2 | 레거시 상태 관리 |

### AI & 머신러닝

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **google_generative_ai** | ^0.2.0 | Google Gemini AI 연동 |

### Firebase 서비스

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **firebase_core** | any | Firebase 초기화 |
| **firebase_auth** | ^5.5.1 | 사용자 인증 |
| **cloud_firestore** | ^5.6.5 | 실시간 데이터베이스 |
| **google_sign_in** | ^6.2.2 | Google 소셜 로그인 |

### 지도 & 위치

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **flutter_naver_map** | ^1.0.2 | 네이버 지도 SDK |
| **google_maps_flutter** | ^2.10.1 | Google 지도 (옵션) |
| **flutter_map** | ^5.0.0 | OpenStreetMap 지도 |
| **location** | ^5.0.0 | 위치 서비스 |
| **geolocator** | ^10.1.0 | GPS 위치 정보 |
| **geocoding** | ^2.1.1 | 주소 ↔ 좌표 변환 |
| **latlong2** | ^0.9.0 | 위도/경도 처리 |

### 네트워크 & API

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **dio** | ^5.8.0+1 | HTTP 클라이언트 |
| **http** | ^1.1.0 | HTTP 요청 처리 |

### 의존성 주입

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **get_it** | ^8.0.3 | 서비스 로케이터 |

### 코드 생성

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **freezed** | ^2.3.5 | 불변 클래스 생성 |
| **json_serializable** | ^6.6.2 | JSON 직렬화 |
| **json_annotation** | ^4.9.0 | JSON 어노테이션 |
| **build_runner** | ^2.3.3 | 코드 생성 실행기 |

### UI 컴포넌트

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **timeline_tile** | ^2.0.0 | 타임라인 UI |
| **cupertino_icons** | ^1.0.6 | iOS 스타일 아이콘 |

### 유틸리티

| 패키지 | 버전 | 용도 |
|--------|------|------|
| **shared_preferences** | ^2.3.3 | 로컬 키-값 저장소 |
| **uuid** | ^4.5.1 | 고유 ID 생성 |
| **intl** | ^0.20.2 | 국제화 및 날짜 포맷팅 |
| **url_launcher** | ^6.3.1 | URL 열기 |
| **permission_handler** | ^11.3.1 | 권한 관리 |
| **flutter_dotenv** | ^5.0.2 | 환경 변수 관리 |
| **logger** | ^2.0.2 | 로깅 시스템 |

---

## 아키텍처

### MVVM + Clean Architecture

```
lib/
├── main.dart                    # 앱 진입점
├── app.dart                     # 앱 전체 설정 (라우팅, 테마)
├── firebase_options.dart        # Firebase 설정
│
├── models/                      # 데이터 모델
│   ├── user.dart               # 사용자 모델 (Freezed)
│   ├── user_profile.dart       # 프로필 모델
│   ├── date_course.dart        # 데이트 코스 모델
│   ├── date_place.dart         # 장소 모델
│   ├── place.dart              # 장소 상세 모델
│   ├── explore_filter.dart     # 탐색 필터 모델
│   └── recommendation.dart     # 추천 모델
│
├── providers/                   # Riverpod Provider 설정
│   ├── provider_setup.dart     # 전역 Provider 설정
│   ├── auth_providers.dart     # 인증 관련 Provider
│   ├── repository_providers.dart # Repository Provider
│   └── view_model_providers.dart # ViewModel Provider
│
├── repositories/                # 데이터 레포지토리
│   ├── auth_repository.dart    # 인증 데이터 접근
│   ├── user_repository.dart    # 사용자 데이터 접근
│   ├── user_profile_repository.dart
│   ├── date_repository.dart    # 데이트 코스 데이터
│   ├── favorites_repository.dart # 즐겨찾기 데이터
│   └── ai_course_repository.dart # AI 코스 데이터
│
├── services/                    # 비즈니스 서비스
│   ├── auth_service.dart       # 인증 서비스
│   ├── api_service.dart        # API 서비스
│   ├── firebase_course_service.dart # Firebase 코스 서비스
│   └── ai/                     # AI 서비스
│       ├── ai_service.dart     # AI 추상 서비스
│       ├── gemini_service.dart # Gemini AI 연동
│       ├── ai_course_service.dart # AI 코스 생성
│       └── recommendation_service.dart # 추천 서비스
│
├── view_models/                 # MVVM ViewModel
│   ├── auth_view_model.dart    # 인증 상태 관리
│   ├── home_view_model.dart    # 홈 화면 로직
│   ├── explore_view_model.dart # 탐색 화면 로직
│   ├── favorites_view_model.dart # 즐겨찾기 로직
│   └── ai_course_view_model.dart # AI 코스 로직
│
├── views/                       # UI 화면
│   ├── splash/                 # 스플래시 화면
│   ├── auth/                   # 인증 화면
│   ├── home/                   # 홈 화면
│   ├── explore/                # 장소 탐색 화면
│   ├── course/                 # 코스 상세 화면
│   ├── place/                  # 장소 상세 화면
│   ├── favorites/              # 즐겨찾기 화면
│   ├── profile/                # 프로필 화면
│   ├── settings/               # 설정 화면
│   ├── timeline_tile/          # 타임라인 위젯
│   └── common/                 # 공통 위젯
│
├── utils/                       # 유틸리티
│   ├── app_logger.dart         # 로깅 유틸
│   └── theme.dart              # 앱 테마 설정
│
└── generated/                   # 자동 생성 코드
    └── assets.dart             # 에셋 상수
```

---

## AI 코스 생성 로직

### Gemini 서비스 (Singleton)

```dart
class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;

  late final GenerativeModel _model;

  Future<void> initialize() async {
    _model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
    );
  }

  Future<String> generateContent(String prompt) async {
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }
}
```

### AI 코스 생성 요청

```dart
Future<String> generateDateCourse({
  required String location,
  required String preferences,
  required String budget,
  required String duration,
  String? mood,
  String? specialRequirements,
}) async {
  final prompt = '''
  당신은 데이트 코스 전문가입니다.
  위치: $location
  테마/선호도: $preferences
  예산: $budget
  소요 시간: $duration

  ## 상세 일정
  ### 1. [시간] - [장소명]
  - 주소: [정확한 주소]
  - 활동 설명: [설명]
  - 예상 비용: [비용]
  - 추천 이유: [이유]
  ...
  ''';

  return await _geminiService.generateContent(prompt);
}
```

---

## 설치 및 실행

### 사전 요구사항
- Flutter SDK 3.4 이상
- Dart SDK 3.4.3 이상
- Firebase 프로젝트 설정
- 네이버 클라우드 플랫폼 계정 (지도 API)
- Google Cloud 프로젝트 (Gemini API)

### 환경 변수 설정

`assets/.env` 파일을 생성하고 다음 내용을 추가:

```env
NAVER_API_KEY=your_naver_map_client_id
GEMINI_API_KEY=your_gemini_api_key
```

### Firebase 설정

1. Firebase Console에서 프로젝트 생성
2. Authentication에서 Google 로그인 활성화
3. Cloud Firestore 데이터베이스 생성
4. `flutterfire configure` 명령으로 설정 파일 생성

### 설치 및 실행

```bash
# 저장소 클론
git clone https://github.com/buelmanager/date_sketch_with_ai.git

# 디렉토리 이동
cd date_sketch_with_ai

# 의존성 설치
flutter pub get

# 코드 생성 (Freezed, JSON 직렬화)
flutter pub run build_runner build --delete-conflicting-outputs

# 실행
flutter run
```

### 빌드

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 지원 플랫폼

| 플랫폼 | 지원 |
|--------|------|
| Android | ✅ (주요 타겟) |
| iOS | ✅ |
| Web | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |

---

## 데이터 흐름

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    View     │ ←── │  ViewModel  │ ←── │ Repository  │
│  (Flutter)  │     │ (Riverpod)  │     │   (Data)    │
└─────────────┘     └─────────────┘     └─────────────┘
                           │                    │
                           ↓                    ↓
                    ┌─────────────┐     ┌─────────────┐
                    │   Service   │     │   Firebase  │
                    │ (Gemini AI) │     │ (Firestore) │
                    └─────────────┘     └─────────────┘
```

---

## 디자인 패턴

- **MVVM** - View, ViewModel, Model 분리
- **Clean Architecture** - 레이어 분리 (Data, Domain, Presentation)
- **Repository Pattern** - 데이터 소스 추상화
- **Singleton** - 서비스 인스턴스 관리 (GeminiService)
- **Dependency Injection** - GetIt을 활용한 의존성 주입
- **Immutable State** - Freezed를 활용한 불변 상태
- **Provider Pattern** - Riverpod 상태 관리

---

## 커스텀 폰트

```yaml
fonts:
  - family: Pretendard
    fonts:
      - asset: assets/fonts/Pretendard-R.ttf
      - asset: assets/fonts/Pretendard-M.ttf
        weight: 500
      - asset: assets/fonts/Pretendard-B.ttf
        weight: 700
```

---

## GitHub Actions (CI/CD)

`.github/` 디렉토리에 CI/CD 워크플로우가 설정되어 있습니다.

---

## 라이선스

© 2025 buelmanager. All Rights Reserved.

---

## 연락처

- **GitHub**: [@buelmanager](https://github.com/buelmanager)
- **Email**: buelmanager@gmail.com
