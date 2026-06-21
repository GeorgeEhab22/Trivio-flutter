import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/l10n/app_localizations.dart';

class MessagesItem extends StatelessWidget {
  final int index;
  const MessagesItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColors = isDark
        ? const [Color(0xFF1D2228), Color(0xFF171B20)]
        : const [Color(0xFFFFFFFF), Color(0xFFF8FBF9)];

    final bool isUnread = index == 0 || index == 1;

    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showCustomDialog(
                context: context,
                title: l10n.muteChatTitle,
                content: l10n.muteChatConfirm,
                confirmText: l10n.mute,
                onConfirm: () {
                  // TODO: Handle mute action
                },
              );
            },
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.notifications_off,
            label: l10n.mute,
          ),
          SlidableAction(
            onPressed: (context) {
              showCustomDialog(
                context: context,
                title: l10n.deleteChatTitle,
                content: l10n.deleteChatConfirm,
                confirmText: l10n.delete,
                confirmTextColor: Colors.red,
                onConfirm: () {
                  // TODO: Handle delete action
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: l10n.delete,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bgColors,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black12 : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              if (isUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 100, 
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark 
                              ? AppColors.primary.withValues(alpha: 0.12) 
                              : AppColors.primary.withValues(alpha: 0.08),
                          Colors.transparent
                        ],
                        begin: Alignment.centerRight, 
                        end: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
              
              ListTile(
                onTap: () {
                  context.push(AppRoutes.chat);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: isDark ? const Color(0xFF2C3138) : Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                title: Text(
                  "Alex Johnson", 
                  style: Styles.textStyle16.copyWith(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  )
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Hey, let's catch up later!",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.textStyle14.copyWith(
                      color: isUnread 
                          ? (isDark ? Colors.white70 : Colors.black87)
                          : (isDark ? Colors.white54 : Colors.black54),
                      fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "10:30 AM", 
                      style: Styles.textStyle14.copyWith(
                        color: isUnread 
                            ? AppColors.primary 
                            : (isDark ? Colors.white38 : Colors.black38),
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                      )
                    ),
                    if (isUnread) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}