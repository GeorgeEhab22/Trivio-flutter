import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_state.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInListener {
  static void handleStateChanges(BuildContext context, SignInState state) {
    if (state is SignInSuccess) {
      showCustomSnackBar(context, 'Welcome back!', true);
      context.go(AppRoutes.home);
    } else if (state is SignInFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}
