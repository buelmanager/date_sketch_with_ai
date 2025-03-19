// lib/main.dart
import 'package:date_sketch_with_ai/services/ai/gemini_service.dart';
import 'package:date_sketch_with_ai/utils/app_logger.dart';
import 'package:date_sketch_with_ai/views/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'utils/theme.dart';
import 'views/auth/auth_wrapper.dart';

Future<void> requestLocationPermission() async {
  try {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    // 이제 위치 정보를 얻을 수 있습니다
    LocationData locationData = await location.getLocation();
    print('위도: ${locationData.latitude}, 경도: ${locationData.longitude}');
  } catch (e) {}

}
String getApiKey(String key) {
  return dotenv.env['${key}_API_KEY'] ?? "No API Key Found";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");

  String naverKey = getApiKey("NAVER");
  String geminiKey = getApiKey("GEMINI");

  AppLogger.d("geminiKey : $geminiKey");
  // Gemini 서비스 초기화
  final geminiService = GeminiService();
  await geminiService.initialize();

  //AppLogger.d("naverKey : " + naverKey);
  //AppLogger.d("geminiKey : " + geminiKey);

  await NaverMapSdk.instance.initialize(
    clientId: naverKey,
    // 필요한 경우 아래 옵션 설정
     onAuthFailed: (e) => AppLogger.e("네이버 맵 인증 실패: $e")
  );



  //await requestLocationPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    // Riverpod 프로바이더 스코프 추가
    const ProviderScope(
      child: MyApp(),
    ),
  );


}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '데이트 플래너',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        home: const SplashScreen(),
        routes: {
          '/auth': (context) => const AuthWrapper(),
          '/home': (context) => const DatePlannerApp(),
        },
      ),
    );
  }
}
