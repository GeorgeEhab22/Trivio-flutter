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

    return Slidable(
      key: ValueKey(index),
      // Slidable automatically handles the sliding direction for RTL/LTR
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
      child: ListTile(
        onTap: () {
          context.push(AppRoutes.chat);
        },
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.grey),
        ),
        title: const Text("User Name", style: Styles.textStyle15),
        subtitle: const Text(
          " preview of the last message until doing real chat...",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Styles.textStyle14,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end, // Aligns to logical end
          children: [
            const Text("3:45 PM", style: Styles.textStyle14),
            const SizedBox(height: 8),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}