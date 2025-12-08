import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_pti/core/api.dart';

class RemoteOrdersService {
  RemoteOrdersService._internal();
  static final RemoteOrdersService instance = RemoteOrdersService._internal();

  /// POST /api/orders  with JSON body of order. Expects created order JSON in response.
  Future<Map<String, dynamic>> postOrder(Map<String, dynamic> payload) async {
    final base = ApiConfig.baseUrl;
    if (base.isEmpty) throw Exception('API base URL not configured');
    final uri = Uri.parse(base).replace(path: '/api/orders');
    final resp = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
    if (resp.statusCode != 200 && resp.statusCode != 201) throw Exception('Post order failed (${resp.statusCode})');
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final base = ApiConfig.baseUrl;
    if (base.isEmpty) throw Exception('API base URL not configured');
    final uri = Uri.parse(base).replace(path: '/api/orders');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Fetch orders failed (${resp.statusCode})');
    final body = jsonDecode(resp.body);
    if (body is! List) return [];
    return body.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
