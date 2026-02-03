import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class MembersRequestsListView extends StatelessWidget {
  const MembersRequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members requests')),
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage('https://picsum.photos/500'),
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text("Member name", style: Styles.textStyle16),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      showCustomDialog(
                        context: context,
                        title: "Accept this member?",
                        onConfirm: () {
                          //TODO: add accept member logic
                        },
                        content: "Are you sure you want to accept this member?",
                      );
                    },
                    icon: Icon(Icons.check),
                  ),
                  IconButton(
                    onPressed: () {
                      showCustomDialog(
                        context: context,
                        title: "Decline this member?",
                        confirmText: "Decline",
                        confirmTextColor: Colors.red,
                        onConfirm: () {
                          //TODO: add decline member logic
                        },
                        content:
                            "Are you sure you want to decline this member?",
                      );
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
