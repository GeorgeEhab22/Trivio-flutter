import 'package:flutter/material.dart';
import 'package:auth/l10n/app_localizations.dart';

class ErrorParser {
  static String localizeError(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;

    switch (key) {
      // General & Network
      case 'no_internet':
        return l10n.no_internet;
      case 'unexpected_error':
        return l10n.unexpected_error;
      case 'server_error':
        return l10n.serverError;

      // Authentication
      case 'user_not_found':
        return l10n.user_not_found;
      case 'invalid_credentials':
      case 'wrong_password':
        return l10n.wrong_password;
      case 'email_taken':
        return l10n.email_taken;
      case 'username_taken':
        return l10n.username_taken;

      // OTP & Verification
      case 'invalid_code':
        return l10n.invalid_code;
      case 'code_expired':
        return l10n.code_expired;
      case 'too_many_attempts':
        return l10n.too_many_attempts;
      case 'token_not_found':
        return l10n.sessionError;

      // Group & Comments
      case 'load_failed':
        return l10n.commentLoadError;
      case 'add_failed':
        return l10n.commentAddError;
      case 'delete_failed':
        return l10n.commentDeleteError;
      case 'already_member':
        return l10n.alreadyMemberError;
      case 'cancel_failed':
        return l10n.cancelRequestError;

      default:
        // If the backend sends a raw message not in our keys,
        // we show the raw message for debugging.
        return key;
    }
  }
}
