import '../../models/user_model.dart';
import '../../core/utils/logger.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<User> signUp({
    required String username,
    required String password,
  }) async {
    try {
      print('AuthService: Starting signup process'); // Debug print
      Logger.info('AuthService.signUp: Starting signup process');
      print('AuthService: Making API request to /auth/signup'); // Debug print
      Logger.info('AuthService.signUp: Making API request to /auth/signup');
      
      final response = await _apiClient.post(
        '/auth/signup',
        {
          'username': username,
          'password': password,
        },
        requiresAuth: false,
      );
      
      Logger.info('AuthService.signUp: API request successful');
      Logger.info('AuthService.signUp: Response received: ${response.toString()}');

      if (!response.containsKey('token')) {
        throw Exception('Server response missing token');
      }

      final user = User(username: username, token: response['token']);
      Logger.info('AuthService.signUp: User object created');
      
      await _apiClient.saveToken(user.token);
      Logger.info('AuthService.signUp: Token saved to storage');
      
      return user;
    } catch (e, stackTrace) {
      Logger.error(
        'AuthService.signUp: Error during signup process',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<User> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      {
        'username': username,
        'password': password,
      },
      requiresAuth: false,
    );

    final user = User(username: username, token: response['token']);
    await _apiClient.saveToken(user.token);
    return user;
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  bool get isAuthenticated => _apiClient.token != null;
}