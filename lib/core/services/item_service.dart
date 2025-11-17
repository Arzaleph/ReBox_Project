import 'api_service.dart';
import '../models/item.dart';

class ItemService {
  final ApiService _apiService = ApiService();

  // Get all items
  Future<List<Item>> getAllItems() async {
    try {
      final response = await _apiService.get('/items');
      final List<dynamic> data = response['data'];
      return data.map((json) => Item.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get single item
  Future<Item> getItem(int id) async {
    try {
      final response = await _apiService.get('/items/$id');
      return Item.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Create item
  Future<Item> createItem({
    required String name,
    String? description,
    required int boxId,
    int? categoryId,
    int quantity = 1,
  }) async {
    try {
      final response = await _apiService.post('/items', body: {
        'name': name,
        if (description != null) 'description': description,
        'box_id': boxId,
        if (categoryId != null) 'category_id': categoryId,
        'quantity': quantity,
      });
      return Item.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Update item
  Future<Item> updateItem({
    required int id,
    required String name,
    String? description,
    required int boxId,
    int? categoryId,
    int quantity = 1,
  }) async {
    try {
      final response = await _apiService.put('/items/$id', body: {
        'name': name,
        if (description != null) 'description': description,
        'box_id': boxId,
        if (categoryId != null) 'category_id': categoryId,
        'quantity': quantity,
      });
      return Item.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Delete item
  Future<void> deleteItem(int id) async {
    try {
      await _apiService.delete('/items/$id');
    } catch (e) {
      rethrow;
    }
  }
}
