import 'package:flutter/material.dart';
import 'post_header.dart';
import 'post_content.dart';
import 'post_image.dart';
import 'post_states.dart';
//TODO: use proper entity instead of individual parameters
class PostCard extends StatefulWidget {
  final String author;
  final String? authorImage;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final bool isFollowing;
  final bool isSaved;

  const PostCard({
    super.key,
    required this.author,
    required this.authorImage,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isFollowing,
    required this.isSaved,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isFollowing = false;
  bool isNotInterested = false;
  void _toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
    // ✅ TODO:
    // Later, connect this to your state management (Cubit/Provider)
    // Example:
    // context.read<FollowCubit>().toggleFollow(userId);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // ✅ TODO:
        // When single post feature is implemented:
        // Navigate and fetch the full post by postId using a Cubit/Provider.
        //
        // Example:
        // context.read<PostCubit>().getPostById(postId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        color: Colors.white,
        elevation: 0.1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(
                author: widget.author,
                authorImage: widget.authorImage,
                timeAgo: widget.timeAgo,
                isFollowing: isFollowing,
                onFollowToggle: _toggleFollow,
                isNotInterested: isNotInterested,
                onToggleInterest: () {
                  setState(() {
                    isNotInterested = !isNotInterested;
                  });
                  // ✅ TODO:
                  // Connect to your Cubit/Provider later to toggle interest in post
                  //
                  // Example:
                  // context.read<PostInterestCubit>().toggleInterest(postId);
                },
              ),
              PostContent(content: widget.content),
              if (widget.imageUrl != null) ...[
                const SizedBox(height: 6),
                PostImage(),
              ],
              const SizedBox(height: 8),
              Divider(
                height: 1,
                color: const Color(0xFFF3F4F6),
                thickness: 0.7,
                indent: 12,
                endIndent: 12,
              ),
              PostStates(
                reactions: widget.likes,
                comments: widget.comments,
                shares: widget.shares,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
