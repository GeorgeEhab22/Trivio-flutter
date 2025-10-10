import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/auth_action_button.dart';
import 'package:auth/presentation/authentication/widgets/forget_password.dart';
import 'package:auth/presentation/authentication/widgets/google_and_apple_fields.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/new_account.dart';
import 'sign_in_listener.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      context.read<SignInCubit>().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) =>
            SignInListener.handleStateChanges(context, state),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Sign in', style: Styles.textStyle30),
                const SizedBox(height: 60),
                EmailField(controller: _emailController, isLogin: true),
                const SizedBox(height: 20),
                PasswordField(
                  isLogin: true,
                  controller: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  onSubmit: _handleSignIn,
                ),
                const SizedBox(height: 20),
                AuthActionButton<SignInCubit, SignInState, SignInLoading>(
                  onPressed: _handleSignIn,
                  title: "Sign In",
                  loadingText: "Signing In...",
                  isLoading: (state) => state is SignInLoading,
                ),
                const GoogleAndAppleFields(isLogin: true),
                const SizedBox(height: 40),
                const ForgetPassword(),
                const NewAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
