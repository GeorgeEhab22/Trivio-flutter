import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/posts_in_timeline/options_buttom_sheet.dart';
import 'package:auth/presentation/home/posts_in_timeline/report_resons_buttom_sheet.dart';
import 'package:auth/presentation/home/widgets/author_info.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final String author;
  final String? authorImage;
  final String timeAgo;
  final bool isFollowing;
  final VoidCallback onFollowToggle;
  final bool isNotInterested;
  final VoidCallback onToggleInterest;

  const PostHeader({
    super.key,
    required this.author,
    required this.authorImage,
    required this.timeAgo,
    required this.isFollowing,
    required this.onFollowToggle,
    required this.isNotInterested,
    required this.onToggleInterest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // 🔹 Author Info
          Expanded(
            child: AuthorInfo(
              author: author,
              authorImage: authorImage,
              timeAgo: timeAgo,
              showTimeInline: false,
            ),
          ),

          // 🔹 Follow Button
          SizedBox(
            height: 30,
            child: TextButton(
              onPressed: onFollowToggle,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF5F5F5),
                padding: EdgeInsets.symmetric(
                  horizontal: isFollowing ? 18 : 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isFollowing ? 'Following' : 'Follow',
                style: Styles.textStyle14.copyWith(
                  color: AppColors.iconsColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // 🔹 Options Button
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.iconsColor),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => OptionsBottomSheet(
                  isNotInterested: isNotInterested,
                  onSave: () {
                    showCustomSnackBar(
                      context,
                      "Post saved successfully!",
                      true,
                    );
                  },
                  onCopyLink: () {
                    showCustomSnackBar(
                      context,
                      "Link copied to clipboard!",
                      true,
                    );
                  },
                  onViewEditHistory: () {},
                  onNotInterested: () {
                    onToggleInterest();
                  },
                  onReportFlow: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ReportReasonsBottomSheet(
                        onReportSelected: (reason) async {
                          await Future.delayed(
                            const Duration(milliseconds: 600),
                          );
                          debugPrint("✅ Reported reason: $reason");
                          return true;
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
