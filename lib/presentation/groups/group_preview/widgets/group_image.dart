import 'package:auth/constants/paths.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupImage extends StatelessWidget {
  final String? image;
  const GroupImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty || image!.contains('undefined')) {
      return Image.asset(
        Paths.defaultGroupImage,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: image!,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      memCacheHeight: 400,
      // placeholder: (context, url) => Container(
      //   color: Colors.grey[200],
      //   child: const Center(child: CircularProgressIndicator()),
      // ),
      errorWidget: (context, url, error) =>
          Image.asset(Paths.defaultGroupImage, fit: BoxFit.cover),
    );
  }
}
