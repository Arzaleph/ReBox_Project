import 'package:flutter/material.dart';

// Import halaman tujuan dari folder pesanan/
import 'package:project_pti/pesanan/screens/jual_sampah_screen.dart';

class InfoSaldoWidget extends StatelessWidget {
  final String namaPengguna;
  final double saldo;

  const InfoSaldoWidget({
    super.key,
    required this.namaPengguna,
    required this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    // Tampilan Saldo dan Tombol Jual
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bagian Saldo (TIDAK ADA PERUBAHAN)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $namaPengguna!',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                'Saldo Anda:',
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                'Rp ${saldo.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Tombol CTA (PERUBAHAN ADA DI FUNGSI onPressed)
          ElevatedButton.icon(
            onPressed: () {
              // --- LOGIKA NAVIGASI DITAMBAHKAN DI SINI ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JualSampahScreen(),
                ),
              );
              // ------------------------------------------
            },
            icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
            label: const Text(
              'JUAL SAMPAH',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}