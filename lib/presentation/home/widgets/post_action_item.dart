import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';
import 'package:auth/common/functions/format_number.dart';

class PostActionItem extends StatelessWidget {
  final Widget icon;
  final int count;
  final Color? color;
  final VoidCallback? onTap;
  final String? tooltip; // optional for accessibility

  const PostActionItem({
    super.key,
    required this.icon,
    required this.count,
    this.color = AppColors.iconsColor,
    this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 5),
        Text(
          formatNumber(count),
          style: Styles.textStyle14.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: tooltip != null
              ? Tooltip(message: tooltip!, child: content)
              : content,
        ),
      ),
    );
  }
}
