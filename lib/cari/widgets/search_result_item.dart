import 'package:flutter/material.dart';
import 'package:project_pti/cari/search_service.dart';

class SearchResultItem extends StatelessWidget {
  final SampahItem item;
  final VoidCallback? onTap;

  const SearchResultItem({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Text(item.category[0]),
      ),
      title: Text(item.name),
      subtitle: Text('${item.category} • Rp ${item.pricePerKg.toStringAsFixed(0)}/kg'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
