import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/date_repository.dart';
import '../repositories/user_repository.dart';
import '../utils/app_logger.dart'; // 로그 유틸 추가

/// 데이트 관련 데이터를 관리하는 저장소 제공자
/// DateRepository 인스턴스를 생성하여 제공
final dateRepositoryProvider = Provider<DateRepository>((ref) {
  AppLogger.d("Initializing DateRepository"); // 저장소 초기화 로그
  return DateRepository();
});

/// 사용자 관련 데이터를 관리하는 저장소 제공자
/// UserRepository 인스턴스를 생성하여 제공
final userRepositoryProvider = Provider<UserRepository>((ref) {
  AppLogger.d("Initializing UserRepository"); // 저장소 초기화 로그
  return UserRepository();
});