import 'package:auth/common/functions/reels_buttons_green_effect.dart';
import 'package:auth/constants/paths.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/reactions/widgets/render_reactions.dart';
import 'package:auth/presentation/home/widgets/post_action_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReactionButton extends StatelessWidget {
  final ReactionType? reactionType;
  final int count;
  final bool isVertical;

  const ReactionButton({
    super.key,
    required this.count,
    this.reactionType,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final type = reactionType ?? ReactionType.none;
    final color = _neutralActionColor(context);
    final leading = _buildLeading(context, type, color);

    return PostActionItem(
      icon: leading,
      count: count,
      color: color,
      isVertical: isVertical,
    );
  }

  Widget _buildLeading(BuildContext context, ReactionType type, Color color) {
    final double iconSize = isVertical ? 24 : 20;
    Widget iconWidget;

    if (type == ReactionType.none) {
      iconWidget = ReactionEmoji(path: Paths.goalEmoji, size: iconSize);
    } else {
      final svgPath = _getReactionSvg(type);

      iconWidget = ReactionEmoji(path: svgPath, size: iconSize);
    }

    if (isVertical) {
      return ReelsButtonsGreenEffect(child: iconWidget);
    }

    return iconWidget;
  }

  Color _neutralActionColor(BuildContext context) {
    if (isVertical) return Colors.white;
    return Theme.of(context).iconTheme.color ?? Colors.grey;
  }

  String _getReactionSvg(ReactionType type) {
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
      default:
        return Paths.ballEmoji;
    }
  }
}
