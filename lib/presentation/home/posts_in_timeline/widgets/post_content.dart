import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_image_slider.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_video.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:flutter/material.dart';
import 'package:auth/domain/entities/post.dart';

class PostContent extends StatelessWidget {
  final Post post;
  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final hasMedia = post.media != null && post.media!.isNotEmpty;
    final hasCaption = post.caption != null && post.caption!.isNotEmpty;
    final captionBgColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFF4F8F5);
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasCaption)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              decoration: BoxDecoration(
                color: captionBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Stack(
                children: [
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Color(0xFF42C83C), AppColors.darkGreen],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12),
                    child: ExpandableText(
                      text: post.caption ?? '',
                      previewLines: 4,
                      canCollapse: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (hasMedia)
          isVideo(post.media![0])
              ? PostVideo(videoUrl: post.media![0])
              : PostImageSlider(images: post.media!, postId: post.postID ?? ''),
      ],
    );
  }
}

bool isVideo(String url) {
  final videoExtensions = ['.mp4', '.mkv', '.mov', '.avi', '.webm'];
  return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
}
