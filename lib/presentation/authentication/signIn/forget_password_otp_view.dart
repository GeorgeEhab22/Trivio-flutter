import 'package:auth/common/basic_app_button.dart';
import 'package:auth/common/functions/code_box_handlers.dart';
import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/signIn/forget_password_otp_listener.dart';
import 'package:auth/presentation/authentication/widgets/change_email_button.dart';
import 'package:auth/presentation/authentication/widgets/forget_password_code_box_list.dart';
import 'package:auth/presentation/authentication/widgets/password_field.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordOtp extends StatefulWidget {
  final String email;

  const ForgetPasswordOtp({super.key, required this.email});

  @override
  State<ForgetPasswordOtp> createState() => _ForgetPasswordOtpState();
}

class _ForgetPasswordOtpState extends State<ForgetPasswordOtp> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
context.read<RequestOTPCubit>().startResendTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleNewPassword() {
    if (_formKey.currentState!.validate()) {
      final otp = _controllers.map((c) => c.text).join();
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;
      context.read<ForgetPasswordOTPCubit>().verifyOtp(
        otp,
        widget.email,
        password,
        confirmPassword,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordOTPCubit, ForgetPasswordOTPState>(
      listener: (context, state) {
        ForgetPasswordOtpListener.handleStateChanges(context, state);
        if (state is ForgetPasswordOTPFailure) {
          CodeBoxHandlers.clearCode(_controllers, _focusNodes);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],

        body: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text('OTP', style: Styles.textStyle30),

                  const SizedBox(height: 12),

                  Text(
                    'Enter the 6-digit OTP sent to',
                    style: Styles.textStyle14.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.email,
                    style: Styles.textStyle14.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  ForgetPasswordCodeBoxList(
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                    onComplete: _handleNewPassword,
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    controller: _passwordController,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                    onSubmit: _handleNewPassword,
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
                    onSubmit: _handleNewPassword,
                    label: "Confirm Password",
                    hint: "Re-enter your password",
                    isConfirm: true,
                  ),

                  const SizedBox(height: 48),

                  BlocBuilder<ForgetPasswordOTPCubit, ForgetPasswordOTPState>(
                    builder: (context, state) {
                      final isLoading = state is ForgetPasswordOTPLoading;
                      return BasicAppButton(
                        onPressed: isLoading
                            ? null
                            : () => _handleNewPassword(),
                        title: isLoading ? 'resetting...' : 'reset password',
                      );
                    },
                  ),
                  ChangeEmailButton(isVerifying: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
