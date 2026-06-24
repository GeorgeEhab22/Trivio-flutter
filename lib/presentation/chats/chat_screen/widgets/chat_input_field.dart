import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/chat_cubit/chat_messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:auth/presentation/chats/chat_screen/widgets/other_sending_options.dart';
import 'package:auth/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputField extends StatefulWidget {
  final String currentUserId;
  const ChatInputField({super.key, required this.currentUserId});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => showAddOtherOptions(context),
              icon: Icon(
                Icons.attach_file,
                color: isDark ? Colors.grey : Colors.black54,
              ),
            ),

            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    context.read<ChatMessagesCubit>().sendTypingEvent(
                      isTyping: true,
                    );
                  } else {
                    context.read<ChatMessagesCubit>().sendTypingEvent(
                      isTyping: false,
                    );
                  }
                },
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: l10n.typeMessageHint,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey : Colors.black54,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            AnimatedOpacity(
              opacity: _hasText ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: _hasText
                    ? () {
                        context.read<ChatMessagesCubit>().sendMessage(
                          _controller.text,
                          widget.currentUserId,
                        );

                        context.read<ChatMessagesCubit>().sendTypingEvent(
                          isTyping: false,
                        );

                        _controller.clear();
                      }
                    : null,
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: _hasText
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
