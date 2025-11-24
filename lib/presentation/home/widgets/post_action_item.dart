import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';
import 'package:auth/common/functions/format_number.dart';

class PostActionItem extends StatelessWidget {
  final Widget icon;
  final int count;
  final Color? color;
  final VoidCallback? onTap;

  const PostActionItem({
    super.key,
    required this.icon,
    required this.count,
    this.color = AppColors.iconsColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 5),
          Text(
            formatNumber(count),
            style: Styles.textStyle14.copyWith(
              fontWeight: FontWeight.w500,
              color: color ,
            ),
          ),
        ],
      ),
    );
  }
}
