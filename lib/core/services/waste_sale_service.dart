import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/waste_sale.dart';

class WasteSaleService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get all waste sales
  Future<List<WasteSale>> getWasteSales({String? status}) async {
    try {
      final headers = await _getHeaders();
      var url = '${ApiConfig.baseUrl}/api/waste-sales';
      
      if (status != null && status.isNotEmpty) {
        url += '?status=$status';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final List<dynamic> salesData = data['data']['data'];
          return salesData.map((json) => WasteSale.fromJson(json)).toList();
        }
        throw Exception(data['message'] ?? 'Failed to load waste sales');
      } else {
        throw Exception('Failed to load waste sales');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create new waste sale
  Future<WasteSale> createWasteSale({
    required String wasteType,
    required double weight,
    required double pricePerKg,
    String? description,
    File? photo,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final url = '${ApiConfig.baseUrl}/api/waste-sales';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['waste_type'] = wasteType;
      request.fields['weight'] = weight.toString();
      request.fields['price_per_kg'] = pricePerKg.toString();
      if (description != null && description.isNotEmpty) {
        request.fields['description'] = description;
      }

      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photo.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          return WasteSale.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Failed to create waste sale');
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to create waste sale');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get single waste sale
  Future<WasteSale> getWasteSale(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/waste-sales/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return WasteSale.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Failed to load waste sale');
      } else {
        throw Exception('Failed to load waste sale');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete waste sale
  Future<void> deleteWasteSale(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/waste-sales/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to delete waste sale');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update status (admin only)
  Future<WasteSale> updateStatus({
    required int id,
    required String status,
    String? adminNotes,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/waste-sales/$id/status'),
        headers: headers,
        body: json.encode({
          'status': status,
          if (adminNotes != null) 'admin_notes': adminNotes,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return WasteSale.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'Failed to update status');
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to update status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get statistics (admin only)
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/waste-sales/statistics/summary'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        }
        throw Exception(data['message'] ?? 'Failed to load statistics');
      } else {
        throw Exception('Failed to load statistics');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
