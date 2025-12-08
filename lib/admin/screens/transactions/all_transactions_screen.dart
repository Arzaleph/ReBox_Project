import 'package:flutter/material.dart';
import '../../../core/services/admin_service.dart';
import '../../../core/models/transaction.dart';
import 'package:intl/intl.dart';

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
  String _searchQuery = '';
  final _dateFormat = DateFormat('dd MMM yyyy, HH:mm');
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  int _currentPage = 1;
  int? _totalPages;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoadingMore && _currentPage < (_totalPages ?? 1)) {
        _loadMoreTransactions();
      }
    }
  }
  
  Future<void> _loadMoreTransactions() async {
    if (_isLoadingMore) return;
    
    setState(() => _isLoadingMore = true);
    try {
      final nextPage = _currentPage + 1;
      final response = await _adminService.getAllTransactions(page: nextPage);
      final List<Transaction> newTransactions = response['transactions'];
      
      setState(() {
        _transactions.addAll(newTransactions);
        _currentPage = response['current_page'];
        _totalPages = response['last_page'];
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _transactions.clear();
    });
    
    try {
      final response = await _adminService.getAllTransactions(page: 1);
      final stats = await _adminService.getTransactionStats();
      
      final List<Transaction> transactions = response['transactions'];
      
      setState(() {
        _transactions = transactions;
        _currentPage = response['current_page'];
        _totalPages = response['last_page'];
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
    var filtered = _transactions;
    
    // Apply status filter
    if (_filterStatus != null) {
      filtered = filtered.where((t) => t.status == _filterStatus).toList();
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        final id = t.id.toString();
        final pengguna = t.pengguna?['name']?.toString().toLowerCase() ?? '';
        final pengepul = t.pengepul?['name']?.toString().toLowerCase() ?? '';
        final price = t.totalPrice.toString();
        
        return id.contains(query) || 
               pengguna.contains(query) || 
               pengepul.contains(query) ||
               price.contains(query);
      }).toList();
    }
    
    return filtered;
  }
  
  String _formatCurrency(dynamic value) {
    if (value == null) return 'Rp 0';
    if (value is num) return 'Rp ${value.toStringAsFixed(0)}';
    if (value is String) {
      final parsed = double.tryParse(value);
      return 'Rp ${parsed?.toStringAsFixed(0) ?? '0'}';
    }
    return 'Rp 0';
  }
  
  Future<void> _exportTransactions() async {
    try {
      final csvData = StringBuffer();
      csvData.writeln('ID,Status,Penjual,Pengepul,Total Harga,Admin Fee,Pengepul Earnings,Tanggal Dibuat,Tanggal Diterima,Tanggal Selesai');
      
      for (final transaction in _filteredTransactions) {
        csvData.writeln([
          transaction.id,
          transaction.status,
          transaction.pengguna?['name'] ?? '-',
          transaction.pengepul?['name'] ?? '-',
          transaction.totalPrice.toStringAsFixed(0),
          transaction.adminFee.toStringAsFixed(0),
          transaction.pengepulEarnings.toStringAsFixed(0),
          _dateFormat.format(transaction.createdAt),
          transaction.acceptedAt != null ? _dateFormat.format(transaction.acceptedAt!) : '-',
          transaction.completedAt != null ? _dateFormat.format(transaction.completedAt!) : '-',
        ].join(','));
      }
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Data'),
            content: SingleChildScrollView(
              child: SelectableText(
                csvData.toString(),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error export: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  
  Widget _buildTimelineItem(String label, DateTime dateTime, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _dateFormat.format(dateTime),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
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
          // Export button
          IconButton(
            icon: const Icon(Icons.file_download, color: Colors.white),
            tooltip: 'Export Data',
            onPressed: _exportTransactions,
          ),
          // Filter menu
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
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari transaksi (ID, nama, harga)...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                  ),
                  
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
                                _formatCurrency(_stats!['total_revenue']),
                              ),
                              _buildStatItem(
                                'Admin Fee',
                                _formatCurrency(_stats!['total_admin_fee']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // Filter Info
                  if (_filterStatus != null || _searchQuery.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (_filterStatus != null)
                            Chip(
                              label: Text('Status: ${_filterStatus!.toUpperCase()}'),
                              onDeleted: () => setState(() => _filterStatus = null),
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                          if (_searchQuery.isNotEmpty)
                            Chip(
                              label: Text('Cari: "$_searchQuery"'),
                              onDeleted: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                          Text(
                            '${_filteredTransactions.length} hasil',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
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
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredTransactions.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              // Loading indicator for pagination
                              if (index == _filteredTransactions.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              
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
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
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
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _dateFormat.format(transaction.createdAt),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${transaction.totalPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green,
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
                                          // Penjual Info
                                          if (transaction.pengguna != null) ...[
                                            Row(
                                              children: [
                                                const Icon(Icons.person, size: 16, color: Colors.blue),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Penjual',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 24),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    transaction.pengguna!['name'],
                                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    transaction.pengguna!['email'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  if (transaction.pengguna!['phone'] != null)
                                                    Text(
                                                      '📞 ${transaction.pengguna!['phone']}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                          
                                          // Pengepul Info
                                          if (transaction.pengepul != null) ...[
                                            Row(
                                              children: [
                                                const Icon(Icons.local_shipping, size: 16, color: Colors.green),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Pengepul',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 24),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    transaction.pengepul!['name'],
                                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    transaction.pengepul!['email'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  if (transaction.pengepul!['phone'] != null)
                                                    Text(
                                                      '📞 ${transaction.pengepul!['phone']}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                          
                                          const Divider(),
                                          
                                          // Price Breakdown
                                          const Text(
                                            'Rincian Harga',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text('Total Harga:'),
                                                    Text(
                                                      'Rp ${transaction.totalPrice.toStringAsFixed(0)}',
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(height: 16),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Admin Fee (10%):',
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                    Text(
                                                      'Rp ${transaction.adminFee.toStringAsFixed(0)}',
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Pengepul Earnings (90%):',
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                    Text(
                                                      'Rp ${transaction.pengepulEarnings.toStringAsFixed(0)}',
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // Timestamps
                                          if (transaction.acceptedAt != null || transaction.completedAt != null) ...[
                                            const SizedBox(height: 12),
                                            const Divider(),
                                            const Text(
                                              'Timeline',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            _buildTimelineItem(
                                              'Dibuat',
                                              transaction.createdAt,
                                              Icons.add_circle_outline,
                                              Colors.blue,
                                            ),
                                            if (transaction.acceptedAt != null)
                                              _buildTimelineItem(
                                                'Diterima',
                                                transaction.acceptedAt!,
                                                Icons.check_circle_outline,
                                                Colors.green,
                                              ),
                                            if (transaction.completedAt != null)
                                              _buildTimelineItem(
                                                'Selesai',
                                                transaction.completedAt!,
                                                Icons.done_all,
                                                Colors.purple,
                                              ),
                                          ],
                                          
                                          // Notes
                                          if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            const Divider(),
                                            const Row(
                                              children: [
                                                Icon(Icons.note, size: 16),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Catatan',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.amber[50],
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.amber[200]!),
                                              ),
                                              child: Text(
                                                transaction.notes!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
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
