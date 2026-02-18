import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class FollowingListView extends StatelessWidget {
  const FollowingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Following", style: Styles.textStyle30),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: Center(
        child: Text("List of following will be displayed here."),
      ),
    );
  }
}