import 'package:auth/domain/entities/reaction_type.dart';
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
                final reaction = topThree[index];
                return Positioned(
                  left: index * 14,
                  child: Text(_emoji(reaction), style: const TextStyle(fontSize: 16)),
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

  String _emoji(ReactionType type) {
    switch (type) {
      case ReactionType.like:
        return '👍';
      case ReactionType.love:
        return '❤️';
      case ReactionType.haha:
        return '😂';
      case ReactionType.wow:
        return '😮';
      case ReactionType.sad:
        return '😢';
      case ReactionType.angry:
        return '😡';
      case ReactionType.goal:
        return '🥅';
      case ReactionType.offside:
        return '🚩';
      case ReactionType.none:
        return '';
    }
  }
}
