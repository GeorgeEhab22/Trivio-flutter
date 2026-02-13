import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class FollowersListView extends StatelessWidget {
  const FollowersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Followers", style: Styles.textStyle30),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: Center(
        child: Text("List of followers will be displayed here."),
      ),
    );
  }
}