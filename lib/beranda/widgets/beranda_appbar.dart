import 'package:flutter/material.dart';

class BerandaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BerandaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Jual Beli Sampah'),
      automaticallyImplyLeading: false, // Menghilangkan tombol back default
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            // TODO: Navigasi ke fitur notifikasi
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}