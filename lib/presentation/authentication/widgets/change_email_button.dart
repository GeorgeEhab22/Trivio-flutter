import 'package:auth/constants/colors';
import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_state.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangeEmailButton extends StatelessWidget {
  final bool isVerifying;
  const ChangeEmailButton({super.key, required this.isVerifying});

  @override
  Widget build(BuildContext context) {
    return isVerifying
        ? BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
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
                            AppRoutes.changeEmailVerification,
                            extra: {'username': cubit.username, 'cubit': cubit},
                          ),
                    child: Text(
                      canResend
                          ? 'Change email'
                          : 'Can change in ${countdown}s',
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
          )
        : BlocBuilder<RequestOTPCubit, RequestOTPState>(
            builder: (context, state) {
              final cubit = context.read<RequestOTPCubit>();
              final isResending = state is RequestOTPResent;
              final countdown = cubit.resendCountdown;
              final canResend = cubit.canResend;

              final isDisabled = !canResend || isResending;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the OTP? ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  TextButton(
                    onPressed: isDisabled
                        ? null
                        : () => context.push(
                            AppRoutes.changeEmailOTP,
                            extra: {'username': '', 'cubit': cubit},
                          ),
                    child: Text(
                      canResend
                          ? 'Change email'
                          : 'Can change in ${countdown}s',
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
