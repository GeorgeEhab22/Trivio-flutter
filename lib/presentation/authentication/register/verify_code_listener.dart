import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyCodeListener {
  static void handleStateChanges(BuildContext context, VerifyCodeState state) {
    final l10n = AppLocalizations.of(context)!;

    if (state is VerifyCodeSuccess) {
      showCustomSnackBar(context, l10n.verificationSuccess, true);
      context.go(AppRoutes.signIn);
    } else if (state is VerifyCodeError) {
      showCustomSnackBar(context, state.message, false);
    } else if (state is VerifyCodeResent) {
      showCustomSnackBar(context, l10n.codeResent, true);
    }
  }
}