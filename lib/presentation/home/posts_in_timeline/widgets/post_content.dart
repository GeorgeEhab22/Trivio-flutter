import 'package:auth/presentation/home/posts_in_timeline/widgets/post_image.dart';
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: ExpandableText(
            text: post.content,
            previewLines: 2,
            canCollapse: true,
          ),
        ),
        if (post.imageUrl != null) ...[
          const SizedBox(height: 6),
          PostImage(), 
        ],
      ],
    );
  }
}