import 'package:auth/constants/paths.dart';
import 'package:auth/presentation/authentication/widgets/divider.dart';
import 'package:auth/presentation/authentication/widgets/social_auth_button.dart';
import 'package:auth/presentation/manager/register_cubit/cubit/register_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleAndAppleFields extends StatelessWidget {
  final bool isLogin;
  const GoogleAndAppleFields({super.key, required this.isLogin});

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
          onPressed: () => isLogin
              ? context.read<SignInCubit>().signInWithGoogle()
              : context.read<RegisterCubit>().registerWithGoogle(),
          logo: Paths.kGoogleLogo,
        ),
        const SizedBox(height: 20),
        SocialSignInButton(
          text: 'Sign in with Apple',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          onPressed: () => isLogin
              ? context.read<SignInCubit>().signInWithApple()
              : context.read<RegisterCubit>().registerWithApple(),
          logo: Paths.kAppleLogo,
        ),
      ],
    );
  }
}
