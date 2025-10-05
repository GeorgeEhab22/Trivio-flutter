import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/common/basic_app_button.dart';

/// A generic button for auth actions (Sign in, Register, Forgot Password, etc.)
class AuthActionButton<C extends StateStreamable<S>, S, L> extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String loadingText;
  final bool Function(S state) isLoading;

  const AuthActionButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.loadingText,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
      builder: (context, state) {
        final loading = isLoading(state);

        return BasicAppButton(
          onPressed: loading ? null : onPressed,
          title: loading ? loadingText : title,
        );
      },
    );
  }
}
