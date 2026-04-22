import 'package:flutter/foundation.dart';

class Variables {
  // URL saat development (debug/profile).
  static const String _baseUrlDevelopment =
      'https://punctuate-envelope-bogus.ngrok-free.dev';

  // URL production diisi melalui --dart-define=PROD_BASE_URL=...
  static const String _baseUrlProduction =
      String.fromEnvironment('PROD_BASE_URL', defaultValue: '');

  static String get baseUrl =>
      kReleaseMode && _baseUrlProduction.isNotEmpty
          ? _baseUrlProduction
          : _baseUrlDevelopment;

  static String get imageBaseUrl => '$baseUrl/storage/products/';
}
