import 'package:flutter/material.dart';

// Import Widgets dari folder beranda/
import 'package:project_pti/beranda/widgets/beranda_appbar.dart';
import 'package:project_pti/beranda/widgets/info_saldo_widget.dart';
import 'package:project_pti/beranda/widgets/kategori_sampah_list.dart';
import 'package:project_pti/beranda/widgets/daftar_harga_terbaru.dart';

// Import Screens dari fitur lain
import 'package:project_pti/cari/screens/cari_screen.dart';
import 'package:project_pti/notifikasi/screens/notifikasi_screen.dart';
import 'package:project_pti/pesanan/screens/pesanan_screen.dart';
import 'package:project_pti/profil/screens/profil_screen.dart';
// --- TAMBAH IMPORT PENGATURAN ---
import 'package:project_pti/pengaturan/screens/pengaturan_screen.dart';
import 'package:project_pti/notifikasi/notifications_service.dart';
import 'package:project_pti/pesanan/screens/waste_sale_list_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 1. Daftar halaman yang akan ditampilkan di Bottom Bar
  static final List<Widget> _widgetOptions = <Widget>[
    const BerandaContent(),
    const CariScreen(),
    const PesananScreen(),
    const NotifikasiScreen(),
    const ProfilScreen(),
  ];

  // 2. Daftar judul untuk App Bar (kecuali Beranda)
  static const List<String> _pageTitles = <String>[
    'Beranda',
    'Pencarian',
    'Riwayat Pesanan',
    'Pemberitahuan',
    'Profil Saya',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // --- LOGIKA KONDISIONAL UNTUK ACTIONS (TOMBOL KANAN ATAS) ---
    List<Widget> appBarActions = [];

    // Jika Tab Profil (Index 4) aktif, tambahkan tombol Pengaturan
    if (_selectedIndex == 4) {
      appBarActions = [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white), // Ikon Pengaturan
          onPressed: () {
            // Navigasi ke halaman Pengaturan
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PengaturanScreen(),
              ),
            );
          },
        ),
      ];
    }
    // -------------------------------------------------------------------------

    return Scaffold(
      // AppBar berubah sesuai tab
      appBar: _selectedIndex == 0
          ? const BerandaAppBar() // Tab Beranda: Gunakan AppBar Kustom
          : AppBar( // Tab Lain: Gunakan AppBar Standar
        title: Text(
          _pageTitles[_selectedIndex],
          style: const TextStyle(color: Colors.white), // Set warna teks putih agar kontras
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        // PASANG ACTIONS KONDISIONAL
        actions: appBarActions,
      ),

      // Tampilkan konten halaman yang sesuai dengan _selectedIndex
      body: _widgetOptions.elementAt(_selectedIndex),

      // Bottom Navigation Bar with badge for unread notifications
      bottomNavigationBar: AnimatedBuilder(
        animation: NotificationsService.instance,
        builder: (context, _) {
          final unread = NotificationsService.instance.notifications.where((n) => !n.read).length;
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
              const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications),
                    if (unread > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Center(
                            child: Text(
                              unread > 99 ? '99+' : unread.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Notifikasi',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped, // Logika perpindahan tab
          );
        },
      ),
    );
  }
}


// --- KONTEN HALAMAN BERANDA ASLI (DIJADIKAN ISI TAB 0) ---
// (Tidak ada perubahan di sini kecuali nama pengguna)
class BerandaContent extends StatelessWidget {
  const BerandaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InfoSaldoWidget(
              namaPengguna: 'Arza Restu Arjuna',
              saldo: 145000,
            ),
          ),

          const SizedBox(height: 20),

          // TOMBOL JUAL SAMPAH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4,
              color: Colors.green,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WasteSaleListScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.recycling,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jual Sampah',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tukar sampah jadi uang',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Jual / Beli Sampah Apa Hari Ini?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          const KategoriSampahList(),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Harga Beli Terbaru (Per Kg)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          const DaftarHargaTerbaru(),
        ],
      ),
    );
  }
}