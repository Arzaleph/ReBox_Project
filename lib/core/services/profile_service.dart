import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/user.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  /// Get user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.get('/profile');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Update profile (name, phone, bio)
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? bio,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (bio != null) body['bio'] = bio;

      final response = await _apiService.put('/profile', body: body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload avatar
  Future<Map<String, dynamic>> uploadAvatar(File imageFile) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.baseUrl}/profile/avatar'),
      );

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      // Add image file
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'avatar',
        stream,
        length,
        filename: imageFile.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _apiService.parseResponse(responseData);
      } else {
        final errorData = _apiService.parseResponse(responseData);
        throw ApiException(
          statusCode: response.statusCode,
          message: errorData['message'] ?? 'Upload failed',
          errors: errorData['errors'],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get avatar URL
  String? getAvatarUrl(User user) {
    if (user.avatar == null || user.avatar!.isEmpty) {
      return null;
    }
    
    // If already full URL
    if (user.avatar!.startsWith('http')) {
      return user.avatar;
    }
    
    // Build full URL
    final baseUrl = ApiService.baseUrl.replaceAll('/api', '');
    return '$baseUrl/${user.avatar}';
  }
}
