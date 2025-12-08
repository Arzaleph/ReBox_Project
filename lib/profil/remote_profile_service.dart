import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_pti/core/api.dart';

class RemoteProfileService {
  RemoteProfileService._internal();
  static final RemoteProfileService instance = RemoteProfileService._internal();

  /// Fetch profile from GET /api/profile
  Future<Map<String, dynamic>> fetchProfile() async {
    final base = ApiConfig.baseUrl;
    if (base.isEmpty) throw Exception('API base URL not configured');
    final uri = Uri.parse(base).replace(path: '/api/profile');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Fetch profile failed (${resp.statusCode})');
    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    return map;
  }

  /// Update profile via PUT /api/profile with JSON body
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> payload) async {
    final base = ApiConfig.baseUrl;
    if (base.isEmpty) throw Exception('API base URL not configured');
    final uri = Uri.parse(base).replace(path: '/api/profile');
    final resp = await http.put(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
    if (resp.statusCode != 200) throw Exception('Update profile failed (${resp.statusCode})');
    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    return map;
  }
}
