import 'package:flutter/material.dart';

class ReplyTreeWrapper extends StatelessWidget {
  final Widget child;
  final bool showReplyTree;
  final bool isLastReplyInThread;
  final Color replyBackgroundColor;

  const ReplyTreeWrapper({
    super.key,
    required this.child,
    required this.showReplyTree,
    required this.isLastReplyInThread,
    required this.replyBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!showReplyTree) {
      return Container(
        margin: const EdgeInsetsDirectional.only(start: 40, bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: replyBackgroundColor,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.07),
          ),
        ),
        child: child,
      );
    }

    final treeColor = theme.colorScheme.outlineVariant.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.55 : 0.75,
    );

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, bottom: 8),
      child: Stack(
        children: [
          PositionedDirectional(
            start: 8,
            top: 0,
            bottom: isLastReplyInThread ? null : 0,
            child: Container(
              width: 1.2,
              height: isLastReplyInThread ? 24 : null,
              color: treeColor,
            ),
          ),
          PositionedDirectional(
            start: 8,
            top: 24,
            child: Container(
              width: 16,
              height: 1.2,
              color: treeColor,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: replyBackgroundColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.07),
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
