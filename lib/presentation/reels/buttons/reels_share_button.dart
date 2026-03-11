import 'package:auth/presentation/home/share_post/share_button.dart';
import 'package:flutter/material.dart';

class ReelsShareButton extends StatelessWidget {
  final int count;

  const ReelsShareButton({super.key, this.count = 0});

  @override
  Widget build(BuildContext context) {
    return ShareButton(
      count: count,
      isReelView: true, 
    );
  }
}