import 'dart:async';
import 'package:auth/presentation/home/reactions/reaction_overlay.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../widgets/post_action_item.dart';
//TODO: most of this logic should be moved to a cubit
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

  // Make these const/final to avoid recreating lists every build
  static const List<String> _emojiList = ['🥅', '🚩'];
  static const List<String> _reactionNames = ['Goal', 'Offside'];
  static const List<ReactionType> _reactionList = [
    ReactionType.goal,
    ReactionType.offside,
  ];

  @override
  void initState() {
    super.initState();
    _reactionCount = widget.initialCount;
  }

  @override
  void didUpdateWidget(covariant ReactionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent updates the authoritative count, sync local counter.
    if (oldWidget.initialCount != widget.initialCount) {
      _reactionCount = widget.initialCount;
    }
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    _closeOverlayImmediately();
    super.dispose();
  }

  void _toggleReaction() {
    // Toggle a simple "goal" reaction on single tap
    final wasGoal = _reaction == ReactionType.goal;
    int newCount = _reactionCount;
    ReactionType newReaction = _reaction;

    if (wasGoal) {
      // remove reaction
      newReaction = ReactionType.none;
      newCount = (newCount - 1).clamp(0, 1 << 30);
    } else {
      // add goal reaction
      if (_reaction == ReactionType.none) {
        newCount = newCount + 1;
      }
      newReaction = ReactionType.goal;
    }

    // Only update state if something actually changed
    if (newCount != _reactionCount || newReaction != _reaction) {
      setState(() {
        _reactionCount = newCount;
        _reaction = newReaction;
      });
      widget.onReactionChanged(_reactionCount);
    }
  }

  void _chooseReaction(ReactionType type) {
    // Choose a specific reaction (from overlay)
    final wasNone = _reaction == ReactionType.none;
    int newCount = _reactionCount;
    if (wasNone) newCount = newCount + 1;

    // If identical reaction chosen and not none, keep it (or toggle off?)
    // Here we set to chosen type (idempotent)
    setState(() {
      _reactionCount = newCount;
      _reaction = type;
    });
    widget.onReactionChanged(_reactionCount);

    _closeOverlayImmediately();
  }

  void _showReactionsOverlay(BuildContext context) {
    _closeOverlayImmediately();

    final overlayState = Overlay.of(context);

    final buttonBox = context.findRenderObject() as RenderBox?;
    final overlayBox = overlayState.context.findRenderObject() as RenderBox?;
    if (buttonBox == null || overlayBox == null) return;

    // Position relative to overlay
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

    overlayState.insert(_overlayEntry!);
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
    // Small delay so brief pointer leaves don't immediately close the overlay
    _exitTimer = Timer(const Duration(milliseconds: 180), () {
      if (!_isHoveringButton && !_isHoveringOverlay) {
        _closeOverlayImmediately();
      }
    });
  }

  void _closeOverlayImmediately() {
    try {
      _overlayEntry?.remove();
    } catch (_) {}
    _overlayEntry = null;
    _exitTimer?.cancel();
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
        if (_isHoveringPlatform()) {
          // show overlay on hover for web
          _showReactionsOverlay(context);
        }
      },
      onExit: (_) {
        _isHoveringButton = false;
        _resetExitTimer();
      },
      child: GestureDetector(
        // Single tap toggles a default reaction
        onTap: _toggleReaction,
        // On mobile, a long press reveals the overlay to pick a specific reaction
        onLongPress: () {
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
