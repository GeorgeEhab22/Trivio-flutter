import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordOtpListener {
  static void handleStateChanges(BuildContext context, ForgetPasswordOTPState state) {
    final l10n = AppLocalizations.of(context)!;

    if (state is ForgetPasswordOTPSuccess) {
      showCustomSnackBar(context, l10n.otpVerifiedSuccess, true);
      context.replace(AppRoutes.signIn); 
    } else if (state is ForgetPasswordOTPFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}