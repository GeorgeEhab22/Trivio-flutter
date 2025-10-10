import 'package:auth/presentation/authentication/widgets/code_box_list.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/forget_password_otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCodeBoxList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final VoidCallback? onComplete;

  const ForgetPasswordCodeBoxList({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordOTPCubit, ForgetPasswordOTPState>(
      builder: (context, state) {
        final isLoading = state is ForgetPasswordOTPLoading;
        return CodeBoxList(
          controllers: controllers,
          focusNodes: focusNodes,
          onComplete: onComplete,
          enabled: !isLoading,
        );
      },
    );
  }
}
