import 'package:auth/constants/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SendPostButton extends StatelessWidget {
  final String postId;

  const SendPostButton({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Paths.kSendButton,
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(
          Theme.of(context).iconTheme.color ?? Colors.black87,
          BlendMode.srcIn,
        ),
      ),
      onPressed: () {
        //TODO: Implement send post functionality here
      },
    );
  }
}
