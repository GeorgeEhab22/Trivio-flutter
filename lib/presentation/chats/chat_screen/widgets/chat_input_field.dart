import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/chats/chat_screen/widgets/other_sending_options.dart';
import 'package:flutter/material.dart';
import 'package:auth/l10n/app_localizations.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => showAddOtherOptions(context),
            icon: const Icon(Icons.add, color: AppColors.primary),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 45,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.messageHint, // Localized
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mic, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}