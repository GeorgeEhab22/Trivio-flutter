import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/l10n/app_localizations.dart'; // Import localization
import 'package:flutter/material.dart';
import 'widgets/reaction_button.dart';
import 'widgets/reaction_overlay.dart';

class ReactionInteraction extends StatefulWidget {
  final ReactionType reactionType;
  final int count;
  final VoidCallback onTap;
  final Function(ReactionType) onReactionSelected;
  final bool isVertical;

  const ReactionInteraction({
    super.key,
    required this.reactionType,
    required this.count,
    required this.onTap,
    required this.onReactionSelected,
    this.isVertical = false,
  });

  @override
  State<ReactionInteraction> createState() => _ReactionInteractionState();
}

class _ReactionInteractionState extends State<ReactionInteraction> {
  OverlayEntry? _overlayEntry;
  bool _isOverlayOpen = false;

  static const List<String> _emojiList = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '😡',
    '⚽',
    '🚩',
  ];
  static const List<ReactionType> _reactionList = [
    ReactionType.like,
    ReactionType.love,
    ReactionType.haha,
    ReactionType.wow,
    ReactionType.sad,
    ReactionType.angry,
    ReactionType.goal,
    ReactionType.offside,
  ];

  // This list will hold the localized names
  List<String> _localizedReactionNames = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    _localizedReactionNames = isArabic
        ? const ['إعجاب', 'حب', 'مضحك', 'انبهار', 'حزين', 'غاضب', 'هدف', 'تسلل']
        : [
            'Like',
            'Love',
            'Haha',
            'Wow',
            'Sad',
            'Angry',
            l10n.reactionGoal,
            l10n.reactionOffside,
          ];
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Rect _buttonGlobalRect() {
    final overlay = Overlay.of(context);
    final overlayRenderBox = overlay.context.findRenderObject() as RenderBox?;
    final renderBox = context.findRenderObject() as RenderBox?;

    if (overlayRenderBox == null || renderBox == null || !renderBox.hasSize) {
      return Rect.zero;
    }

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
      reactionNames: _localizedReactionNames,
      reactionList: _reactionList,
      onReactionSelected: (type) {
        _removeOverlay();
        widget.onReactionSelected(type);
      },
      onExit: () {
        _removeOverlay();
      },
      onHoverChange: (_) {},
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
      child: ReactionButton(
        count: widget.count,
        reactionType: widget.reactionType,
        isVertical: widget.isVertical,
      ),
    );
  }
}
