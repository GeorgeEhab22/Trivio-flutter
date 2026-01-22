import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class MessagesItem extends StatelessWidget {
  final int index;
  const MessagesItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showCustomDialog(
                context: context,
                title: "Mute chat",
                content: "Are you sure you want to mute this chat?",
                confirmText: "Mute",
                onConfirm: () {
                  // TODO: Handle mute action
                },
              );
            },
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.notifications_off,
            label: 'Mute',
          ),
          SlidableAction(
            onPressed: (context) {
              showCustomDialog(
                context: context,
                title: "Delete Chat",
                content: "Are you sure you want to delete this chat?",
                confirmText: "Delete",
                confirmTextColor: Colors.red,
                onConfirm: () {
                  // TODO: Handle delete action
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      //TODO: change all actual data later
      child: ListTile(
        onTap: () {
          context.push('/app/messages/chat');
        },
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ],
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
          crossAxisAlignment: CrossAxisAlignment.end,
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
