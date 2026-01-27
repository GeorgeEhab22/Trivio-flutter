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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasCaption)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: ExpandableText(
              text: post.caption ?? '',
              previewLines: 2,
              canCollapse: true,
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
