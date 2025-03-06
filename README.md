# Date Sketch AI

🎨 AI가 그려주는 완벽한 데이트 플래너

## 📌 주요 기능
- AI 추천 맞춤 데이트 플랜
- 위치 기반 장소 추천
- 일정 최적화 및 동선 추천

## 🚀 설치 방법
Flutter 환경에서 실행하려면:

## 🚀 MVVM 구조
test 12

lib/
│── main.dart                # 앱의 진입점
│── app.dart                 # 앱 전체 설정 (라우팅, 테마)
│
├── core/                    # 핵심 기능 (유틸, 네트워크, API 등)
│   ├── services/            # API 호출, 로컬 데이터베이스, SharedPreferences
│   ├── utils/               # 공통 유틸리티 함수
│   ├── network/             # API 클라이언트 (Dio, HTTP 등)
│   ├── constants.dart       # 상수 값 관리
│
├── models/                  # 데이터 모델 (DTO, Entity)
│   ├── user_model.dart
│   ├── date_plan_model.dart
│
├── views/                   # UI 관련 코드 (Flutter Widgets)
│   ├── home/
│   │   ├── home_view.dart   # Home 화면 UI
│   │   ├── home_viewmodel.dart   # Home 화면 로직
│   │   ├── home_binding.dart   # Home 화면의 DI
│   │   ├── widgets/        # Home 화면에서 사용하는 개별 위젯
│   │
│   ├── detail/
│   │   ├── detail_view.dart  # 데이트 상세 화면
│   │   ├── detail_viewmodel.dart
│
├── viewmodels/              # 상태 관리 (MVVM의 ViewModel)
│   ├── home_viewmodel.dart
│   ├── date_plan_viewmodel.dart
│
├── widgets/                 # 재사용 가능한 공통 위젯
│   ├── custom_button.dart
│   ├── custom_card.dart
│
├── routes/                  # 라우팅 설정
│   ├── app_routes.dart
│
├── data/                    # 데이터 계층 (Repository)
│   ├── repositories/
│   │   ├── date_plan_repository.dart
│   ├── sources/
│   │   ├── local_data_source.dart
│   │   ├── remote_data_source.dart
│
├── providers/               # 상태 관리 라이브러리 관련 설정 (Riverpod, Provider 등)
│   ├── app_provider.dart
│
└── main.dart                # 앱 실행 파일 (MyApp)