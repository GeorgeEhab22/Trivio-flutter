import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final String? imageUrl;
  final double? originalWidth; // Original image width
  final double? originalHeight; // Original image height

  const PostImage({
    super.key,
    this.imageUrl,
    this.originalWidth,
    this.originalHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth =
        screenWidth * 0.9; // Display image at 90% of screen width
    double imageHeight;

    if (originalWidth != null && originalHeight != null) {
      // Keep aspect ratio based on original image size
      imageHeight = (originalHeight! / originalWidth!) * imageWidth;
    } else {
      // Default height when no original size is provided
      imageHeight = screenWidth * 0.5;
    }

    // Set a maximum height for tall images
    final maxHeight = MediaQuery.of(context).size.height * 0.65;
    if (imageHeight > maxHeight) imageHeight = maxHeight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: imageWidth,
          height: imageHeight,
          color: Colors.grey[200],
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.sports_soccer,
                  size: imageHeight * 0.25,
                  color: Colors.grey[500],
                ),
        ),
      ),
    );
  }
}
