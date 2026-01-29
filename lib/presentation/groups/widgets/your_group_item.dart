import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class YourGroupItem extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const YourGroupItem({super.key, required this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () {
            context.push('get_group_by_id');
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl!),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.textStyle14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
