import 'package:flutter/material.dart';
import 'package:project_pti/pesanan/order_service.dart';

class OrderItemWidget extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleComplete;

  const OrderItemWidget({super.key, required this.order, this.onTap, this.onDelete, this.onToggleComplete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: order.completed ? Colors.grey[300] : Theme.of(context).colorScheme.primary,
        child: Icon(order.completed ? Icons.check : Icons.shopping_cart, color: Colors.white),
      ),
      title: Text(order.itemName, style: TextStyle(decoration: order.completed ? TextDecoration.lineThrough : null)),
      subtitle: Text('Rp ${order.total.toStringAsFixed(0)} • ${order.weightKg} kg'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(order.synced ? Icons.cloud_done : Icons.cloud_off, color: order.synced ? Colors.green : Colors.grey),
            onPressed: null,
            tooltip: order.synced ? 'Tersinkron' : 'Belum tersinkron',
          ),
          IconButton(
            icon: Icon(order.completed ? Icons.undo : Icons.check_circle, color: order.completed ? Colors.orange : Colors.green),
            onPressed: onToggleComplete,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
