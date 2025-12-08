import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;
  const ProfileHeader({super.key, required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 44) : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name.isNotEmpty ? name : 'Pengguna',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
