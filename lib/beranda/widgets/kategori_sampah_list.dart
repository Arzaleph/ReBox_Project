import 'package:flutter/material.dart';

// Model Sederhana (Biasanya di folder models/)
class KategoriModel {
  final String nama;
  final IconData icon;
  final Color color;
  KategoriModel(this.nama, this.icon, this.color);
}

final List<KategoriModel> dummyKategori = [
  KategoriModel('Kertas', Icons.description, Colors.blue),
  KategoriModel('Plastik', Icons.local_drink, Colors.green),
  KategoriModel('Logam', Icons.precision_manufacturing, Colors.grey),
  KategoriModel('Kaca', Icons.wine_bar, Colors.lightBlueAccent),
  KategoriModel('Lainnya', Icons.more_horiz, Colors.orange),
];

class KategoriSampahList extends StatelessWidget {
  const KategoriSampahList({super.key});

  @override
  Widget build(BuildContext context) {
    // Tampilan list horizontal kategori
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dummyKategori.length,
        itemBuilder: (context, index) {
          final kategori = dummyKategori[index];
          return Container(
            margin: EdgeInsets.only(left: 16.0, right: index == dummyKategori.length - 1 ? 16.0 : 0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  // ignore: deprecated_member_use
                  backgroundColor: kategori.color.withOpacity(0.2),
                  child: Icon(kategori.icon, color: kategori.color, size: 30),
                ),
                const SizedBox(height: 8),
                Text(kategori.nama, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}