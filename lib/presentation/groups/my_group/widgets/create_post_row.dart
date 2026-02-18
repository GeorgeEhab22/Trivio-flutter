import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/home/add_post/add_post_bottom_sheet.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/get_group_posts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostRow extends StatelessWidget {
  final String groupId;

  const CreatePostRow({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://picsum.photos/500'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomSquareButton(
            onTap: () async {
              final groupPostsCubit = context.read<GetGroupPostsCubit>();
              final result = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddPostBottomSheet(groupId: groupId),
              );
              if (result != null) {
                groupPostsCubit.getPosts(
                  groupId: groupId,
                  refresh: true,
                );
              }
            },
            label: "Write something",
            borderRadius: 20,
            height: 12,
            backgroundColor: Theme.of(context).cardColor,
            alignment: CrossAxisAlignment.start,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.photo, color: AppColors.primary),
        ),
      ],
    );
  }
}
