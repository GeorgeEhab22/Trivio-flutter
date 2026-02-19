import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> copyToClipboard(BuildContext context, String text) async {
    final l10n = AppLocalizations.of(context)!;

  await Clipboard.setData(ClipboardData(text: text));
  
  if (context.mounted) {
    showCustomSnackBar(context, l10n.copied, true);
  }
}