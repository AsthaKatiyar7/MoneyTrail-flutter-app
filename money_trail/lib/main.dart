import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/api_client.dart';
import 'core/services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => ApiClient(prefs),
        ),
        ProxyProvider<ApiClient, AuthService>(
          update: (_, apiClient, __) => AuthService(apiClient),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create: (_) => AuthProvider(AuthService(ApiClient(prefs))),
          update: (_, authService, previous) =>
              previous ?? AuthProvider(authService),
        ),
      ],
      child: MaterialApp(
        title: 'Money Trail',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
