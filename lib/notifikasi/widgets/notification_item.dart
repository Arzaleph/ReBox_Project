import 'package:flutter/material.dart';
import 'package:project_pti/notifikasi/notifications_service.dart';

class NotificationItemWidget extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NotificationItemWidget({super.key, required this.notification, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        notification.read ? Icons.mark_email_read : Icons.mark_email_unread,
        color: notification.read ? Colors.grey : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.read ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      subtitle: Text(notification.body),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}
