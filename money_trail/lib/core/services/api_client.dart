import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:money_trail/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/env_config.dart';
import 'http_client.dart';

class ApiClient {
  static String get baseUrl => EnvConfig.apiBaseUrl;
  static const String tokenKey = 'auth_token';

  final SharedPreferences _prefs;
  final http.Client _client;

  ApiClient(this._prefs) : _client = CustomHttpClient();

  String? get token => _prefs.getString(tokenKey);

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {bool requiresAuth = true}) async {
    print('\n--- API Request Starting ---'); // Debug separator
    try {
      final url = '$baseUrl$endpoint';
      print('ApiClient: Making POST request to $url'); // Debug print
      print('ApiClient: Request body: ${json.encode(body)}'); // Debug print
      
      Logger.info('ApiClient.post: Preparing request');
      Logger.info('ApiClient.post: URL: $url');
      Logger.info('ApiClient.post: Body: ${json.encode(body)}');
      
      final headers = {
        'Content-Type': 'application/json',
        if (requiresAuth && token != null) 'Authorization': 'Bearer $token',
      };
      Logger.info('ApiClient.post: Headers: ${json.encode(headers)}');

      Logger.info('ApiClient.post: Sending request...');
      final response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      Logger.info('ApiClient.post: Response received');
      Logger.info('ApiClient.post: Status code: ${response.statusCode}');
      Logger.info('ApiClient.post: Response body: ${response.body}');

      final data = json.decode(response.body);
      Logger.info('ApiClient.post: Parsed response data: ${json.encode(data)}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('ApiClient: Request successful'); // Debug print
        print('ApiClient: Response data: ${json.encode(data)}'); // Debug print
        Logger.info('ApiClient.post: Request successful');
        return data;
      } else {
        print('ApiClient: Request failed with status ${response.statusCode}'); // Debug print
        print('ApiClient: Error response: ${response.body}'); // Debug print
        Logger.error('ApiClient.post: Request failed', 
          error: 'Status: ${response.statusCode}, Body: ${response.body}');
        
        final errorMessage = data['error'] ?? 'An error occurred';
        print('ApiClient: Throwing error: $errorMessage'); // Debug print
        
        throw ApiException(
          message: errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      if (token == null) {
        throw ApiException(message: 'Not authenticated', statusCode: 401);
      }

      final response = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw ApiException(
          message: data['error'] ?? 'An error occurred',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(tokenKey, token);
  }

  Future<void> clearToken() async {
    await _prefs.remove(tokenKey);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}