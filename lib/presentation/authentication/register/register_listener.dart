import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/register_cubit/register_state.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterListener {
  static void handleStateChanges(BuildContext context, RegisterState state) {
    final l10n = AppLocalizations.of(context)!; 

    if (state is RegisterSuccess) {
      showCustomSnackBar(
        context,
        l10n.registrationSuccess(state.user.username), 
        true,
      );
      context.go(
        AppRoutes.verifyCode,
        extra: {'email': state.user.email, 'username': state.user.username},
      );
    } else if (state is RegisterFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}