import 'package:auth/domain/entities/reaction_type.dart';
import 'package:flutter/material.dart';

OverlayEntry buildReactionsOverlay({
  required Offset position,
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
      return StatefulBuilder(
        builder: (context, setOverlayState) {
          return Positioned(
            // TODO : handle the right position
            left: position.dx - 20, 
            top: position.dy - 55, 
            child: MouseRegion(
              onEnter: (_) => onHoverChange(true),
              onExit: (_) => onHoverChange(false),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(emojiList.length, (index) {
                      bool isHovering = hoveringReaction == reactionList[index];
                      return _buildReactionItem(
                        emoji: emojiList[index],
                        label: reactionNames[index],
                        isHovering: isHovering,
                        onHover: (hovering) {
                           onHoverChange(hovering);
                           setOverlayState(() {
                             hoveringReaction = hovering ? reactionList[index] : null;
                           });
                        },
                        onTap: () => onReactionSelected(reactionList[index]),
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        },
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
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             if(isHovering)
               Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
             
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