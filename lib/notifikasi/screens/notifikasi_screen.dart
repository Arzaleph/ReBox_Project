// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:project_pti/notifikasi/notifications_service.dart';
import 'package:project_pti/pengaturan/settings_service.dart';
import 'package:project_pti/notifikasi/widgets/notification_item.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  @override
  void initState() {
    super.initState();
    // ensure service initialized (it may already be)
    NotificationsService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemberitahuan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Bersihkan semua',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Hapus semua notifikasi?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Batal')),
                    TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Hapus')),
                  ],
                ),
              );
              if (confirm == true) {
                await NotificationsService.instance.clearAll();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua notifikasi dihapus')));
              }
            },
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: NotificationsService.instance,
        builder: (context, _) {
          final list = NotificationsService.instance.notifications;
          if (list.isEmpty) {
            return const Center(
              child: Text('Belum ada notifikasi', style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = list[index];
              return Dismissible(
                key: Key(n.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await NotificationsService.instance.remove(n.id);
                },
                child: NotificationItemWidget(
                  notification: n,
                  onTap: () async {
                    // Mark read and show details
                    await NotificationsService.instance.markRead(n.id, read: true);
                    if (!mounted) return;
                    showDialog<void>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: Text(n.title),
                        content: Text(n.body),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('Tutup')),
                        ],
                      ),
                    );
                  },
                  onDelete: () async {
                    await NotificationsService.instance.remove(n.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah notifikasi contoh',
        child: const Icon(Icons.add),
        onPressed: () async {
          // Respect user's notification preference
          if (!SettingsService.instance.notificationsEnabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifikasi nonaktif di pengaturan')),
            );
            return;
          }
          await NotificationsService.instance.addNotification(
            title: 'Contoh Notifikasi',
            body: 'Ini adalah notifikasi contoh yang dihasilkan secara lokal.',
          );
        },
      ),
    );
  }
}