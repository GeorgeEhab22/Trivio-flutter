import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class YourGroupItem extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const YourGroupItem({super.key, required this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () {
            context.push('get_group_by_id');
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(imageUrl!),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
