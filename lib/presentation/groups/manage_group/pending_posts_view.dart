import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PendingPostsView extends StatelessWidget {
  const PendingPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(title: Text(l10n.pendingPosts)),
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
                    label: l10n.approve,
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
                    label: l10n.decline,
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