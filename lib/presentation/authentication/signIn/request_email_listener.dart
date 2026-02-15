import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestEmailListener {
  static void handleStateChanges(
    BuildContext context,
    RequestOTPState state,
    String email,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (state is RequestOTPSuccess) {
      showCustomSnackBar(
        context,
        l10n.passwordResetSent, 
        true,
      );

      context.go(AppRoutes.forgetPasswordOtp, extra: email);
    } else if (state is RequestOTPFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}