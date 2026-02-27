import 'package:auth/constants/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SendPostButton extends StatelessWidget {
  final String postId;
  final bool compact;
  final Color? iconColor;

  const SendPostButton({
    super.key,
    required this.postId,
    this.compact = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor =
        iconColor ?? Theme.of(context).iconTheme.color ?? Colors.black87;
    return IconButton(
      padding: EdgeInsets.zero,
      splashRadius: compact ? 18 : 24,
      constraints: compact
          ? const BoxConstraints.tightFor(width: 34, height: 34)
          : null,
      icon: SvgPicture.asset(
        Paths.kSendButton,
        width: compact ? 18 : 22,
        height: compact ? 18 : 22,
        colorFilter: ColorFilter.mode(
          resolvedIconColor,
          BlendMode.srcIn,
        ),
      ),
      onPressed: () {
        //TODO: Implement send post functionality here
      },
    );
  }
}
