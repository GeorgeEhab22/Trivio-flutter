import 'package:auth/presentation/home/posts_in_timeline/widgets/post_image.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_video.dart';
import 'package:flutter/material.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';

// text & image
class PostContent extends StatelessWidget {
  final Post post;

  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.caption != null && post.caption!.isNotEmpty) ...{
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: ExpandableText(
              text: post.caption ?? '',
              previewLines: 2,
              canCollapse: true,
            ),
          ),
        },
        if (post.media != null && post.media!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Builder(
            builder: (context) {
              final String mediaUrl = post.media![0];

              if (isVideo(mediaUrl)) {
                return PostVideo(videoUrl: mediaUrl);
              } else {
                return PostImage(imageUrl: mediaUrl);
              }
            },
          ),
        ],
      ],
    );
  }
}

bool isVideo(String url) {
  final videoExtensions = ['.mp4', '.mkv', '.mov', '.avi', '.webm'];
  return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
}
