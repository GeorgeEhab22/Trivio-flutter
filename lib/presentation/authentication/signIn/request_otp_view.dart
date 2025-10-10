import 'package:auth/common/basic_app_button.dart';
import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/signIn/request_otp_listener.dart';
import 'package:auth/presentation/authentication/widgets/email_field.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestOTPView extends StatefulWidget {
  const RequestOTPView({super.key});

  @override
  State<RequestOTPView> createState() => _RequestOTPViewState();
}

class _RequestOTPViewState extends State<RequestOTPView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleVerifyCode() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      context.read<RequestOTPCubit>().sendOtp(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestOTPCubit, RequestOTPState>(
      listener: (context, state) {
        RequestOTPListener.handleStateChanges(
          context,
          state,
          _emailController.text.trim(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text('Forgot Password?', style: Styles.textStyle30),

                  const SizedBox(height: 12),

                  Text(
                    'Don\'t worry! It happens. Please enter the email address associated with your account.',
                    style: Styles.textStyle14,
                  ),

                  const SizedBox(height: 40),

                  EmailField(controller: _emailController, isLogin: false),

                  const SizedBox(height: 32),

                  BlocBuilder<RequestOTPCubit, RequestOTPState>(
                    builder: (context, state) {
                      final isLoading = state is RequestOTPLoading;
                      return BasicAppButton(
                        onPressed: isLoading ? null : _handleVerifyCode,
                        title: isLoading ? 'Sending...' : 'Send OTP',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
