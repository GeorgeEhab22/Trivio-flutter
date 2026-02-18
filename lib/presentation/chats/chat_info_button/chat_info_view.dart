import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:auth/l10n/app_localizations.dart';

class ChatInfoView extends StatelessWidget {
  const ChatInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const String dummyUserName = "User Name";

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
              dummyUserName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRowButtons(context, Icons.call, l10n.callAction, () {
                  showCustomDialog(
                    context: context,
                    title: l10n.calling,
                    content: l10n.callUser(dummyUserName),
                    confirmText: l10n.callAction,
                    onConfirm: () {
                      //TODO: later add call functionality
                    },
                  );
                }),
                const SizedBox(width: 30),
                _buildRowButtons(context, Icons.videocam, l10n.video, () {
                  showCustomDialog(
                    context: context,
                    title: l10n.videoCalling,
                    content: l10n.videoCallUser(dummyUserName),
                    confirmText: l10n.callAction,
                    onConfirm: () {
                      //TODO: later add video call functionality
                    },
                  );
                }),
                const SizedBox(width: 30),
                _buildRowButtons(context, Icons.person, l10n.profile, () {
                  // TODO : add go to profile
                }),
                const SizedBox(width: 30),
                _buildRowButtons(context, Icons.notifications, l10n.mute, () {
                  // TODO : add mute functionality
                }),
              ],
            ),
            const SizedBox(height: 30),

            Align(
              // AlignmentDirectional handles RTL automatically
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                child: Text(
                  l10n.options,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            _buildColumnButtons(context, Icons.group, l10n.createGroupChat, () {
              //TODO :add group chat functionality
            }),
            const SizedBox(height: 10),
            _buildColumnButtons(context, Icons.block, l10n.block, () {
              showCustomDialog(
                context: context,
                title: l10n.blockUserTitle,
                content: l10n.blockUserConfirm,
                confirmText: l10n.block,
                confirmTextColor: Colors.red,
                onConfirm: () {
                  //TODO: later add block functionality
                },
              );
            }),
            const SizedBox(height: 10),
            _buildColumnButtons(context, Icons.report, l10n.report, () {
              //TODO : show report list and add functionality
            }),
            const SizedBox(height: 10),
            _buildColumnButtons(context, Icons.delete, l10n.deleteChatTitle, () {
              showCustomDialog(
                context: context,
                title: l10n.deleteChatTitle,
                content: l10n.deleteChatConfirm,
                confirmText: l10n.delete,
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