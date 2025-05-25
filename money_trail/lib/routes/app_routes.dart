import 'package:flutter/material.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/analytics/analytics_screen.dart';
import '../views/expenses/form_screen.dart';
import '../views/expenses/voice_note_screen.dart';
import '../views/expenses/scan_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String analytics = '/analytics';
  static const String form = '/form';
  static const String voiceNote = '/voice-note';
  static const String scan = '/scan';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      dashboard: (context) => const DashboardScreen(),
      analytics: (context) => const AnalyticsScreen(),
      form: (context) => const FormScreen(),
      voiceNote: (context) => const VoiceNoteScreen(),
      scan: (context) => const ScanScreen(),
    };
  }
}
