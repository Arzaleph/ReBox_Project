import 'package:flutter/material.dart';
import '../services/box_service.dart';
import '../models/box.dart';
import '../services/api_service.dart';

class BoxListExample extends StatefulWidget {
  const BoxListExample({super.key});

  @override
  State<BoxListExample> createState() => _BoxListExampleState();
}

class _BoxListExampleState extends State<BoxListExample> {
  final _boxService = BoxService();
  List<Box> _boxes = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBoxes();
  }

  Future<void> _loadBoxes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final boxes = await _boxService.getAllBoxes();
      setState(() {
        _boxes = boxes;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBox(int id) async {
    try {
      await _boxService.deleteBox(id);
      _loadBoxes(); // Reload list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Box berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Box'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBoxes,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create box screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBoxes,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_boxes.isEmpty) {
      return const Center(child: Text('Tidak ada box'));
    }

    return RefreshIndicator(
      onRefresh: _loadBoxes,
      child: ListView.builder(
        itemCount: _boxes.length,
        itemBuilder: (context, index) {
          final box = _boxes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(box.name),
              subtitle: box.description != null
                  ? Text(box.description!)
                  : null,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: Text('Hapus box "${box.name}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteBox(box.id);
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
