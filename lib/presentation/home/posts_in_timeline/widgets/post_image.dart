import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostImage extends StatelessWidget {
  final String? imageUrl;
  final double? originalWidth;
  final double? originalHeight;

  const PostImage({
    super.key,
    this.imageUrl,
    this.originalWidth,
    this.originalHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardGradient = isDark
        ? const [Color(0xFF1D2228), Color(0xFF171B20)]
        : const [Color(0xFFFFFFFF), Color(0xFFF8FBF9)];

    final maxHeight = MediaQuery.of(context).size.height * 0.65;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: cardGradient,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
              memCacheHeight: 1000,
              alignment: Alignment.center,
              placeholder: (context, url) => const SizedBox(height: 250),
              errorWidget: (context, url, error) => const SizedBox(
                height: 250,
                child: Icon(Icons.broken_image_outlined, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
