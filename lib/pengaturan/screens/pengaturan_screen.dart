// Ignore analyzer warnings about using BuildContext across async gaps in this file.
// We guard uses with `mounted` checks and intentionally call UI APIs after awaits.
// If you prefer stricter patterns, we can refactor to avoid async gaps in callbacks.
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:project_pti/pengaturan/settings_service.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Aplikasi'),
      ),
      body: AnimatedBuilder(
        animation: SettingsService.instance,
        builder: (context, _) {
          final settings = SettingsService.instance;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Icon(Icons.settings, size: 56, color: Colors.purple),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Pengaturan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Theme toggle
              SwitchListTile.adaptive(
                title: const Text('Tema Gelap'),
                subtitle: const Text('Gunakan mode gelap untuk kenyamanan di kondisi redup'),
                value: settings.isDarkMode,
                onChanged: (v) async {
                  await settings.setDarkMode(v);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tema disimpan: ${v ? 'Gelap' : 'Terang'}')),
                  );
                },
                secondary: const Icon(Icons.brightness_6),
              ),

              // Notifications toggle
              SwitchListTile.adaptive(
                title: const Text('Notifikasi'),
                subtitle: const Text('Terima pemberitahuan dan update'),
                value: settings.notificationsEnabled,
                onChanged: (v) async {
                  await settings.setNotificationsEnabled(v);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preferensi notifikasi disimpan')),
                  );
                },
                secondary: const Icon(Icons.notifications),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Bersihkan Cache'),
                subtitle: const Text('Hapus data cache sementara aplikasi'),
                onTap: () async {
                  await SettingsService.instance.clearCache();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache aplikasi dibersihkan')),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                subtitle: const Text('Keluar dari akun Anda'),
                onTap: () async {
                  await SettingsService.instance.logout();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anda telah logout')),
                  );
                  // Navigasi kembali ke halaman awal (bersihkan stack sampai root)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Versi Aplikasi'),
                subtitle: const Text('1.0.0'),
              ),
            ],
          );
        },
      ),
    );
  }
}