import 'dart:convert';
import 'package:http/http.dart' as http;
import 'logging_interceptor.dart';

class CustomHttpClient extends http.BaseClient {
  final http.Client _inner;
  final LoggingInterceptor _interceptor;

  CustomHttpClient({
    http.Client? inner,
    LoggingInterceptor? interceptor,
  })  : _inner = inner ?? http.Client(),
        _interceptor = interceptor ?? LoggingInterceptor();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final timestamp = DateTime.now();
      
      // Log request
      if (request is http.Request && request.body.isNotEmpty) {
        _interceptor.logRequest(
          request.method,
          request.url,
          request.headers,
          _tryDecodeJson(request.body),
        );
      } else {
        _interceptor.logRequest(
          request.method,
          request.url,
          request.headers,
          null,
        );
      }

      // Send request and measure duration
      final response = await _inner.send(request);
      final duration = DateTime.now().difference(timestamp);

      // Get response body
      final body = await response.stream.bytesToString();
      final headers = response.headers;
      final statusCode = response.statusCode;

      // Log response
      _interceptor.logResponse(statusCode, headers, body, duration);

      // Return response that can be read again
      return http.StreamedResponse(
        Stream.value(utf8.encode(body)),
        statusCode,
        headers: headers,
        contentLength: body.length,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
        request: response.request,
      );
    } catch (error, stackTrace) {
      _interceptor.logError(error, stackTrace);
      rethrow;
    }
  }

  dynamic _tryDecodeJson(String body) {
    try {
      return json.decode(body);
    } catch (_) {
      return body;
    }
  }
}