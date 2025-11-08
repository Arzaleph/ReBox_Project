import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pti/core/api.dart';
import 'package:project_pti/profil/remote_profile_service.dart';

class ProfileService extends ChangeNotifier {
  ProfileService._internal();
  static final ProfileService instance = ProfileService._internal();

  late SharedPreferences _prefs;

  String _name = '';
  String _email = '';
  String _phone = '';
  String _avatarUrl = '';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get avatarUrl => _avatarUrl;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _name = _prefs.getString('profile_name') ?? '';
    _email = _prefs.getString('profile_email') ?? '';
    _phone = _prefs.getString('profile_phone') ?? '';
    _avatarUrl = _prefs.getString('profile_avatar') ?? '';
    notifyListeners();
    // If Api is configured, attempt to fetch remote profile and merge
    if (ApiConfig.baseUrl.isNotEmpty) {
      try {
        await syncFromRemote();
      } catch (_) {
        // ignore remote errors here, local data stays
      }
    }
  }

  Future<void> setName(String v) async {
    _name = v;
    await _prefs.setString('profile_name', v);
    notifyListeners();
  }

  Future<void> setEmail(String v) async {
    _email = v;
    await _prefs.setString('profile_email', v);
    notifyListeners();
  }

  Future<void> setPhone(String v) async {
    _phone = v;
    await _prefs.setString('profile_phone', v);
    notifyListeners();
  }

  Future<void> setAvatarUrl(String v) async {
    _avatarUrl = v;
    await _prefs.setString('profile_avatar', v);
    notifyListeners();
  }

  Future<void> clearProfile() async {
    _name = '';
    _email = '';
    _phone = '';
    _avatarUrl = '';
    await _prefs.remove('profile_name');
    await _prefs.remove('profile_email');
    await _prefs.remove('profile_phone');
    await _prefs.remove('profile_avatar');
    notifyListeners();
  }

  /// Try to fetch profile from remote and overwrite local storage.
  Future<void> syncFromRemote() async {
    final map = await RemoteProfileService.instance.fetchProfile();
    _name = map['name']?.toString() ?? _name;
    _email = map['email']?.toString() ?? _email;
    _phone = map['phone']?.toString() ?? _phone;
    _avatarUrl = map['avatarUrl']?.toString() ?? _avatarUrl;
    // persist
    await _prefs.setString('profile_name', _name);
    await _prefs.setString('profile_email', _email);
    await _prefs.setString('profile_phone', _phone);
    await _prefs.setString('profile_avatar', _avatarUrl);
    notifyListeners();
  }

  /// Try to push local profile to remote. Returns remote response map.
  Future<Map<String, dynamic>> syncToRemote() async {
    final payload = {
      'name': _name,
      'email': _email,
      'phone': _phone,
      'avatarUrl': _avatarUrl,
    };
    final resp = await RemoteProfileService.instance.updateProfile(payload);
    return resp;
  }
}
