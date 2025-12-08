import 'api_service.dart';
import '../models/category.dart';
import '../models/notification_model.dart';
import '../models/transaction.dart';
import '../models/user.dart';

class AdminService {
  final ApiService _apiService = ApiService();

  // ================== MENGELOLA KATEGORI ==================

  Future<List<Category>> getCategories() async {
    final response = await _apiService.get('/admin/categories');

    if (response['success']) {
      final List categoriesJson = response['data'];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat kategori');
    }
  }

  Future<Category> createCategory({
    required String name,
    String? description,
    String? icon,
  }) async {
    final response = await _apiService.post('/admin/categories', body: {
      'name': name,
      'description': description,
      'icon': icon,
    });

    if (response['success']) {
      return Category.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Gagal membuat kategori');
    }
  }

  Future<Category> updateCategory({
    required int id,
    String? name,
    String? description,
    String? icon,
  }) async {
    final response = await _apiService.put('/admin/categories/$id', body: {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
    });

    if (response['success']) {
      return Category.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Gagal update kategori');
    }
  }

  Future<void> deleteCategory(int id) async {
    final response = await _apiService.delete('/admin/categories/$id');

    if (!response['success']) {
      throw Exception(response['message'] ?? 'Gagal hapus kategori');
    }
  }

  // ================== MELIHAT NOTIFIKASI ==================

  Future<List<NotificationModel>> getAllNotifications() async {
    final response = await _apiService.get('/admin/notifications');

    if (response['success']) {
      final data = response['data'];
      final List notificationsJson = data['data'] ?? data;
      return notificationsJson
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat notifikasi');
    }
  }

  Future<NotificationModel> createNotification({
    int? userId, // null = broadcast to all
    required String title,
    required String message,
    required String type, // info, success, warning, error
    Map<String, dynamic>? data,
  }) async {
    final response = await _apiService.post('/admin/notifications', body: {
      if (userId != null) 'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'data': data,
    });

    if (response['success']) {
      return NotificationModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Gagal membuat notifikasi');
    }
  }

  // ================== MELIHAT RIWAYAT PESANAN ==================

  Future<List<Transaction>> getAllTransactions() async {
    final response = await _apiService.get('/admin/transactions');

    if (response['success']) {
      final data = response['data'];
      final List transactionsJson = data['data'] ?? data;
      return transactionsJson.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat transaksi');
    }
  }

  Future<Map<String, dynamic>> getTransactionStats() async {
    final response = await _apiService.get('/admin/transactions/stats');

    if (response['success']) {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat statistik');
    }
  }

  // ================== MENERIMA PEMBAYARAN/PENCAIRAN ==================

  Future<List<User>> getPengepulPayments() async {
    final response = await _apiService.get('/admin/payments/pengepul');

    if (response['success']) {
      final List pengepulsJson = response['data'];
      return pengepulsJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat data pengepul');
    }
  }

  Future<void> processPayment({
    required int pengepulId,
    required double amount,
    String? notes,
  }) async {
    final response = await _apiService.post('/admin/payments/process', body: {
      'pengepul_id': pengepulId,
      'amount': amount,
      'notes': notes,
    });

    if (!response['success']) {
      throw Exception(response['message'] ?? 'Gagal memproses pembayaran');
    }
  }
}
