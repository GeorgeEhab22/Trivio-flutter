import 'package:flutter/material.dart';
import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';

class AuthorInfo extends StatelessWidget {
  final String author;
  final String? authorImage;
  final String timeAgo;
  final bool showTimeInline;
  final double avatarRadius;
  final TextStyle? authorTextStyle;

  const AuthorInfo({
    super.key,
    required this.author,
    required this.authorImage,
    required this.timeAgo,
    this.showTimeInline = false,
    this.avatarRadius = 22,
    this.authorTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultAuthorStyle = Styles.textStyle16.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.iconsColor,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                        author,
                        style: authorTextStyle ?? defaultAuthorStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (timeAgo.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        timeAgo,
                        style: Styles.textStyle14.copyWith(
                          color: const Color(0xFF888888),
                        ),
                      ),
                    ] else
                      const Spacer(), // Add Spacer if timeAgo is empty
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: authorTextStyle ?? defaultAuthorStyle),
                    if (timeAgo.isNotEmpty)
                      Text(
                        timeAgo,
                        style: Styles.textStyle14.copyWith(
                          color: const Color(0xFF888888),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
