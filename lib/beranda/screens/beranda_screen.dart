import 'package:flutter/material.dart';

// Import Custom Widgets dari folder widgets/ yang akan kita buat
import 'package:project_pti/beranda/widgets/beranda_appbar.dart';
import 'package:project_pti/beranda/widgets/info_saldo_widget.dart';
import 'package:project_pti/beranda/widgets/kategori_sampah_list.dart';
import 'package:project_pti/beranda/widgets/daftar_harga_terbaru.dart';

// Catatan: Jika menggunakan State Management (Bloc/Cubit/Controller),
// Anda akan membungkus widget ini dengan Provider/BlocBuilder.
// Untuk contoh ini, kita asumsikan stateless dan menggunakan data dummy.

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. App Bar Kustom (berisi Notifikasi & Lokasi)
      appBar: const BerandaAppBar(),

      // 2. Konten Utama Halaman
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Widget Saldo & Tombol Utama (CTA) "Jual Sampah"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: InfoSaldoWidget(
                namaPengguna: 'Arza Restu Arjuna',
                saldo: 145.000,
              ),
            ),

            const SizedBox(height: 20),

            // Judul Bagian Kategori
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Jual / Beli Sampah Apa Hari Ini?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Widget Daftar Kategori Horizontal
            const KategoriSampahList(),

            const SizedBox(height: 30),

            // Judul Bagian Harga/Listing Terbaru
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Harga Beli Terbaru (Per Kg)',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Widget Daftar Harga/Item Terbaru (List vertikal)
            const DaftarHargaTerbaru(),
          ],
        ),
      ),

      // 3. Navigasi Bawah (Opsional, tapi umum di aplikasi modern)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Logika navigasi ke fitur-fitur lain (Cari, Pesanan, Notifikasi, Profil)
        },
      ),
    );
  }
}