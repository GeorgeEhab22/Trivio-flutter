import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {
  final String content;
  final int previewLines;

  const PostContent({super.key, required this.content, this.previewLines = 2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: ExpandableText(
        text: content,
        previewLines: previewLines,
        canCollapse: true,
      ),
    );
  }
}
