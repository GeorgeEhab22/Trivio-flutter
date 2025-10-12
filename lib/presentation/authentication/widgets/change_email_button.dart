import 'package:auth/constants/colors';
import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangeEmailButton extends StatelessWidget {
  const ChangeEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
      builder: (context, state) {
        final cubit = context.read<VerifyCodeCubit>();
        final isResending = state is VerifyCodeResending;
        final countdown = cubit.resendCountdown;
        final canResend = cubit.canResend;

        final isDisabled = !canResend || isResending;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive the code? ",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            TextButton(
              onPressed: isDisabled
                  ? null 
                  : () => context.push(
                      AppRoutes.changeEmail,
                      extra: {'username': cubit.username,'cubit': cubit},
                    ),
              child: Text(
                canResend ? 'Change email' : 'Can change in ${countdown}s',
                style: TextStyle(
                  color: isDisabled ? Colors.grey : AppColors.primary,
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
