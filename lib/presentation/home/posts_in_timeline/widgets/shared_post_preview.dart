import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_content.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_header.dart';
import 'package:flutter/material.dart';

class SharedPostPreview extends StatelessWidget {
  final Post post;
  
  const SharedPostPreview({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
              ? const [Color(0xFF1D2228), Color(0xFF171B20)] 
              : const [Color(0xFFFFFFFF), Color(0xFFF8FBF9)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.darkGreen],
                ),
              ),
            ),
            PostHeader(post: post, currentUserId: ""),
            PostContent(post: post, isNested: true),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}