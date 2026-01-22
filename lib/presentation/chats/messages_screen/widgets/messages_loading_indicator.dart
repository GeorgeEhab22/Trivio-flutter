import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';

class MessagesLoadingIndicator extends StatelessWidget {
  const MessagesLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}