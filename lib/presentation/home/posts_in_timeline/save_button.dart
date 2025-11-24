import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auth/constants/colors';

class SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const SaveButton({super.key, required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCustomSnackBar(
          context,
          isSaved
              ? "Post removed from saved items."
              : "Post saved successfully!",
          true,
        );
        onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: isSaved ? 1.15 : 1.0,
        child: FaIcon(
          isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
          size: 22,
          color: isSaved ? AppColors.primary : AppColors.iconsColor,
        ),
      ),
    );
  }
}
