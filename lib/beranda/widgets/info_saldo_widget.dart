import 'package:flutter/material.dart';

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
    // Tampilan Saldo
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
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
    );
  }
}