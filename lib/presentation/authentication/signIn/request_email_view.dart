import 'package:auth/common/basic_app_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/signIn/request_email_listener.dart';
import 'package:auth/presentation/authentication/widgets/email_field.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_state.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RequestEmailView extends StatefulWidget {
  final bool isForVerification;
  final String username;
  const RequestEmailView({
    super.key,
    this.isForVerification = false,
    required this.username,
  });

  @override
  State<RequestEmailView> createState() => _RequestEmailViewState();
}

class _RequestEmailViewState extends State<RequestEmailView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();

    if (widget.isForVerification) {
      context.read<VerifyCodeCubit>().resend(email);
    } else {
      context.read<RequestOTPCubit>().sendOtp(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isForVerification = widget.isForVerification;

    final title = isForVerification ? l10n.resendCodeTitle : l10n.forgotPasswordTitle;
    final description = isForVerification ? l10n.resendCodeDesc : l10n.forgotPasswordDesc;
    final buttonText = isForVerification ? l10n.resendBtn : l10n.sendOtpBtn;
    final loadingText = isForVerification ? l10n.resending : l10n.sending;

    final icon = isForVerification
        ? Icons.mark_email_unread_rounded
        : Icons.lock_reset_rounded;

    if (isForVerification) {
      return BlocListener<VerifyCodeCubit, VerifyCodeState>(
        listener: (context, state) {
          if (state is VerifyCodeResent) {
            showCustomSnackBar(context, l10n.codeResent, true);
            context.pop();
          } else if (state is VerifyCodeError) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        child: _buildBody(context, icon, title, description, buttonText, loadingText, isForVerification: true),
      );
    } else {
      return BlocListener<RequestOTPCubit, RequestOTPState>(
        listener: (context, state) {
          RequestEmailListener.handleStateChanges(
            context,
            state,
            _emailController.text.trim(),
          );
        },
        child: _buildBody(context, icon, title, description, buttonText, loadingText, isForVerification: false),
      );
    }
  }

  Widget _buildBody(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String buttonText,
    String loadingText, {
    required bool isForVerification,
  }) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 60, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 40),
                Text(title, style: Styles.textStyle30),
                const SizedBox(height: 12),
                Text(description, style: Styles.textStyle14),
                const SizedBox(height: 40),
                EmailField(controller: _emailController, isLogin: false),
                const SizedBox(height: 32),
                isForVerification
                    ? BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
                        builder: (context, state) {
                          final isLoading = state is VerifyCodeLoading;
                          return BasicAppButton(
                            onPressed: isLoading ? null : _handleSubmit,
                            title: isLoading ? loadingText : buttonText,
                          );
                        },
                      )
                    : BlocBuilder<RequestOTPCubit, RequestOTPState>(
                        builder: (context, state) {
                          final isLoading = state is RequestOTPLoading;
                          return BasicAppButton(
                            onPressed: isLoading ? null : _handleSubmit,
                            title: isLoading ? loadingText : buttonText,
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}