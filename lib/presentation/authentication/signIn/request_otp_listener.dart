
import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_state.dart';
import 'package:flutter/material.dart';

class RequestOTPListener {
  static void handleStateChanges(
    BuildContext context,
    RequestOTPState state,
    String email,
  ) {
    if (state is RequestOTPSuccess) {
      showCustomSnackBar(context, 'Email sent successfully!', true);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.forgetPasswordOtp,
        arguments: email,
        (route) => false,
      );
    } else if (state is RequestOTPFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}
