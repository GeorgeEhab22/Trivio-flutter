import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const CircleAvatar(radius: 22, child: Icon(Icons.person, size: 20)),
          const SizedBox(width: 10),
          Text(
            "User Name",
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: AppColors.primary, size: 28),
          onPressed: () {
            showCustomDialog(
              context: context,
              title: "Calling...",
              //TODO: change to actual user name
              content: "Call \"user name\"",
              confirmText: "Call",
              onConfirm: () {
                //TODO: later add call functionality
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.videocam,
            color: AppColors.primary,
            size: 28,
          ),
          onPressed: () {
            showCustomDialog(
              context: context,
              title: "Video Calling...",
              //TODO: change to actual user name
              content: "Video Call \"user name\"",
              confirmText: "Call",
              onConfirm: () {
                //TODO: later add video call functionality
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.info, color: AppColors.primary, size: 26),
          onPressed: () {
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}