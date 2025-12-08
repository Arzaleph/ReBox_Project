import 'package:flutter/material.dart';
import '../../../core/services/admin_service.dart';

class BroadcastNotificationScreen extends StatefulWidget {
  const BroadcastNotificationScreen({super.key});

  @override
  State<BroadcastNotificationScreen> createState() => _BroadcastNotificationScreenState();
}

class _BroadcastNotificationScreenState extends State<BroadcastNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _adminService = AdminService();
  
  String _selectedType = 'info';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _adminService.createNotification(
        title: _titleController.text,
        message: _messageController.text,
        type: _selectedType,
        userId: null, // null = broadcast to all users
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifikasi berhasil dikirim ke semua user'),
            backgroundColor: Colors.green,
          ),
        );
        _titleController.clear();
        _messageController.clear();
        setState(() => _selectedType = 'info');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Notifikasi akan dikirim ke semua pengguna (Pengguna, Pengepul, dan Admin)',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Type Selection
              const Text(
                'Tipe Notifikasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              
              Wrap(
                spacing: 8,
                children: ['info', 'success', 'warning', 'error'].map((type) {
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getTypeIcon(type), size: 16, color: _selectedType == type ? Colors.white : _getTypeColor(type)),
                        const SizedBox(width: 4),
                        Text(type.toUpperCase()),
                      ],
                    ),
                    selected: _selectedType == type,
                    selectedColor: _getTypeColor(type),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedType = type);
                      }
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Notifikasi *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Judul wajib diisi' : null,
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: 16),
              
              // Message Field
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Pesan Notifikasi *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.message),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Pesan wajib diisi' : null,
                enabled: !_isLoading,
              ),
              
              const SizedBox(height: 24),
              
              // Preview
              const Text(
                'Preview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              
              Card(
                elevation: 4,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(_selectedType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(_selectedType),
                      color: _getTypeColor(_selectedType),
                    ),
                  ),
                  title: Text(
                    _titleController.text.isEmpty
                        ? 'Judul Notifikasi'
                        : _titleController.text,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _messageController.text.isEmpty
                        ? 'Pesan notifikasi akan ditampilkan di sini'
                        : _messageController.text,
                  ),
                  trailing: Text(
                    'Sekarang',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Send Button
              ElevatedButton(
                onPressed: _isLoading ? null : _sendNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getTypeColor(_selectedType),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Kirim ke Semua User',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
