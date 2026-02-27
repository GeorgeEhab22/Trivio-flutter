import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:flutter/material.dart';

class CommentBodySection extends StatelessWidget {
  final bool isEditing;
  final TextEditingController editController;
  final String text;
  final AppLocalizations l10n;
  final VoidCallback onCancel;
  final ValueChanged<String> onSave;

  const CommentBodySection({
    super.key,
    required this.isEditing,
    required this.editController,
    required this.text,
    required this.l10n,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 56, end: 16),
      child: isEditing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: editController,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      child: Text(l10n.cancelBtn),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final updatedText = editController.text.trim();
                        if (updatedText.isEmpty) return;
                        onSave(updatedText);
                      },
                      child: Text(l10n.save),
                    ),
                  ],
                ),
              ],
            )
          : ExpandableText(
              text: text,
              previewLines: 2,
              canCollapse: false,
            ),
    );
  }
}
