import 'package:auth/common/functions/format_time.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';

class AuthorInfo extends StatelessWidget {
  final String authorName;
  final String? authorImage;
  final DateTime? createdAt;
  final bool showTimeInline;
  final double avatarRadius;
  final TextStyle? authorTextStyle;

  const AuthorInfo({
    required this.authorName,
    this.authorImage,
    this.createdAt,
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
        ClipOval(
          child: Container(
            width: avatarRadius * 2,
            height: avatarRadius * 2,
            color: AppColors.lightBackground,
            child: (authorImage != null && authorImage!.isNotEmpty)
                ? Image.network(
                    authorImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.grey);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Icon(Icons.person, color: Colors.grey);
                    },
                  )
                : const Icon(Icons.person, color: Colors.grey),
          ),
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
                        color: AppColors.lightGrey,
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
                          color: AppColors.lightGrey,
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
