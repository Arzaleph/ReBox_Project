import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_pti/cari/search_service.dart';
import 'package:project_pti/cari/widgets/search_result_item.dart';

class CariScreen extends StatefulWidget {
  const CariScreen({super.key});

  @override
  State<CariScreen> createState() => _CariScreenState();
}

class _CariScreenState extends State<CariScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<SampahItem> _results = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // show suggestions initially
    _loadSuggestions();
  }

  void _onQueryChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final q = _controller.text;
      if (q.trim().isEmpty) {
        _loadSuggestions();
        return;
      }
      setState(() => _isLoading = true);
      final result = await SearchService.instance.search(q);
      if (!mounted) return;
      setState(() {
        _results = result.items;
        _errorMessage = result.error;
        _isLoading = false;
      });
    });
  }

  Future<void> _loadSuggestions() async {
    setState(() => _isLoading = true);
    final list = await SearchService.instance.suggestions();
    if (!mounted) return;
    setState(() {
      _results = list;
      _errorMessage = null;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Sampah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              onChanged: (_) => _onQueryChanged(),
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan nama atau kategori (mis. plastik, kertas)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _onQueryChanged();
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),

          if (_isLoading) const LinearProgressIndicator(minHeight: 2),

          // Error banner
          if (_errorMessage != null)
            MaterialBanner(
              content: Text('Terjadi kesalahan saat mencari: $_errorMessage'),
              backgroundColor: Colors.red.shade100,
              actions: [
                TextButton(
                  onPressed: () {
                    // retry
                    if (_controller.text.trim().isEmpty) {
                      _loadSuggestions();
                    } else {
                      _onQueryChanged();
                    }
                  },
                  child: const Text('Coba lagi'),
                ),
                TextButton(onPressed: () => setState(() => _errorMessage = null), child: const Text('Tutup')),
              ],
            ),

          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(_isLoading ? 'Mencari...' : 'Tidak ada hasil. Coba kata kunci lain.'),
                  )
                : ListView.separated(
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _results[index];
                      return SearchResultItem(
                        item: item,
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: Text(item.name),
                              content: Text('Kategori: ${item.category}\nHarga: Rp ${item.pricePerKg.toStringAsFixed(0)}/kg'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('Tutup')),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}