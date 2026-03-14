import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  static const String appName = 'Mobile Shop';

  static String get baseUrl => kIsWeb 
      ? 'https://mobile-shop-mvp.onrender.com'
      : 'http://10.0.2.2:8000';
}