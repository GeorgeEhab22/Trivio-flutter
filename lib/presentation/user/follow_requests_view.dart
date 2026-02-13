import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class FollowRequestsView extends StatelessWidget {
  const FollowRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Follow Requests", style: Styles.textStyle30),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: Center(
        child: Text(
          "No follow requests yet.",
          style: Styles.textStyle20.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}