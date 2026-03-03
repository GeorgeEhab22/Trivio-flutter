import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/add_post/add_post_bottom_sheet.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostRow extends StatelessWidget {
  final String groupId;

  const CreatePostRow({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              final groupPostsCubit = context.read<GroupPostsCubit>();
              final result = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddPostBottomSheet(groupId: groupId),
              );

              if (result != null && context.mounted) {
                groupPostsCubit.addPostOptimistically(result);
              }
            },
            label: l10n.writeSomething, // Localized
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
