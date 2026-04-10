import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/reactions/widgets/render_reactions.dart';
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
      final itemCount = [
        emojiList.length,
        reactionNames.length,
        reactionList.length,
      ].reduce((a, b) => a < b ? a : b);

      const bubblePaddingH = 10.0;
      const itemHorizontal = 12.0;
      const emojiSize = 24.0;
      final itemWidth = emojiSize + (itemHorizontal * 2);
      final bubbleWidth = (itemCount * itemWidth) + (bubblePaddingH * 2);
      const bubbleHeightEstimate = 64.0;

      double left = anchor.center.dx - bubbleWidth / 2;
      final maxLeft = screenSize.width - bubbleWidth - 8.0;
      if (maxLeft <= 8.0) {
        left = 8.0;
      } else {
        left = left.clamp(8.0, maxLeft);
      }

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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: screenSize.width - 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(itemCount, (index) {
                              final isHovering =
                                  hoveringReaction == reactionList[index];
                              return _buildReactionItem(
                                emoji: emojiList[index],
                                label: reactionNames[index],
                                isHovering: isHovering,
                                onHover: (hovering) {
                                  onHoverChange(hovering);
                                  hoveringReaction = hovering
                                      ? reactionList[index]
                                      : null;
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
            ),
          ],
        ),
      );
    },
  );
}

bool _isSvgAsset(String emoji) => emoji.endsWith('.svg');

Widget _buildEmojiWidget(String emoji, double size) {
  
  if (_isSvgAsset(emoji)) {
    
    return ReactionEmoji(path: emoji, size: size);
  }
  return Text(emoji, style: TextStyle(fontSize: size));
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
            if (isHovering)
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            AnimatedScale(
              duration: const Duration(milliseconds: 150),
              scale: isHovering ? 1.4 : 1.0,
              curve: Curves.easeOutBack,
              child: _buildEmojiWidget(emoji, 24),
            ),
          ],
        ),
      ),
    ),
  );
}