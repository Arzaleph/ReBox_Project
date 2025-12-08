import 'package:flutter/material.dart';

// Data dummy untuk daftar harga
final List<Map<String, dynamic>> dummyHarga = [
  {'jenis': 'Kertas HVS', 'harga': 3000, 'unit': 'Kg'},
  {'jenis': 'Botol PET', 'harga': 4000, 'unit': 'Kg'},
  {'jenis': 'Aluminium Kaleng', 'harga': 12000, 'unit': 'Kg'},
  {'jenis': 'Besi Tua', 'harga': 3000, 'unit': 'Kg'},
];

class DaftarHargaTerbaru extends StatelessWidget {
  const DaftarHargaTerbaru({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(), // Agar bisa discroll dengan SingleChildScrollView parent
      shrinkWrap: true,
      itemCount: dummyHarga.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = dummyHarga[index];
        return ListTile(
          leading: const Icon(Icons.price_change, color: Colors.green),
          title: Text(item['jenis'], style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(
            'Rp ${item['harga'].toString()}/${item['unit']}',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          onTap: () {
            // Aksi ketika item harga diklik
          },
        );
      },
    );
  }
}