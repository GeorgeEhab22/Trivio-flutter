import 'package:flutter/material.dart';

class NotificationAvatar extends StatelessWidget {
  final String? imageUrl;
  const NotificationAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[800],
        image: (imageUrl != null && imageUrl!.isNotEmpty)
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? const Icon(Icons.person, color: Colors.white54)
          : null,
    );
  }
}