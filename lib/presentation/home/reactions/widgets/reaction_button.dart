import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/widgets/post_action_item.dart';
import 'package:flutter/material.dart';

class ReactionButton extends StatelessWidget {
  final ReactionType? reactionType;
  final int count;
  
  const ReactionButton({
    super.key,
    required this.count,
    this.reactionType,
  });

  @override
  Widget build(BuildContext context) {
    final type = reactionType ?? ReactionType.none;
    final color = _getColor(context,type);
    final iconData = _getIcon(type);
    
    return PostActionItem(
      icon: Icon(iconData, size: 22, color: color),
      count: count,
      color: color,
    );
  }

  Color _getColor(BuildContext context, ReactionType type) {
    switch (type) {
      case ReactionType.goal: return Colors.green;
      case ReactionType.offside: return Colors.red;
      default: return Theme.of(context).iconTheme.color !;
    }
  }

  IconData _getIcon(ReactionType type) {
    switch (type) {
      case ReactionType.goal: return Icons.sports_soccer;
      case ReactionType.offside: return Icons.flag;
      default: return Icons.sports_soccer_outlined;
    }
  }
}