import 'package:auth/common/functions/custom_square_button.dart';
import 'package:flutter/material.dart';

class PendingPostsView extends StatelessWidget {
  const PendingPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(title: const Text('Pending Posts')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSquareButton(
                    onTap: () {
                      // TODO : Approve Post and hide it from ui pending posts
                    },
                    label: "Approve",
                    row: true,
                    leadingIcon: Icons.check,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomSquareButton(
                    onTap: () {
                      // TODO : Remove post and hide it from ui pending posts
                    },
                    label: "Decline",
                    row: true,
                    leadingIcon: Icons.close,
                  ),
                ),
              ],
            ),
            // TODO : Add pOsts Card
          ],
        ),
      ),
    );
  }
}
