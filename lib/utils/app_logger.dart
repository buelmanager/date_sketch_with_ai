import 'package:logger/logger.dart';

/// 로그 메시지를 정리된 형식으로 출력하는 커스텀 프린터
class CustomLogPrinter extends LogPrinter {
  final PrettyPrinter _prettyPrinter = PrettyPrinter(
    methodCount: 3, // 기본적으로 호출 스택을 출력하지 않음
    errorMethodCount: 7, // 에러 발생 시 호출 스택 깊이
    lineLength: 80, // 한 줄 길이 제한
    colors: false, // ANSI 색상 제거 (가독성 향상)
    printEmojis: true, // 이모지 활성화
    printTime: true, // 타임스탬프 출력
  );

  @override
  List<String> log(LogEvent event) {
    final trace = StackTrace.current.toString().split("\n")[2];
    final className = _extractClassName(trace);
    final logLevel = _getLogLevelEmoji(event.level);
    //final logMessage = "$logLevel [$className] ${event.message}";
    final logMessage = "${event.message}";

    return _prettyPrinter.log(LogEvent(event.level, logMessage, error: event.error, stackTrace: event.stackTrace));
  }

  /// StackTrace에서 클래스명과 메서드명을 추출하는 메서드
  String _extractClassName(String trace) {
    final regex = RegExp(r'#[0-9]+\s+([^\s]+)\s+\(');
    final match = regex.firstMatch(trace);
    return match != null ? match.group(1) ?? 'Unknown' : 'Unknown';
  }

  /// 로그 레벨별 이모지 반환
  String _getLogLevelEmoji(Level level) {
    switch (level) {
      case Level.verbose:
        return "🔍";
      case Level.debug:
        return "🐛";
      case Level.info:
        return "ℹ️";
      case Level.warning:
        return "⚠️";
      case Level.error:
        return "❌";
      case Level.wtf:
        return "💀";
      default:
        return "❓";
    }
  }
}

/// 전역에서 사용할 수 있는 AppLogger 클래스
class AppLogger {
  static final Logger _logger = Logger(
    printer: CustomLogPrinter(),
  );

  /// 디버그 레벨 로그
  static void d(String message) => _logger.d(message);

  /// 정보 레벨 로그
  static void i(String message) => _logger.i(message);

  /// 경고 레벨 로그
  static void w(String message) => _logger.w(message);

  /// 에러 레벨 로그 - 에러 객체와 스택 트레이스를 선택적으로 받을 수 있음
  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  /// 심각한 에러 레벨 로그 (What a Terrible Failure)
  static void wtf(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.wtf(message, error: error, stackTrace: stackTrace);
}