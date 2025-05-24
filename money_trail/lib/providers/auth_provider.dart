import 'package:flutter/foundation.dart';
import '../core/services/auth_service.dart';
import '../core/utils/logger.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService);

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  String _getUserFriendlyError(dynamic error) {
    final errorMessage = error.toString().toLowerCase();
    
    if (errorMessage.contains('user already exists')) {
      return 'This username is already taken';
    }
    if (errorMessage.contains('user not found')) {
      return 'Invalid username or password';
    }
    if (errorMessage.contains('wrong password')) {
      return 'Invalid username or password';
    }
    if (errorMessage.contains('connection refused')) {
      return 'Unable to connect to server. Please try again later.';
    }
    if (errorMessage.contains('network is unreachable')) {
      return 'No internet connection';
    }
    if (errorMessage.contains('mongodb')) {
      return 'Database error. Please try again later.';
    }
    
    return 'An unexpected error occurred';
  }

  Future<bool> signUp({
    required String username,
    required String password,
  }) async {
    print('AuthProvider: signUp called with username: $username'); // Debug print
    Logger.info('AuthProvider.signUp called with username: $username');
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      print('AuthProvider: State updated - loading started'); // Debug print
      Logger.info('State updated: loading=true, error=null');

      // Validate input
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Username and password cannot be empty');
      }
      Logger.info('Input validation passed');

      // Attempt signup
      Logger.info('Calling AuthService.signUp...');
      _user = await _authService.signUp(
        username: username,
        password: password,
      );
      Logger.info('AuthService.signUp returned successfully');

      if (_user == null) {
        throw Exception('User is null after successful signup');
      }

      Logger.info('Sign up successful, user object created');
      _isLoading = false;
      notifyListeners();
      Logger.info('State updated: loading=false, user saved');
      return true;
      
    } catch (e, stackTrace) {
      _isLoading = false;
      Logger.error(
        'Sign up failed for user: $username',
        error: e,
        stackTrace: stackTrace,
      );

      // Get user-friendly error message
      _error = _getUserFriendlyError(e);
      Logger.info('Error message set to: $_error');
      
      notifyListeners();
      Logger.info('State updated: loading=false, error set');
      return false;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Logger.info('Attempting to log in user: $username');

      _user = await _authService.login(
        username: username,
        password: password,
      );

      Logger.info('Login successful for user: $username');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      _isLoading = false;

      // Log the full error details
      Logger.error(
        'Login failed for user: $username',
        error: e,
        stackTrace: stackTrace,
      );

      // Set a user-friendly error message
      _error = _getUserFriendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      Logger.info('Logging out user: ${_user?.username}');
      await _authService.logout();
      _user = null;
      notifyListeners();
      Logger.info('Logout successful');
    } catch (e, stackTrace) {
      Logger.error(
        'Logout failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}