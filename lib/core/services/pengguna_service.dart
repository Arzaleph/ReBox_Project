import 'api_service.dart';
import '../models/transaction.dart';
import '../models/notification_model.dart';

class PenggunaService {
  final ApiService _apiService = ApiService();

  // Get my transactions (as pengguna/seller)
  Future<List<Transaction>> getMyTransactions() async {
    final response = await _apiService.get('/pengguna/transactions');
    
    if (response['success']) {
      final data = response['data'];
      final List transactionsJson = data['data'] ?? data; // Handle pagination
      return transactionsJson.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat transaksi');
    }
  }

  // Accept transaction offer
  Future<Transaction> acceptTransaction(int transactionId) async {
    final response = await _apiService.put(
      '/pengguna/transactions/$transactionId/accept',
      body: {},
    );

    if (response['success']) {
      return Transaction.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Gagal menerima transaksi');
    }
  }

  // Reject transaction offer
  Future<Transaction> rejectTransaction(int transactionId) async {
    final response = await _apiService.put(
      '/pengguna/transactions/$transactionId/reject',
      body: {},
    );

    if (response['success']) {
      return Transaction.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Gagal menolak transaksi');
    }
  }

  // Get my notifications
  Future<List<NotificationModel>> getMyNotifications() async {
    final response = await _apiService.get('/pengguna/notifications');

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

  // Mark notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    final response = await _apiService.put(
      '/pengguna/notifications/$notificationId/read',
      body: {},
    );

    if (!response['success']) {
      throw Exception(response['message'] ?? 'Gagal menandai notifikasi');
    }
  }
}
