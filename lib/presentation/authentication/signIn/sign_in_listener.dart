import 'package:auth/presentation/manager/sigin_in_cubit/cubit/sign_in_state.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';

class SignInListener {
  static void handleStateChanges(BuildContext context, SignInState state) {
    if (state is SignInSuccess) {
      showCustomSnackBar(context, 'Welcome back!', true);
      Navigator.pushReplacementNamed(context, '/home');
    } else if (state is SignInFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}
