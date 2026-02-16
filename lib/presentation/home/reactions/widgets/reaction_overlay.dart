import 'package:auth/domain/entities/reaction_type.dart';
import 'package:flutter/material.dart';

OverlayEntry buildReactionsOverlay({
  required Rect anchor, 
  required List<String> emojiList,
  required List<String> reactionNames,
  required List<ReactionType> reactionList,
  required Function(ReactionType) onReactionSelected,
  required VoidCallback onExit,
  required Function(bool) onHoverChange,
}) {
  ReactionType? hoveringReaction;

  return OverlayEntry(
    builder: (context) {
      final screenSize = MediaQuery.of(context).size;

      const bubblePaddingH = 10.0;
      const itemHorizontal = 12.0; 
      const emojiSize = 24.0;
      final itemWidth = emojiSize + (itemHorizontal * 2);
      final bubbleWidth = (emojiList.length * itemWidth) + (bubblePaddingH * 2);
      const bubbleHeightEstimate = 64.0;
      
      double left = anchor.center.dx - bubbleWidth / 2;
      left = left.clamp(8.0, screenSize.width - bubbleWidth - 8.0);

      double top = anchor.top - bubbleHeightEstimate - 8.0;
      if (top < 8.0) {
        top = anchor.bottom + 8.0;
      }

      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onExit,
                child: const SizedBox.shrink(),
              ),
            ),

            Positioned(
              left: left,
              top: top,
              child: MouseRegion(
                onEnter: (_) => onHoverChange(true),
                onExit: (_) => onHoverChange(false),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {}, 
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, // Respect dark/light theme
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      // Force LTR so the emoji order matches the list index order
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(emojiList.length, (index) {
                            final isHovering = hoveringReaction == reactionList[index];
                            return _buildReactionItem(
                              emoji: emojiList[index],
                              label: reactionNames[index],
                              isHovering: isHovering,
                              onHover: (hovering) {
                                onHoverChange(hovering);
                                hoveringReaction = hovering ? reactionList[index] : null;
                              },
                              onTap: () {
                                onReactionSelected(reactionList[index]);
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildReactionItem({
  required String emoji,
  required String label,
  required bool isHovering,
  required Function(bool) onHover,
  required VoidCallback onTap,
}) {
  return MouseRegion(
    onEnter: (_) => onHover(true),
    onExit: (_) => onHover(false),
    child: GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label is now localized because it's passed from the parent state
            if (isHovering)
              Text(
                label,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            AnimatedScale(
              duration: const Duration(milliseconds: 150),
              scale: isHovering ? 1.4 : 1.0,
              curve: Curves.easeOutBack,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}