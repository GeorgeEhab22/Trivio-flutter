import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:flutter/material.dart';

class ChatInfoView extends StatelessWidget {
  const ChatInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(surfaceTintColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 15),
            const Text(
              "User Name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRowButtons(context, Icons.call, "Call", () {
                  showCustomDialog(
                    context: context,
                    title: "Calling...",
                    content: "Call \"user name\"",
                    confirmText: "Call",
                    onConfirm: () {
                      //TODO: later add call functionality
                    },
                  );
                }),
                const SizedBox(width: 30),
                _buildRowButtons(context, Icons.videocam, "Video", () {
                  showCustomDialog(
                    context: context,
                    title: "Video Calling...",
                    content: "Video Call \"user name\"",
                    confirmText: "Call",
                    onConfirm: () {
                      //TODO: later add video call functionality
                    },
                  );
                }),
                const SizedBox(width: 30),
                _buildRowButtons(context, Icons.person, "Profile", () {
                  // TODO : add go to profile
                }),
                const SizedBox(width: 30),
                _buildRowButtons(context, Icons.notifications, "Mute", () {
                  // TODO : add mute functionality
                }),
              ],
            ),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Options",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            _buildColumnButtons(context, Icons.group, "Create Group Chat", () {
              //TODO :add group chat functionality
            }),
            SizedBox(height: 10),
            _buildColumnButtons(context, Icons.block, "Block", () {
              showCustomDialog(
                context: context,
                title: "Block User",
                content: "Are you sure you want to block this user?",
                confirmText: "Block",
                confirmTextColor: Colors.red,
                onConfirm: () {
                  //TODO: later add block functionality
                },
              );
            }),
            SizedBox(height: 10),
            _buildColumnButtons(context, Icons.report, "Report", () {
              //TODO : show report list and add functionality
            }),
            SizedBox(height: 10),
            _buildColumnButtons(context, Icons.delete, "Delete Chat", () {
              showCustomDialog(
                context: context,
                title: "Delete Chat",
                content: "Are you sure you want to delete this chat?",
                confirmText: "Delete",
                confirmTextColor: Colors.red,
                onConfirm: () {
                  //TODO: later add delete functionality
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRowButtons(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).cardColor,
          child: IconButton(
            icon: Icon(
              icon,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildColumnButtons(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).iconTheme.color, size: 25),
            const SizedBox(width: 15),
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
