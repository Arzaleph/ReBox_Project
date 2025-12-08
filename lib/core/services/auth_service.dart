import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.post('/register', body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      if (response['success'] == true && response['data']['token'] != null) {
        await _apiService.setToken(response['data']['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('/login', body: {
        'email': email,
        'password': password,
      });

      if (response['success'] == true && response['data']['token'] != null) {
        await _apiService.setToken(response['data']['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post('/logout');
    } finally {
      await _apiService.clearToken();
    }
  }

  // Get current user
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.get('/user');
      return User.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null;
  }
}
