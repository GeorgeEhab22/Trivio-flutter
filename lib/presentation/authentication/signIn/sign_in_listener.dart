import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_state.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInListener {
  static void handleStateChanges(BuildContext context, SignInState state) {
    final l10n = AppLocalizations.of(context)!;

    if (state is SignInSuccess) {
      context.go(AppRoutes.selectTeams);
    } else if (state is SignInFailure) {
      String errorMessage = state.message;

      if (state.message == "cancelled") {
        errorMessage = l10n.googleSignInCancelled;
      } else if (state.message == "failed") {
        errorMessage = l10n.googleSignInFailed;
      }

      showCustomSnackBar(context, errorMessage, false);
    }
  }
}
