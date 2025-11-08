import 'package:flutter/material.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold ini akan muncul sebagai halaman baru (route baru)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Aplikasi'),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 50, color: Colors.purple),
            SizedBox(height: 10),
            Text(
              'Halaman Pengaturan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Di sini akan ada opsi Akun, Notifikasi, Privasi, dll.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}