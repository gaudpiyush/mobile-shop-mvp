import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  static const String appName = 'Mobile Shop';

  static String get baseUrl => kIsWeb 
      ? 'http://localhost:8000'
      : 'http://10.0.2.2:8000';
}