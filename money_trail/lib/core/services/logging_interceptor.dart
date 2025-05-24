import 'dart:convert';
import 'dart:developer' as developer;

class LoggingInterceptor {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';

  void logRequest(String method, Uri url, Map<String, String> headers, dynamic body) {
    final timestamp = DateTime.now();
    developer.log(
      '''
$_yellow┌────────────────────────────── Request ──────────────────────────────$_reset
$_yellow│$_reset Timestamp: $timestamp
$_yellow│$_reset Method: $_blue$method$_reset
$_yellow│$_reset URL: $_cyan$url$_reset
$_yellow│$_reset Headers: $_magenta${_formatJson(headers)}$_reset
$_yellow│$_reset Body: ${body != null ? _formatJson(body) : 'null'}
$_yellow└─────────────────────────────────────────────────────────────────────$_reset
''',
      name: 'HTTP',
    );
  }

  void logResponse(int statusCode, Map<String, String> headers, String body, Duration duration) {
    final color = statusCode >= 200 && statusCode < 300 ? _green : _red;
    developer.log(
      '''
$color┌────────────────────────────── Response ─────────────────────────────$_reset
$color│$_reset Status Code: $color$statusCode$_reset
$color│$_reset Duration: ${duration.inMilliseconds}ms
$color│$_reset Headers: $_magenta${_formatJson(headers)}$_reset
$color│$_reset Body: ${_formatJson(jsonDecode(body))}
$color└─────────────────────────────────────────────────────────────────────$_reset
''',
      name: 'HTTP',
    );
  }

  void logError(Object error, StackTrace stackTrace) {
    developer.log(
      '''
$_red┌────────────────────────────── Error ────────────────────────────────$_reset
$_red│$_reset Error: $error
$_red│$_reset Stack Trace:
$_red│$_reset ${stackTrace.toString().split('\n').join('\n$_red│$_reset ')}
$_red└─────────────────────────────────────────────────────────────────────$_reset
''',
      name: 'HTTP',
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _formatJson(dynamic json) {
    if (json == null) return 'null';
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }
}