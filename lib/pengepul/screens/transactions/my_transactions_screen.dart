import 'package:flutter/material.dart';
import '../../../core/services/pengepul_service.dart';
import '../../../core/models/transaction.dart';

class MyTransactionsScreen extends StatefulWidget {
  const MyTransactionsScreen({super.key});

  @override
  State<MyTransactionsScreen> createState() => _MyTransactionsScreenState();
}

class _MyTransactionsScreenState extends State<MyTransactionsScreen> {
  final _pengepulService = PengepulService();
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await _pengepulService.getMyTransactions();
      setState(() {
        _transactions = transactions;
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

  List<Transaction> get _filteredTransactions {
    if (_filterStatus == null) return _transactions;
    return _transactions.where((t) => t.status == _filterStatus).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateStatus(Transaction transaction, String status) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${status == 'completed' ? 'Selesaikan' : 'Batalkan'} Transaksi'),
        content: Text(
          'Yakin ingin ${status == 'completed' ? 'menyelesaikan' : 'membatalkan'} transaksi #${transaction.id}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'completed' ? Colors.green : Colors.red,
            ),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _pengepulService.updateTransactionStatus(
          transactionId: transaction.id,
          status: status,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transaksi berhasil di-${status == 'completed' ? 'selesaikan' : 'batalkan'}'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadTransactions();
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
        title: const Text('Transaksi Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              setState(() {
                _filterStatus = value == 'all' ? null : value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Semua')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'accepted', child: Text('Accepted')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
              const PopupMenuItem(value: 'rejected', child: Text('Rejected')),
              const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTransactions,
              child: Column(
                children: [
                  // Filter Info
                  if (_filterStatus != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Chip(
                            label: Text('Filter: ${_filterStatus!.toUpperCase()}'),
                            onDeleted: () => setState(() => _filterStatus = null),
                          ),
                        ],
                      ),
                    ),

                  // Transactions List
                  Expanded(
                    child: _filteredTransactions.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'Belum ada transaksi',
                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction = _filteredTransactions[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ExpansionTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(transaction.status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.receipt,
                                      color: _getStatusColor(transaction.status),
                                    ),
                                  ),
                                  title: Text(
                                    'Transaksi #${transaction.id}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Rp ${transaction.totalPrice.toStringAsFixed(0)}'),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(transaction.status),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          transaction.statusText,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (transaction.pengguna != null) ...[
                                            const Text(
                                              'Penjual:',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(transaction.pengguna!['name']),
                                            const SizedBox(height: 8),
                                          ],
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Total:'),
                                              Text(
                                                'Rp ${transaction.totalPrice.toStringAsFixed(0)}',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Admin Fee:'),
                                              Text(
                                                'Rp ${transaction.adminFee.toStringAsFixed(0)}',
                                                style: const TextStyle(color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Earnings Anda:'),
                                              Text(
                                                'Rp ${transaction.pengepulEarnings.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (transaction.notes != null) ...[
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Catatan:',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(transaction.notes!),
                                          ],
                                          
                                          // Action Buttons
                                          if (transaction.status == 'accepted') ...[
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    onPressed: () => _updateStatus(transaction, 'completed'),
                                                    icon: const Icon(Icons.check),
                                                    label: const Text('Selesaikan'),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.green,
                                                      foregroundColor: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    onPressed: () => _updateStatus(transaction, 'cancelled'),
                                                    icon: const Icon(Icons.close),
                                                    label: const Text('Batalkan'),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.red,
                                                      foregroundColor: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
