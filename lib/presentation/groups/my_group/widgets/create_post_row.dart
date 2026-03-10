import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/add_post/add_post_bottom_sheet.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePostRow extends StatelessWidget {
  final String groupId;

  const CreatePostRow({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              final avatarUrl = state.user.avatar;
              return GestureDetector(
                onTap: () {
                  context.go(AppRoutes.profile);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).cardColor,
                  backgroundImage: (avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl) as ImageProvider
                      : null,

                  child: (avatarUrl.isEmpty)
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
              );
            }

            return const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.lightGrey,
              child: Icon(Icons.person, color: Colors.grey, size: 20),
            );
          },
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
