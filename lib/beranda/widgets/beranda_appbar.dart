import 'package:flutter/material.dart';

import 'package:project_pti/notifikasi/screens/notifikasi_screen.dart';


class BerandaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BerandaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Recycle Box',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.primary,

      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotifikasiScreen(),
              ),
            );
          },
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}