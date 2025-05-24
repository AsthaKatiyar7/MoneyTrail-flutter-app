import 'package:flutter/material.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      // Dashboard will be added later
      dashboard: (context) => const Scaffold(
            body: Center(
              child: Text('Dashboard - Coming Soon'),
            ),
          ),
    };
  }
}