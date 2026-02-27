import 'package:auth/common/functions/format_time.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';

class AuthorInfo extends StatelessWidget {
  final String authorName;
  final String? authorImage;
  final String? groupName;      
  final String? groupImage;     
  final DateTime? createdAt;
  final bool showTimeInline;
  final double avatarRadius;
  final TextStyle? authorTextStyle;
  final bool isGroupPost;

  const AuthorInfo({
    required this.authorName,
    this.authorImage,
    this.groupName,             
    this.groupImage,
    this.createdAt,
    super.key,
    this.showTimeInline = false,
    this.avatarRadius = 22,
    this.authorTextStyle,
    this.isGroupPost = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final defaultAuthorStyle = Styles.textStyle16.copyWith(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isGroupPost ? _buildGroupAvatar(context) : _buildSingleAvatar(context),
        const SizedBox(width: 10),
        Expanded(
          child: showTimeInline && !isGroupPost
              ? _buildInlineText(context, defaultAuthorStyle)
              : _buildStackedText(context, defaultAuthorStyle, l10n),
        ),
      ],
    );
  }

  Widget _buildGroupAvatar(BuildContext context) {
    return SizedBox(
      width: avatarRadius * 2.2,
      height: avatarRadius * 2.2,
      child: Stack(
        children: [
          Container(
            width: avatarRadius * 1.8,
            height: avatarRadius * 1.8,
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10), 
            ),
            clipBehavior: Clip.antiAlias,
            child: getImage(groupImage),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0, 
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: avatarRadius * 0.5,
                backgroundColor: AppColors.lightBackground,
                child: ClipOval(child: getImage(authorImage)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleAvatar(BuildContext context) {
    return ClipOval(
      child: Container(
        width: avatarRadius * 2,
        height: avatarRadius * 2,
        color: AppColors.lightBackground,
        child: getImage(authorImage),
      ),
    );
  }

  Widget _buildStackedText(BuildContext context, TextStyle defaultAuthorStyle, AppLocalizations l10n) {
    final timeText = formatTime(context, createdAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isGroupPost ? (groupName ?? l10n.defaultGroupName) : authorName,
          style: authorTextStyle ?? defaultAuthorStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        if (isGroupPost || timeText.isNotEmpty)
          Row(
            children: [
              if (isGroupPost) ...[
                Flexible(
                  child: Text(
                    authorName,
                    style: Styles.textStyle14.copyWith(color: AppColors.lightGrey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (timeText.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.circle, size: 3, color: AppColors.lightGrey),
                  ),
              ],
              if (timeText.isNotEmpty)
                Text(
                  timeText,
                  style: Styles.textStyle14.copyWith(color: AppColors.lightGrey),
                  // Direction LTR ensures time stamps like "5m" don't flip to "m5"
                  textDirection: TextDirection.ltr,
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildInlineText(BuildContext context, TextStyle defaultAuthorStyle) {
    final timeText = formatTime(context, createdAt);
    return Row(
      children: [
        Flexible(
          child: Text(
            authorName,
            style: authorTextStyle ?? defaultAuthorStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (timeText.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            timeText,
            style: Styles.textStyle14.copyWith(color: AppColors.lightGrey),
            textDirection: TextDirection.ltr,
          ),
        ],
      ],
    );
  }

  Widget getImage(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(Icons.person, color: Colors.grey);
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.grey),
    );
  }
}
