import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/widgets/post_action_item.dart';
import 'package:flutter/material.dart';

class ReactionButton extends StatelessWidget {
  final ReactionType? reactionType;
  final int count;

  const ReactionButton({super.key, required this.count, this.reactionType});

  @override
  Widget build(BuildContext context) {
    final type = reactionType ?? ReactionType.none;
    final color = _neutralActionColor(context);
    final leading = _buildLeading(context, type, color);

    return PostActionItem(icon: leading, count: count, color: color);
  }

  Widget _buildLeading(BuildContext context, ReactionType type, Color color) {
    if (type == ReactionType.none) {
      return Icon(Icons.thumb_up_alt_outlined, size: 20, color: color);
    }

    return Text(
      _getEmoji(type),
      style: const TextStyle(fontSize: 20, height: 1),
    );
  }

  Color _neutralActionColor(BuildContext context) {
    return Theme.of(context).iconTheme.color ?? Colors.grey;
  }

  String _getEmoji(ReactionType type) {
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
      default:
        return '👍';
    }
  }
}
