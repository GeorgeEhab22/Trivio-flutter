import 'package:flutter/material.dart';
import 'package:auth/l10n/app_localizations.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? replyingToUser;
  final VoidCallback onCancelReply;
  final ValueChanged<String> onSubmitted;

  const CommentInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCancelReply,
    required this.onSubmitted,
    this.replyingToUser,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelColor = isDark ? const Color(0xFF171C23) : const Color(0xFFF4F8F5);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.11)
        : Colors.black.withValues(alpha: 0.08);

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: panelColor,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (replyingToUser != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.white,
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.reply_rounded,
                          size: 15,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l10n.replyingTo(replyingToUser!),
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onCancelReply,
                          child: const Icon(Icons.close, size: 18),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: isDark ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.07)
                              : Colors.white,
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.black.withValues(alpha: 0.07),
                          ),
                        ),
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          textInputAction: TextInputAction.send,
                          decoration: InputDecoration(
                            hintText: l10n.addCommentHint,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: onSubmitted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller,
                      builder: (context, value, child) {
                        final bool isNotEmpty = value.text.trim().isNotEmpty;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isNotEmpty
                                ? const LinearGradient(
                                    colors: [Color(0xFF42C83C), Color(0xFF7BDC5B)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: isNotEmpty
                                ? null
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.12)
                                    : Colors.black.withValues(alpha: 0.09)),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.send_rounded,
                              size: 18,
                              color: isNotEmpty ? Colors.white : Colors.grey,
                            ),
                            onPressed: isNotEmpty
                                ? () => onSubmitted(controller.text)
                                : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
