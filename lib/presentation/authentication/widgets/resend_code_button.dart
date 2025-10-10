import 'package:auth/constants/colors';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton({super.key});

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