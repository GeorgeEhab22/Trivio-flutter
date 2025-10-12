import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/auth_action_button.dart';
import 'package:auth/presentation/authentication/widgets/google_and_apple_fields.dart';
import 'package:auth/presentation/authentication/widgets/username_field.dart';
import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/already_have_account_button.dart';
import 'register_listener.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) =>
            RegisterListener.handleStateChanges(context, state),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Create Account', style: Styles.textStyle30),
                const SizedBox(height: 60),
                UsernameField(controller: _usernameController),
                const SizedBox(height: 20),
                EmailField(controller: _emailController, isLogin: false),
                const SizedBox(height: 20),
                PasswordField(
                  controller: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  onSubmit: _handleRegister,
                  label: "Password",
                  hint: "Enter your password",
                ),
                const SizedBox(height: 20),
                PasswordField(
                  controller: _confirmPasswordController,
                  originalController: _passwordController,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onVisibilityToggle: () {
                    setState(
                      () => _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible,
                    );
                  },
                  onSubmit: _handleRegister,
                  label: "Confirm Password",
                  hint: "Re-enter your password",
                  isConfirm: true,
                ),
                const SizedBox(height: 20),
                AuthActionButton<RegisterCubit, RegisterState, RegisterLoading>(
                  onPressed: _handleRegister,
                  title: "send code",
                  loadingText: "Sending code...",
                  isLoading: (state) => state is RegisterLoading,
                ),
                const GoogleAndAppleFields(isLogin: false),
                const SizedBox(height: 40),
                const AlreadyHaveAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
