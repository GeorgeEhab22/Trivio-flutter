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

    // final maxHeight = MediaQuery.of(context).size.height * 0.55;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), 
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // constraints: BoxConstraints(
          //   maxHeight: maxHeight, 
          // ),
          color: Colors.grey[100],
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover, 
            memCacheHeight: 800,
            memCacheWidth: 800,
            alignment: Alignment.center, 
            placeholder: (context, url) => Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey[100],
              child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}