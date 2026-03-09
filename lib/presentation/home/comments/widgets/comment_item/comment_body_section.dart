import 'package:auth/constants/colors.dart';
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14.5,
          height: 1.45,
          fontWeight: FontWeight.w500,
        );

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 56, end: 16, bottom: 2),
      child: isEditing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  cursorColor: AppColors.primary,
                  controller: editController,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.black.withValues(alpha: 0.025),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.65),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
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
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(
                          AppColors.primary,
                        ),
                      ),
                      onPressed: onCancel,
                      child: Text(l10n.cancelBtn),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? const Color(0xFF171B20) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final updatedText = editController.text.trim();
                        if (updatedText.isEmpty) return;
                        onSave(updatedText);
                      },
                      child: Text(
                        l10n.save,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : ExpandableText(
              text: text,
              previewLines: 2,
              canCollapse: false,
              textStyle: bodyStyle,
            ),
    );
  }
}
