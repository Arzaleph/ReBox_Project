import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  SettingsService._internal();

  static final SettingsService instance = SettingsService._internal();

  late SharedPreferences _prefs;

  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Initialize and load saved preferences. Call once before runApp if possible.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
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
    // Remove token key if exists. Adjust key name if your project uses different key.
    await _prefs.remove('auth_token');
  }
}
