import 'dart:async';
import 'package:auth/presentation/home/reactions/reaction_overlay.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../widgets/post_action_item.dart';

enum ReactionType { none, goal, offside }

class ReactionButton extends StatefulWidget {
  final int initialCount;
  final ValueChanged<int> onReactionChanged;

  const ReactionButton({
    super.key,
    required this.initialCount,
    required this.onReactionChanged,
  });

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  ReactionType _reaction = ReactionType.none;
  late int _reactionCount;
  OverlayEntry? _overlayEntry;
  bool _isHoveringButton = false;
  bool _isHoveringOverlay = false;
  Timer? _exitTimer;

  final List<String> _emojiList = ['🥅', '🚩'];
  final List<String> _reactionNames = ['Goal', 'Offside'];
  final List<ReactionType> _reactionList = [
    ReactionType.goal,
    ReactionType.offside,
  ];

  @override
  void initState() {
    super.initState();
    _reactionCount = widget.initialCount;
  }

  void _toggleReaction() {
    setState(() {
      if (_reaction == ReactionType.goal) {
        _reaction = ReactionType.none;
        _reactionCount--;
      } else {
        // TODO :
        // context.read<PostReactionsCubit>().removeReactionFromPost(
        //       postId: postId,
        //       userId: userId,
        //     );

        if (_reaction == ReactionType.none) _reactionCount++;
        _reaction = ReactionType.goal;
      }
      widget.onReactionChanged(_reactionCount);
    });
  }

  void _chooseReaction(ReactionType type) {
    setState(() {
      if (_reaction == ReactionType.none) _reactionCount++;
      _reaction = type;
      widget.onReactionChanged(_reactionCount);
    });
    // TODO:  :
    //context.read<PostReactionsCubit>().reactToPost(
    //postId: postId,
    //userId: userId,
    //reactionType: type,
    //);
    _closeOverlayImmediately();
  }

  void _showReactionsOverlay(BuildContext context) {
    _closeOverlayImmediately();

    final overlay = Overlay.of(context);

    final buttonBox = context.findRenderObject() as RenderBox?;
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (buttonBox == null || overlayBox == null) return;

    final position = buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox);

    _overlayEntry = buildReactionsOverlay(
      position: position,
      emojiList: _emojiList,
      reactionNames: _reactionNames,
      reactionList: _reactionList,
      onReactionSelected: _chooseReaction,
      onExit: _handleOverlayExit,
      onHoverChange: _handleOverlayHoverChange,
    );

    overlay.insert(_overlayEntry!);
  }

  void _handleOverlayHoverChange(bool hovering) {
    _isHoveringOverlay = hovering;
    _resetExitTimer();
  }

  void _handleOverlayExit() {
    _isHoveringOverlay = false;
    _resetExitTimer();
  }

  void _resetExitTimer() {
    _exitTimer?.cancel();
    _exitTimer = Timer(const Duration(milliseconds: 180), () {
      if (!_isHoveringButton && !_isHoveringOverlay) {
        _closeOverlayImmediately();
      }
    });
  }

  void _closeOverlayImmediately() {
    _exitTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isHoveringButton = false;
    _isHoveringOverlay = false;
  }

  IconData _reactionIcon() {
    switch (_reaction) {
      case ReactionType.goal:
        return Icons.sports_soccer;
      case ReactionType.offside:
        return Icons.flag;
      default:
        return Icons.sports_soccer_outlined;
    }
  }

  Color _reactionColor() {
    switch (_reaction) {
      case ReactionType.goal:
        return Colors.green;
      case ReactionType.offside:
        return Colors.redAccent;
      default:
        return AppColors.iconsColor;
    }
  }

  bool _isHoveringPlatform() => kIsWeb;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _isHoveringButton = true;
        if (_isHoveringPlatform()) _showReactionsOverlay(context);
      },
      onExit: (_) {
        _isHoveringButton = false;
        _resetExitTimer();
      },
      child: GestureDetector(
        onTap: _toggleReaction,
        onTapDown: (_) {
          if (!_isHoveringPlatform()) _showReactionsOverlay(context);
        },
        child: PostActionItem(
          icon: Icon(_reactionIcon(), size: 22, color: _reactionColor()),
          count: _reactionCount,
          color: _reactionColor(),
        ),
      ),
    );
  }
}
