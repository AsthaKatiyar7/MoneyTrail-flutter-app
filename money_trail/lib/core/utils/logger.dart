import 'dart:developer' as developer;

class Logger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _cyan = '\x1B[36m';

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      '''
$_red┌────────────────────────────── Error ────────────────────────────────$_reset
$_red│$_reset Message: $message
${error != null ? '$_red│$_reset Error: $error\n' : ''}${stackTrace != null ? '$_red│$_reset Stack Trace:\n$_red│$_reset ${stackTrace.toString().split('\n').join('\n$_red│$_reset ')}\n' : ''}$_red└─────────────────────────────────────────────────────────────────────$_reset
''',
      name: 'APP',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void warn(String message) {
    developer.log(
      '''
$_yellow┌────────────────────────────── Warning ──────────────────────────────$_reset
$_yellow│$_reset $message
$_yellow└─────────────────────────────────────────────────────────────────────$_reset
''',
      name: 'APP',
    );
  }

  static void info(String message) {
    developer.log(
      '''
$_cyan┌────────────────────────────── Info ────────────────────────────────$_reset
$_cyan│$_reset $message
$_cyan└─────────────────────────────────────────────────────────────────────$_reset
''',
      name: 'APP',
    );
  }
}