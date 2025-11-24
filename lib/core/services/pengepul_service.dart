import 'api_service.dart';
import '../models/box.dart';
import '../models/transaction.dart';

class PengepulService {
  final ApiService _apiService = ApiService();

  // Get dashboard stats
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiService.get('/pengepul/dashboard');

    if (response['success']) {
      return response['data'];
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat dashboard');
    }
  }

  // Get available boxes (no active transaction)
  Future<List<Box>> getAvailableBoxes() async {
    final response = await _apiService.get('/pengepul/boxes/available');

    if (response['success']) {
      final data = response['data'];
      final List boxesJson = data['data'] ?? data;
      return boxesJson.map((json) => Box.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat kotak');
    }
  }

  // Get box details
  Future<Box> getBoxDetails(int boxId) async {
    final response = await _apiService.get('/pengepul/boxes/$boxId');

    if (response['success']) {
      return Box.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat detail kotak');
    }
  }

  // Create transaction (make offer)
  Future<Transaction> createTransaction({
    required int boxId,
    required double totalPrice,
    String? notes,
  }) async {
    final response = await _apiService.post('/pengepul/transactions', body: {
      'box_id': boxId,
      'total_price': totalPrice,
      'notes': notes,
    });

    if (response['success']) {
      return Transaction.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Gagal membuat transaksi');
    }
  }

  // Get my transactions (as pengepul/collector)
  Future<List<Transaction>> getMyTransactions() async {
    final response = await _apiService.get('/pengepul/transactions');

    if (response['success']) {
      final data = response['data'];
      final List transactionsJson = data['data'] ?? data;
      return transactionsJson.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat transaksi');
    }
  }

  // Update transaction status (complete/cancel)
  Future<Transaction> updateTransactionStatus({
    required int transactionId,
    required String status, // completed or cancelled
    String? notes,
  }) async {
    final response = await _apiService.put(
      '/pengepul/transactions/$transactionId/status',
      body: {
        'status': status,
        'notes': notes,
      },
    );

    if (response['success']) {
      return Transaction.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Gagal update status transaksi');
    }
  }
}
