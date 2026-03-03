import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/group_preview/widgets/group_image.dart';
import 'package:auth/presentation/groups/widgets/number_of_members_row.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GroupItem extends StatelessWidget {
  final String groupId;
  final int numOfMembers;
  final String title;
  final String? imageUrl;
  final bool isHorizontal;
  final bool? myGroup;

  const GroupItem({
    super.key,
    required this.groupId,
    required this.numOfMembers,
    required this.title,
    this.imageUrl,
    this.isHorizontal = false,
    this.myGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (myGroup == true) {
          final cubit = context.read<GroupPostsCubit>();
          await context.push('${AppRoutes.myGroup}/$groupId');
          cubit.getFeedPosts();
        } else {
          context.push('${AppRoutes.groupFeed}/$groupId');
        }
      },
      child: isHorizontal
          ? buildHorizontalLayout(numOfMembers)
          : buildVerticalLayout(),
    );
  }

  Widget buildVerticalLayout() {
    return SizedBox(
      width: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            SizedBox(
              width: 80,
              height: 67,
              child: ClipOval(child: GroupImage(image: imageUrl)),
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

  Widget buildHorizontalLayout(int numOfMembers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ClipOval(child: GroupImage(image: imageUrl)),
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

                NumberOfMembersRow(numOfMembers: numOfMembers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
