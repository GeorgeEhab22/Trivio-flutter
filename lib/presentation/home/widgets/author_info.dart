import 'package:auth/common/functions/format_time.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';

class AuthorInfo extends StatelessWidget {
  final String authorName;
  final String? authorImage;
  final DateTime createdAt;
  final bool showTimeInline;
  final double avatarRadius;
  final TextStyle? authorTextStyle;

  const AuthorInfo({
    required this.authorName,
    this.authorImage,
    required this.createdAt,
    super.key,
    this.showTimeInline = false,
    this.avatarRadius = 22,
    this.authorTextStyle,
  });

  // final Post post;

  @override
  Widget build(BuildContext context) {
    final defaultAuthorStyle = Styles.textStyle16.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.iconsColor,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: AppColors.iconsColor,
          backgroundImage: authorImage != null
              ? NetworkImage(authorImage!)
              : null,
          onBackgroundImageError: (_, __) {},
          child: (authorImage == null)
              ? Icon(Icons.person, color: AppColors.iconsColor)
              : null,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: showTimeInline
              ? Row(
                  children: [
                    Flexible(
                      child: Text(
                        authorName,
                        style: authorTextStyle ?? defaultAuthorStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatTime(createdAt),
                      style: Styles.textStyle14.copyWith(
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: authorTextStyle ?? defaultAuthorStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        formatTime(createdAt),
                        style: Styles.textStyle14.copyWith(
                          color: const Color(0xFF888888),
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
