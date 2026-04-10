import 'package:auth/constants/paths.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/reactions/widgets/render_reactions.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PeopleReacted extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;
  final List<ReactionType> topReactions;

  const PeopleReacted({
    super.key,
    required this.color,
    this.onTap,
    this.topReactions = const <ReactionType>[],
  });

  @override
  Widget build(BuildContext context) {
    final topThree = topReactions.take(3).toList();
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (topThree.isEmpty)
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.18),
            ),
            child: Icon(Icons.people_alt_outlined, size: 14, color: color),
          )
        else
          SizedBox(
            width: 24 + (topThree.length - 1) * 14,
            height: 26,
            child: Stack(
              clipBehavior: Clip.none,
              children: List.generate(topThree.length, (index) {
                final path = _emojiPath(topThree[index]);
                return Positioned(
                  left: index * 14.0,
                  child: path.isNotEmpty
                      ? ReactionEmoji(path: path, size: 20)
                      : const SizedBox(width: 20, height: 20),
                );
              }),
            ),
          ),
      ],
    );

    return Skeleton.ignore(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: content,
        ),
      ),
    );
  }

  String _emojiPath(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return Paths.likeEmoji;
      case ReactionType.love:
        return Paths.loveEmoji;
      case ReactionType.haha:
        return Paths.hahaEmoji;
      case ReactionType.wow:
        return Paths.wowEmoji;
      case ReactionType.sad:
        return Paths.sadEmoji;
      case ReactionType.angry:
        return Paths.angryEmoji;
      case ReactionType.goal:
        return Paths.ballEmoji;
      case ReactionType.offside:
        return Paths.offsideEmoji;
      case ReactionType.none:
        return '';
    }
  }
}