import 'dart:async';

import 'package:project_pti/core/api.dart';
import 'package:project_pti/cari/remote_search_service.dart';

class SampahItem {
  final String id;
  final String name;
  final String category;
  final double pricePerKg;

  SampahItem({required this.id, required this.name, required this.category, required this.pricePerKg});
}

/// Simple local search service that simulates async fetching and filtering.
class SearchService {
  SearchService._internal();
  static final SearchService instance = SearchService._internal();

  // Mock dataset
  final List<SampahItem> _items = List.unmodifiable([
    SampahItem(id: '1', name: 'Plastik PET', category: 'Plastik', pricePerKg: 2000),
    SampahItem(id: '2', name: 'Kertas Bekas', category: 'Kertas', pricePerKg: 1500),
    SampahItem(id: '3', name: 'Besi', category: 'Logam', pricePerKg: 5000),
    SampahItem(id: '4', name: 'Karton', category: 'Kertas', pricePerKg: 1200),
    SampahItem(id: '5', name: 'HDPE', category: 'Plastik', pricePerKg: 2500),
    SampahItem(id: '6', name: 'Kaca Botol', category: 'Kaca', pricePerKg: 800),
  ]);

  /// Result wrapper for search: contains items and optional error message.
  Future<SearchResult> search(String query) async {
    // Attempt remote if configured
    if (ApiConfig.baseUrl.isNotEmpty) {
      try {
        final remote = await RemoteSearchService.instance.search(query);
        return SearchResult(items: remote, fromRemote: true);
      } catch (e) {
        // return error but still attempt local fallback
        final local = await _localSearch(query);
        return SearchResult(items: local, error: e.toString(), fromRemote: true);
      }
    }
    final local = await _localSearch(query);
    return SearchResult(items: local, fromRemote: false);
  }

  Future<List<SampahItem>> _localSearch(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _items.where((i) => i.name.toLowerCase().contains(q) || i.category.toLowerCase().contains(q)).toList();
  }

  /// Return suggestions (first few items) when query is empty.
  Future<List<SampahItem>> suggestions([int limit = 5]) async {
    if (ApiConfig.baseUrl.isNotEmpty) {
      try {
        return await RemoteSearchService.instance.suggestions(limit);
      } catch (_) {}
    }
    await Future.delayed(const Duration(milliseconds: 150));
    return _items.take(limit).toList();
  }
}

class SearchResult {
  final List<SampahItem> items;
  final String? error;
  final bool fromRemote;

  SearchResult({required this.items, this.error, this.fromRemote = false});
}
