class EnvConfig {
  static const bool isDevelopment = true;
  
  // Use your machine's IP address here when running on a physical device or simulator
  static const String serverHost = isDevelopment 
      ? '10.0.2.2' // Android emulator localhost
      : 'your-production-server.com';
  
  static const int serverPort = 3200;
  
  static String get apiBaseUrl => 'http://$serverHost:$serverPort/api';
}