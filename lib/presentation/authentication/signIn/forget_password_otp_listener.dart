import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';

class ForgetPasswordOtpListener {
  static void handleStateChanges(BuildContext context, ForgetPasswordOTPState state) {
    if (state is ForgetPasswordOTPSuccess) {
      showCustomSnackBar(context, 'OTP verified successfully!', true);
      Navigator.pushReplacementNamed(context, '/signin');
    } else if (state is ForgetPasswordOTPFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}
