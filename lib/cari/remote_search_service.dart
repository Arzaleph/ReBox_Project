import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_pti/core/api.dart';
import 'package:project_pti/cari/search_service.dart';

class RemoteSearchService {
  RemoteSearchService._internal();
  static final RemoteSearchService instance = RemoteSearchService._internal();

  /// Calls backend GET /api/search?q=... and expects JSON array of items:
  /// [{"id":"1","name":"Plastik PET","category":"Plastik","pricePerKg":2000}, ...]
  Future<List<SampahItem>> search(String query) async {
    final base = ApiConfig.baseUrl;
    if (base.isEmpty) return [];
    final uri = Uri.parse(base).replace(path: '/api/search', queryParameters: {'q': query});
    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Remote search failed: ${resp.statusCode}');
    }
    final body = jsonDecode(resp.body);
    if (body is! List) return [];
    return body.map<SampahItem>((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return SampahItem(
        id: m['id'].toString(),
        name: m['name']?.toString() ?? '',
        category: m['category']?.toString() ?? '',
        pricePerKg: (m['pricePerKg'] is num) ? (m['pricePerKg'] as num).toDouble() : double.tryParse(m['pricePerKg']?.toString() ?? '') ?? 0,
      );
    }).toList();
  }

  Future<List<SampahItem>> suggestions([int limit = 5]) async {
    final base = ApiConfig.baseUrl;
    if (base.isEmpty) return [];
    final uri = Uri.parse(base).replace(path: '/api/search/suggestions', queryParameters: {'limit': limit.toString()});
    final resp = await http.get(uri);
    if (resp.statusCode != 200) return [];
    final body = jsonDecode(resp.body);
    if (body is! List) return [];
    return body.map<SampahItem>((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return SampahItem(
        id: m['id'].toString(),
        name: m['name']?.toString() ?? '',
        category: m['category']?.toString() ?? '',
        pricePerKg: (m['pricePerKg'] is num) ? (m['pricePerKg'] as num).toDouble() : double.tryParse(m['pricePerKg']?.toString() ?? '') ?? 0,
      );
    }).toList();
  }
}
