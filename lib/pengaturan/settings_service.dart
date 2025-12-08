import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pti/core/api.dart';

class SettingsService extends ChangeNotifier {
  SettingsService._internal();

  static final SettingsService instance = SettingsService._internal();

  late SharedPreferences _prefs;

  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String? _apiBaseUrl;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  String? get apiBaseUrl => _apiBaseUrl;

  /// Initialize and load saved preferences. Call once before runApp if possible.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    _apiBaseUrl = _prefs.getString('api_base_url');
    // If Api URL was set in prefs, update ApiConfig
    if (_apiBaseUrl != null && _apiBaseUrl!.isNotEmpty) {
      ApiConfig.setBaseUrl(_apiBaseUrl!);
    }
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }

  Future<void> setApiBaseUrl(String? url) async {
    _apiBaseUrl = url;
    if (url == null || url.isEmpty) {
      await _prefs.remove('api_base_url');
    } else {
      await _prefs.setString('api_base_url', url);
    }
    ApiConfig.setBaseUrl(url ?? '');
    notifyListeners();
  }

  /// Simulate clearing app cache: remove keys that start with `cache_` (if any).
  Future<void> clearCache() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith('cache_')).toList();
    for (final k in keys) {
      await _prefs.remove(k);
    }
    // no change to theme/notifications by default
  }

  /// Logout helper: remove auth token and other user-specific keys.
  Future<void> logout() async {
    // Remove auth token
    await _prefs.remove('auth_token');
    // Remove user-specific data
    await _prefs.remove('user_id');
    await _prefs.remove('user_email');
    await _prefs.remove('user_name');
    await _prefs.remove('user_role');
    // Clear cached data if needed
    await clearCache();
  }
}
