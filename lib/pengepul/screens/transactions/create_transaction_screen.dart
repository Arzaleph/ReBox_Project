import 'package:flutter/material.dart';
import '../../../core/services/pengepul_service.dart';
import '../../../core/models/box.dart';

class CreateTransactionScreen extends StatefulWidget {
  final Box box;

  const CreateTransactionScreen({super.key, required this.box});

  @override
  State<CreateTransactionScreen> createState() => _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _pengepulService = PengepulService();
  
  bool _isLoading = false;
  double _estimatedPrice = 0;

  @override
  void initState() {
    super.initState();
    _calculateEstimatedPrice();
  }

  void _calculateEstimatedPrice() {
    double total = 0;
    if (widget.box.items != null) {
      for (var item in widget.box.items!) {
        final price = item.category?.pricePerKg ?? 0;
        final weight = item.weight ?? 0;
        total += price * weight;
      }
    }
    setState(() {
      _estimatedPrice = total;
      _priceController.text = total.toStringAsFixed(0);
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _createTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    // Confirm dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Anda akan membuat penawaran:'),
            const SizedBox(height: 8),
            Text(
              'Rp ${double.parse(_priceController.text).toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            Text('Admin Fee (10%): Rp ${(double.parse(_priceController.text) * 0.1).toStringAsFixed(0)}'),
            Text('Earnings (90%): Rp ${(double.parse(_priceController.text) * 0.9).toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Buat Penawaran'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _pengepulService.createTransaction(
        boxId: widget.box.id,
        totalPrice: double.parse(_priceController.text),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Penawaran berhasil dibuat! Menunggu konfirmasi penjual.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Penawaran', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Box Info
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.inventory_2, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Box #${widget.box.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      if (widget.box.user != null) ...[
                        const Text('Penjual:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.box.user!['name']),
                        if (widget.box.user!['phone'] != null)
                          Text('📞 ${widget.box.user!['phone']}'),
                        const SizedBox(height: 8),
                      ],
                      const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      if (widget.box.items != null && widget.box.items!.isNotEmpty)
                        ...widget.box.items!.map((item) {
                          final price = item.category?.pricePerKg ?? 0;
                          final weight = item.weight ?? 0;
                          final subtotal = price * weight;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('• ${item.name}'),
                                ),
                                Text(
                                  '${weight}kg × Rp $price',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Rp ${subtotal.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Price Field
              const Text(
                'Penawaran Harga',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Total Harga Penawaran *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixText: 'Rp ',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset ke estimasi',
                    onPressed: () {
                      _priceController.text = _estimatedPrice.toStringAsFixed(0);
                    },
                  ),
                  helperText: 'Estimasi: Rp ${_estimatedPrice.toStringAsFixed(0)}',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Harga wajib diisi';
                  final price = double.tryParse(value!);
                  if (price == null) return 'Harus berupa angka';
                  if (price <= 0) return 'Harga harus lebih dari 0';
                  return null;
                },
                enabled: !_isLoading,
              ),

              const SizedBox(height: 16),

              // Calculation Info
              if (_priceController.text.isNotEmpty &&
                  double.tryParse(_priceController.text) != null)
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Harga:'),
                            Text(
                              'Rp ${double.parse(_priceController.text).toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Admin Fee (10%):'),
                            Text(
                              'Rp ${(double.parse(_priceController.text) * 0.1).toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Earnings Anda (90%):'),
                            Text(
                              'Rp ${(double.parse(_priceController.text) * 0.9).toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Tambahkan catatan untuk penjual...',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                enabled: !_isLoading,
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
                      : const Text(
                          'Buat Penawaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
