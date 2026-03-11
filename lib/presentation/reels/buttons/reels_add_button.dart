import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReelsAddButton extends StatelessWidget {
  const ReelsAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await BottomSheetManager.pickMedia(
          context: context,
          isVideo: true,
          fromCamera: false,
          onError: (message) {
            showCustomSnackBar(context, message, false);
          },
          onPicked: (files) {
            if (files.isNotEmpty) {
              context.push(AppRoutes.reelsPublish, extra: files.first);
            }
          },
        );
      },
      icon: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
