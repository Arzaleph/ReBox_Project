import 'api_service.dart';
import '../models/category.dart';

class CategoryService {
  final ApiService _apiService = ApiService();

  // Get all categories
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _apiService.get('/categories');
      final List<dynamic> data = response['data'];
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get single category
  Future<Category> getCategory(int id) async {
    try {
      final response = await _apiService.get('/categories/$id');
      return Category.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Create category
  Future<Category> createCategory({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _apiService.post('/categories', body: {
        'name': name,
        if (description != null) 'description': description,
      });
      return Category.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Update category
  Future<Category> updateCategory({
    required int id,
    required String name,
    String? description,
  }) async {
    try {
      final response = await _apiService.put('/categories/$id', body: {
        'name': name,
        if (description != null) 'description': description,
      });
      return Category.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    try {
      await _apiService.delete('/categories/$id');
    } catch (e) {
      rethrow;
    }
  }
}
