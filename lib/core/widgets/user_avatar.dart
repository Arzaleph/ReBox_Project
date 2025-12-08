import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_pti/core/models/user.dart';
import 'package:project_pti/core/services/profile_service.dart';

/// Widget untuk menampilkan avatar user dengan fallback ke icon
class UserAvatar extends StatelessWidget {
  final User? user;
  final double size;
  final bool showBorder;
  final Color? borderColor;

  const UserAvatar({
    super.key,
    this.user,
    this.size = 50,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final profileService = ProfileService();
    final avatarUrl = user != null ? profileService.getAvatarUrl(user!) : null;

    Widget avatarWidget;

    if (avatarUrl != null) {
      avatarWidget = CachedNetworkImage(
        imageUrl: avatarUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackIcon(),
      );
    } else {
      avatarWidget = _buildFallbackIcon();
    }

    Widget avatar = ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: avatarWidget,
      ),
    );

    if (showBorder) {
      avatar = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? Colors.white,
            width: 3,
          ),
        ),
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Colors.grey.shade600,
      ),
    );
  }
}
