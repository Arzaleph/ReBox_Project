import 'api_service.dart';
import '../models/box.dart';

class BoxService {
  final ApiService _apiService = ApiService();

  // Get all boxes
  Future<List<Box>> getAllBoxes() async {
    try {
      final response = await _apiService.get('/boxes');
      final List<dynamic> data = response['data'];
      return data.map((json) => Box.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get single box
  Future<Box> getBox(int id) async {
    try {
      final response = await _apiService.get('/boxes/$id');
      return Box.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Create box
  Future<Box> createBox({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _apiService.post('/boxes', body: {
        'name': name,
        if (description != null) 'description': description,
      });
      return Box.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Update box
  Future<Box> updateBox({
    required int id,
    required String name,
    String? description,
  }) async {
    try {
      final response = await _apiService.put('/boxes/$id', body: {
        'name': name,
        if (description != null) 'description': description,
      });
      return Box.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Delete box
  Future<void> deleteBox(int id) async {
    try {
      await _apiService.delete('/boxes/$id');
    } catch (e) {
      rethrow;
    }
  }
}
