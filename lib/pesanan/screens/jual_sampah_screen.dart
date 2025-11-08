import 'package:flutter/material.dart';

class JualSampahScreen extends StatelessWidget {
  const JualSampahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Penjualan Sampah'),
        backgroundColor: Colors.green, // Tema warna hijau
      ),
      body: const Center(
        child: Text(
          'Di sini akan ada form untuk memilih jenis sampah, berat, dan lokasi penjemputan.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}