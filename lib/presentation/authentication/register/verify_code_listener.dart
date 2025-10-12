import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyCodeListener {
  static void handleStateChanges(BuildContext context, VerifyCodeState state) {
    if (state is VerifyCodeSuccess) {
      showCustomSnackBar(context, 'Verification successful!', true);

     context.go(AppRoutes.signIn);

    } else if (state is VerifyCodeError) {
      showCustomSnackBar(context, state.message, false);
    } else if (state is VerifyCodeResent) {
      showCustomSnackBar(context, 'Verification code sent!', true);
    }
  }
}
