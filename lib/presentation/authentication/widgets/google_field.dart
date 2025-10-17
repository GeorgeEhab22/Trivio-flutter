import 'package:auth/constants/paths.dart';
import 'package:auth/presentation/authentication/widgets/divider.dart';
import 'package:auth/presentation/authentication/widgets/social_auth_button.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/cubit/sign_in_cubit.dart';
import 'package:auth/services/social_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleField extends StatelessWidget {
  final bool isLogin;
  const GoogleField({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const SignInDivider(),
        const SizedBox(height: 20),
        SocialSignInButton(
          text: 'Sign in with Google',
          onPressed: () {
            SocialAuthService().googleSignInHandler(() {
              if (isLogin) {
                context.read<SignInCubit>().signInAndRegisterWithGoogle();
              }
            });
          },
          logo: Paths.kGoogleLogo,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
