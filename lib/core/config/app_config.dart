import 'package:flutter/material.dart';

/// Configuration helper untuk mengelola API settings
class AppConfig {
  // Base URL Configuration
  // PENTING: Ganti sesuai dengan environment testing Anda!
  
  /// Untuk Android Emulator
  static const String emulatorUrl = 'http://10.0.2.2:8000/api';
  
  /// Untuk iOS Simulator
  static const String iosSimulatorUrl = 'http://127.0.0.1:8000/api';
  
  /// Untuk Physical Device (HP)
  /// GANTI dengan IP komputer Anda!
  /// Cara cek: buka CMD > ketik 'ipconfig' > lihat IPv4 Address
  /// Contoh: 192.168.1.28
  static const String physicalDeviceUrl = 'http://192.168.1.28:8000/api';
  
  /// Development URL (localhost)
  static const String localhostUrl = 'http://127.0.0.1:8000/api';
  
  // App Information
  static const String appName = 'ReBox';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplikasi Manajemen Box & Item';
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Timeout Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // Cache Configuration
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 3;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  
  // Theme Colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.blueAccent;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  
  // Helper method untuk debug mode
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
  
  // Helper method untuk print log (hanya di debug mode)
  static void log(String message, {String tag = 'AppConfig'}) {
    if (isDebugMode) {
      debugPrint('[$tag] $message');
    }
  }
}

/// Platform helper untuk menentukan base URL otomatis
/// Belum diimplementasikan, gunakan manual config di ApiService
class PlatformHelper {
  static const bool isAndroid = true; // Set manual
  static const bool isIOS = false;
  static const bool isPhysicalDevice = true; // Set manual
  
  /// Get recommended base URL berdasarkan platform
  static String getRecommendedBaseUrl() {
    if (isPhysicalDevice) {
      return AppConfig.physicalDeviceUrl;
    } else if (isAndroid) {
      return AppConfig.emulatorUrl;
    } else if (isIOS) {
      return AppConfig.iosSimulatorUrl;
    } else {
      return AppConfig.localhostUrl;
    }
  }
}
