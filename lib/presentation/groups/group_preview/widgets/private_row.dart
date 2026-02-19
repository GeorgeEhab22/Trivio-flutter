import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrivateRow extends StatelessWidget {
  const PrivateRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        const Icon(Icons.lock_outline, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            l10n.privateGroupDescription,
            style: Styles.textStyle14.copyWith(color: Colors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}