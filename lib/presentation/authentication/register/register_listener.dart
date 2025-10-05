import 'package:auth/presentation/manager/register_cubit/cubit/register_state.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterListener {
  static void handleStateChanges(BuildContext context, RegisterState state) {
    if (state is RegisterSuccess) {
      showCustomSnackBar(
        context,
        'Welcome, ${state.user.username}! Your account has been created.',
        true,
      );
      Navigator.pushReplacementNamed(context, '/home'); 
    } else if (state is RegisterFailure) {
      showCustomSnackBar(context, state.message, false);
    }
  }
}
