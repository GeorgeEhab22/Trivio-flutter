import 'package:auth/common/basic_app_button.dart';
import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/register/verify_code_listener.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/authentication/widgets/code_box.dart';
import 'package:auth/presentation/manager/register_cubit/cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/cubit/verify_code_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;
  const VerifyCodePage({super.key, required this.email});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    context.read<VerifyCodeCubit>().startResendTimer();

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

  void _handleVerifyCode() {
    String code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      context.read<VerifyCodeCubit>().verify(code);
    } else {
      showCustomSnackBar(context, 'Please enter all 6 digits', false);
    }
  }

  void _onCodeChanged(String value, int index) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (index == 5 && value.isNotEmpty) {
      _handleVerifyCode();
    }
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyCodeCubit, VerifyCodeState>(
      listener: (context, state) {
        VerifyCodeListener.handleStateChanges(context, state);

        if (state is VerifyCodeError) {
          _clearCode();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
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
                Text('Verification Code', style: Styles.textStyle30),
                const SizedBox(height: 12),
                Text(
                  'Enter the 6-digit code sent to',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width > 400 ? 8 : 4,
                      ),
                      child: BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
                        builder: (context, state) {
                          final isLoading = state is VerifyCodeLoading;
                          return CodeBox(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            onChanged: (value) => _onCodeChanged(value, index),
                            onKeyEvent: (event) => _onKeyEvent(event, index),
                            enabled: !isLoading,
                          );
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 48),
                BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
                  builder: (context, state) {
                    final isLoading = state is VerifyCodeLoading;
                    return BasicAppButton(
                      onPressed: isLoading ? null : _handleVerifyCode,
                      title: isLoading ? 'Verifying...' : 'Verify Code',
                    );
                  },
                ),
                const SizedBox(height: 24),
                _ResendCodeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResendCodeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
      builder: (context, state) {
        final cubit = context.read<VerifyCodeCubit>();
        final isResending = state is VerifyCodeResending;
        final countdown = cubit.resendCountdown;
        final canResend = cubit.canResend;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: (canResend && !isResending)
                  ? () => cubit.resend()
                  : null,
              child: Text(
                isResending
                    ? 'Resending...'
                    : canResend
                        ? 'Resend'
                        : 'Resend in ${countdown}s',
                style: TextStyle(
                  color: (canResend && !isResending)
                      ? AppColors.primary
                      : Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
