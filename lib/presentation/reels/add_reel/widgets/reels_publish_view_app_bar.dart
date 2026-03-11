import 'package:auth/constants/colors.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/post_cubit/create_post_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';

class ReelsPublishViewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final XFile videoFile;
  final String caption;

  const ReelsPublishViewAppBar({
    super.key,
    required this.videoFile,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text("New Reel", style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () {
            //TODO : create add reel cubit and replace post cubit
            final cubit = context.read<CreatePostCubit>();

            final profileState = context.read<ProfileCubit>().state;
            if (profileState is ProfileLoaded) {
              cubit.updateText(caption);
              cubit.addMedia([videoFile]);
              cubit.submitPost(userId: profileState.user.id);
            }
          },
          child: Text(
            l10n.shareAction,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
