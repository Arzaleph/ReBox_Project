import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.read = false,
  });

  factory AppNotification.fromMap(Map<String, dynamic> m) {
    return AppNotification(
      id: m['id'] as String,
      title: m['title'] as String,
      body: m['body'] as String,
      timestamp: DateTime.parse(m['timestamp'] as String),
      read: m['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'read': read,
      };
}

class NotificationsService extends ChangeNotifier {
  NotificationsService._internal();
  static final NotificationsService instance = NotificationsService._internal();

  static const _kKey = 'notifications_list';
  late SharedPreferences _prefs;

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_kKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _notifications = list
            .map((e) => AppNotification.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {
        _notifications = [];
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final encoded = jsonEncode(_notifications.map((e) => e.toMap()).toList());
    await _prefs.setString(_kKey, encoded);
  }

  Future<void> addNotification({required String title, required String body}) async {
    final n = AppNotification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    _notifications.insert(0, n);
    await _save();
    notifyListeners();
  }

  Future<void> markRead(String id, {bool read = true}) async {
    final idx = _notifications.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _notifications[idx].read = read;
      await _save();
      notifyListeners();
    }
  }

  Future<void> remove(String id) async {
    _notifications.removeWhere((e) => e.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _notifications.clear();
    await _prefs.remove(_kKey);
    notifyListeners();
  }
}
