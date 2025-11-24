import 'package:flutter/material.dart';
import 'reaction_button.dart';

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
            left: position.dx - 10,
            top: position.dy - 60,
            child: MouseRegion(
              onEnter: (_) => onHoverChange(true),
              onExit: (_) => onHoverChange(false),
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // White container holding the emoji reactions
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
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
                          bool isHovering =
                              hoveringReaction == reactionList[index];
                          return MouseRegion(
                            onEnter: (_) {
                              onHoverChange(true);
                              setOverlayState(
                                () => hoveringReaction = reactionList[index],
                              );
                            },
                            onExit: (_) {
                              onHoverChange(false);
                              setOverlayState(() => hoveringReaction = null);
                            },
                            child: GestureDetector(
                              onTap: () =>
                                  onReactionSelected(reactionList[index]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 150),
                                  scale: isHovering ? 1.3 : 1.0,
                                  curve: Curves.easeOutBack,
                                  child: Text(
                                    emojiList[index],
                                    style: TextStyle(
                                      fontSize: isHovering ? 32 : 26,
                                      shadows: isHovering
                                          ? [
                                              const Shadow(
                                                color: Colors.black26,
                                                blurRadius: 5,
                                                offset: Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Reaction names displayed above the emojis
                    Positioned(
                      top: -20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(reactionNames.length, (index) {
                          bool isHovering =
                              hoveringReaction == reactionList[index];
                          return Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 150),
                              opacity: isHovering ? 1.0 : 0.0,
                              child: Center(
                                child: isHovering
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          reactionNames[index],
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
