import 'package:flutter/material.dart';
import 'package:project_pti/pesanan/order_service.dart';
import 'package:project_pti/pesanan/widgets/order_item.dart';

class PesananScreen extends StatefulWidget {
  const PesananScreen({super.key});

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initOrders();
  }

  Future<void> _initOrders() async {
    await OrderService.instance.init();
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _showAddDialog() async {
    final itemCtrl = TextEditingController();
    final weightCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Buat Pesanan Baru'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: itemCtrl,
                decoration: const InputDecoration(labelText: 'Nama Item'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama diperlukan' : null,
              ),
              TextFormField(
                controller: weightCtrl,
                decoration: const InputDecoration(labelText: 'Berat (kg)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v == null || double.tryParse(v) == null) ? 'Masukkan angka valid' : null,
              ),
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Harga per Kg (Rp)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v == null || double.tryParse(v) == null) ? 'Masukkan angka valid' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) Navigator.of(c).pop(true);
            },
            child: const Text('Buat'),
          ),
        ],
      ),
    );

    if (saved == true) {
      final name = itemCtrl.text.trim();
      final weight = double.parse(weightCtrl.text.trim());
      final price = double.parse(priceCtrl.text.trim());
      await OrderService.instance.addOrder(itemName: name, weightKg: weight, pricePerKg: price);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan dibuat')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sinkron semua',
            onPressed: () async {
              final snack = ScaffoldMessenger.of(context);
              final synced = await OrderService.instance.syncPending();
              snack.showSnackBar(SnackBar(content: Text('Sinkron selesai: $synced pesanan')));
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedBuilder(
              animation: OrderService.instance,
              builder: (context, _) {
                final orders = OrderService.instance.orders;
                if (orders.isEmpty) {
                  return const Center(child: Text('Belum ada pesanan'));
                }
                return ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final o = orders[index];
                    return Dismissible(
                      key: Key(o.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) async {
                        await OrderService.instance.remove(o.id);
                      },
                      child: OrderItemWidget(
                        order: o,
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: Text(o.itemName),
                              content: Text('Berat: ${o.weightKg} kg\nHarga/kg: Rp ${o.pricePerKg.toStringAsFixed(0)}\nTotal: Rp ${o.total.toStringAsFixed(0)}'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('Tutup')),
                              ],
                            ),
                          );
                        },
                        onDelete: () async {
                          await OrderService.instance.remove(o.id);
                        },
                        onToggleComplete: () async {
                          await OrderService.instance.markCompleted(o.id, completed: !o.completed);
                        },
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Buat pesanan baru',
        child: const Icon(Icons.add),
      ),
    );
  }
}