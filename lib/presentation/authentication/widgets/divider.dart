import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SignInDivider extends StatelessWidget {
  const SignInDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        const Expanded(child: Divider()),
        const SizedBox(width: 10),
        Text(
          l10n.orDivider, 
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider()),
      ],
    );
  }
}