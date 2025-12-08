import 'package:flutter/material.dart';
import '../../core/services/pengepul_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/user.dart';
import '../../core/models/box.dart';
import '../../auth/screens/login_screen.dart';
import 'transactions/create_transaction_screen.dart';
import 'transactions/my_transactions_screen.dart';

class PengepulDashboardScreen extends StatefulWidget {
  const PengepulDashboardScreen({super.key});

  @override
  State<PengepulDashboardScreen> createState() => _PengepulDashboardScreenState();
}

class _PengepulDashboardScreenState extends State<PengepulDashboardScreen> {
  final _pengepulService = PengepulService();
  final _authService = AuthService();
  
  User? _currentUser;
  Map<String, dynamic>? _dashboardData;
  List<Box>? _availableBoxes;
  bool _isLoading = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final user = await _authService.getCurrentUser();
      final dashboard = await _pengepulService.getDashboard();
      final boxes = await _pengepulService.getAvailableBoxes();
      
      setState(() {
        _currentUser = user;
        _dashboardData = dashboard;
        _availableBoxes = boxes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout gagal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengepul Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Profile Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.local_shipping, size: 30, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentUser?.name ?? 'Pengepul',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _currentUser?.email ?? '',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'PENGEPUL',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Balance & Earnings
                  if (_dashboardData != null) ...[
                    Card(
                      elevation: 4,
                      color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Saldo Saat Ini',
                                        style: TextStyle(color: Colors.white70, fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${(_dashboardData!['current_balance'] ?? 0).toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.account_balance_wallet, color: Colors.white, size: 40),
                              ],
                            ),
                            const Divider(color: Colors.white70, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildEarningsStat(
                                  'Total Earnings',
                                  _dashboardData!['total_earnings'],
                                ),
                                _buildEarningsStat(
                                  'Transaksi',
                                  _dashboardData!['total_transactions'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                  
                  // Tabs
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _selectedTab = 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedTab == 0 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey[300],
                            foregroundColor: _selectedTab == 0 ? Colors.white : Colors.black,
                          ),
                          child: const Text('Kotak Tersedia'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _selectedTab = 1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedTab == 1 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey[300],
                            foregroundColor: _selectedTab == 1 ? Colors.white : Colors.black,
                          ),
                          child: const Text('Transaksi Saya'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Content based on selected tab
                  if (_selectedTab == 0) _buildAvailableBoxes(),
                  if (_selectedTab == 1) _buildMyTransactions(),
                ],
              ),
            ),
    );
  }

  Widget _buildEarningsStat(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value is num ? (value is int ? value.toString() : 'Rp ${value.toStringAsFixed(0)}') : value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableBoxes() {
    if (_availableBoxes == null || _availableBoxes!.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Tidak ada kotak tersedia',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: _availableBoxes!.map((box) {
        final totalPrice = box.items?.fold<double>(0, (sum, item) {
          final price = item.category?.pricePerKg ?? 0;
          final weight = item.weight ?? 0;
          return sum + (price * weight);
        }) ?? 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.inventory_2, color: Colors.green),
            ),
            title: Text(
              'Box #${box.id} - ${box.items?.length ?? 0} items',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimasi: Rp ${totalPrice.toStringAsFixed(0)}'),
                if (box.user != null)
                  Text('Penjual: ${box.user!['name']}', 
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showBoxDetails(box, totalPrice);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMyTransactions() {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.green),
            title: const Text('Lihat Semua Transaksi'),
            subtitle: const Text('Riwayat transaksi lengkap'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyTransactionsScreen(),
                ),
              ).then((_) => _loadData());
            },
          ),
        ),
      ],
    );
  }

  void _showBoxDetails(Box box, double estimatedPrice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Box #${box.id}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              
              // Seller Info
              if (box.user != null) ...[
                const Text('Penjual:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Nama: ${box.user!['name']}'),
                Text('Email: ${box.user!['email']}'),
                if (box.user!['phone'] != null) Text('Phone: ${box.user!['phone']}'),
                if (box.user!['address'] != null) Text('Alamat: ${box.user!['address']}'),
                const SizedBox(height: 16),
              ],
              
              // Items List
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (box.items != null && box.items!.isNotEmpty)
                ...box.items!.map((item) {
                  final price = item.category?.pricePerKg ?? 0;
                  final weight = item.weight ?? 0;
                  final subtotal = price * weight;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('${weight}kg × Rp $price/kg'),
                      trailing: Text(
                        'Rp ${subtotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              
              const Divider(),
              
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimasi Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    'Rp ${estimatedPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Action Button
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTransactionScreen(box: box),
                    ),
                  );
                  if (result == true) {
                    _loadData(); // Refresh data if transaction was created
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Buat Penawaran',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
