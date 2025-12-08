import 'package:flutter/material.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/models/user.dart';

class PengepulPaymentsScreen extends StatefulWidget {
  const PengepulPaymentsScreen({super.key});

  @override
  State<PengepulPaymentsScreen> createState() => _PengepulPaymentsScreenState();
}

class _PengepulPaymentsScreenState extends State<PengepulPaymentsScreen> {
  final _adminService = AdminService();
  List<User> _pengepuls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPengepuls();
  }

  Future<void> _loadPengepuls() async {
    setState(() => _isLoading = true);
    try {
      final pengepuls = await _adminService.getPengepulPayments();
      setState(() {
        _pengepuls = pengepuls;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _processPayment(User pengepul) async {
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Proses Pembayaran\n${pengepul.name}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Saldo: Rp ${(pengepul.balance ?? 0).toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Pembayaran *',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Wajib diisi';
                  final amount = double.tryParse(value!);
                  if (amount == null) return 'Harus berupa angka';
                  if (amount <= 0) return 'Harus lebih dari 0';
                  if (amount > (pengepul.balance ?? 0)) {
                    return 'Melebihi saldo tersedia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Proses'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await _adminService.processPayment(
          pengepulId: pengepul.id,
          amount: double.parse(amountController.text),
          notes: notesController.text.isEmpty ? null : notesController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pembayaran berhasil diproses'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadPengepuls();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Pengepul', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPengepuls,
              child: _pengepuls.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada data pengepul',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _pengepuls.length,
                      itemBuilder: (context, index) {
                        final pengepul = _pengepuls[index];
                        final balance = pengepul.balance ?? 0;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(
                                pengepul.name[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              pengepul.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pengepul.email),
                                const SizedBox(height: 4),
                                Text(
                                  'Saldo: Rp ${balance.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: balance > 0 ? Colors.green : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: balance > 0
                                ? ElevatedButton(
                                    onPressed: () => _processPayment(pengepul),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text(
                                      'Bayar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'No Balance',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
