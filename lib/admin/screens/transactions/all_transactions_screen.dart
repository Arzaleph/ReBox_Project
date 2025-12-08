import 'package:flutter/material.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/models/transaction.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  final _adminService = AdminService();
  List<Transaction> _transactions = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  String? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await _adminService.getAllTransactions();
      final stats = await _adminService.getTransactionStats();
      
      setState(() {
        _transactions = transactions;
        _stats = stats;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
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
              onRefresh: _loadData,
              child: Column(
                children: [
                  // Stats Card
                  if (_stats != null)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('Total', _stats!['total_transactions'].toString()),
                              _buildStatItem('Pending', _stats!['pending'].toString()),
                              _buildStatItem('Completed', _stats!['completed'].toString()),
                            ],
                          ),
                          const Divider(color: Colors.white70, height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                'Revenue',
                                'Rp ${(_stats!['total_revenue'] ?? 0).toStringAsFixed(0)}',
                              ),
                              _buildStatItem(
                                'Admin Fee',
                                'Rp ${(_stats!['total_admin_fee'] ?? 0).toStringAsFixed(0)}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

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
                                  'Tidak ada transaksi',
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
                                          if (transaction.pengepul != null) ...[
                                            const Text(
                                              'Pengepul:',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(transaction.pengepul!['name']),
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
                                              const Text('Admin Fee (10%):'),
                                              Text(
                                                'Rp ${transaction.adminFee.toStringAsFixed(0)}',
                                                style: const TextStyle(color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Pengepul Earnings:'),
                                              Text(
                                                'Rp ${transaction.pengepulEarnings.toStringAsFixed(0)}',
                                                style: const TextStyle(color: Colors.blue),
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
