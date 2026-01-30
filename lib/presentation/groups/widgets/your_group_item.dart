import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/widgets/members_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class YourGroupItem extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool isHorizontal;

  const YourGroupItem({
    super.key,
    required this.title,
    this.imageUrl,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.groupFeed),
      child: isHorizontal ? buildHorizontalLayout() : buildVerticalLayout(),
    );
  }

  Widget buildVerticalLayout() {
    return SizedBox(
      width: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                imageUrl ?? 'https://picsum.photos/500',
              ),
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
    );
  }

  Widget buildHorizontalLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(
              imageUrl ?? 'https://picsum.photos/500',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Styles.textStyle16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const MembersRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
