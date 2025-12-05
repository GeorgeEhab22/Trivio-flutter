import 'dart:async';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'widgets/reaction_button.dart';
import 'widgets/reaction_overlay.dart';

class ReactionInteraction extends StatefulWidget {
  final ReactionType reactionType;
  final int count;
  final VoidCallback onTap;
  final Function(ReactionType) onReactionSelected;

  const ReactionInteraction({
    super.key,
    required this.reactionType,
    required this.count,
    required this.onTap,
    required this.onReactionSelected,
  });

  @override
  State<ReactionInteraction> createState() => _ReactionInteractionState();
}

class _ReactionInteractionState extends State<ReactionInteraction> {
  OverlayEntry? _overlayEntry;
  Timer? _hoverTimer;
  Timer? _closeTimer;
  bool _isOverlayOpen = false;

  static const List<String> _emojiList = ['🥅', '🚩'];
  static const List<String> _reactionNames = ['Goal', 'Offside'];
  static const List<ReactionType> _reactionList = [
    ReactionType.goal,
    ReactionType.offside,
  ];

  @override
  void dispose() {
    _hoverTimer?.cancel();
    _closeTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _onHoverEnter(bool isHovered) {
    if (!kIsWeb) return;

    if (isHovered) {
      _closeTimer?.cancel();
      if (!_isOverlayOpen) {
        _hoverTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) _showOverlayAtAnchor(_buttonGlobalRect());
        });
      }
    } else {
      _hoverTimer?.cancel();
      _closeTimer = Timer(const Duration(milliseconds: 300), _removeOverlay);
    }
  }

  Rect _buttonGlobalRect() {
   
    final overlay = Overlay.of(context);

    final overlayRenderBox = overlay.context.findRenderObject() as RenderBox?;
    final renderBox = context.findRenderObject() as RenderBox?;

    if (overlayRenderBox == null || renderBox == null || !renderBox.hasSize) {
      return Rect.zero;
    }

    // top-left in overlay coordinates
    final topLeft = renderBox.localToGlobal(
      Offset.zero,
      ancestor: overlayRenderBox,
    );
    return topLeft & renderBox.size;
  }

  void _showOverlayAtAnchor(Rect anchor) {
    if (_isOverlayOpen) return;
    _removeOverlay();

    _overlayEntry = _createOverlayEntry(anchor);
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) setState(() => _isOverlayOpen = true);
  }

  void _removeOverlay() {
    if (!_isOverlayOpen && _overlayEntry == null) return;
    try {
      _overlayEntry?.remove();
    } catch (_) {}
    _overlayEntry = null;
    if (mounted) setState(() => _isOverlayOpen = false);
  }

  OverlayEntry _createOverlayEntry(Rect anchor) {
    return buildReactionsOverlay(
      anchor: anchor,
      emojiList: _emojiList,
      reactionNames: _reactionNames,
      reactionList: _reactionList,
      onReactionSelected: (type) {
        _removeOverlay();
        widget.onReactionSelected(type);
      },
      onExit: () {
        _removeOverlay();
      },
      onHoverChange: (isHoveringInOverlay) {
        if (isHoveringInOverlay) {
          _closeTimer?.cancel();
        } else {
          _closeTimer = Timer(
            const Duration(milliseconds: 300),
            _removeOverlay,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _removeOverlay();
        widget.onTap();
      },
      onLongPressStart: (details) {
        final rect = _buttonGlobalRect();
        final anchor = rect == Rect.zero
            ? Rect.fromCenter(
                center: details.globalPosition,
                width: 44,
                height: 44,
              )
            : rect;
        _showOverlayAtAnchor(anchor);
      },

      onLongPressEnd: (_) {
        Future.microtask(() => _removeOverlay());
      },
      child: MouseRegion(
        onEnter: (_) => _onHoverEnter(true),
        onExit: (_) => _onHoverEnter(false),
        child: ReactionButton(
          count: widget.count,
          reactionType: widget.reactionType,
        ),
      ),
    );
  }
}
