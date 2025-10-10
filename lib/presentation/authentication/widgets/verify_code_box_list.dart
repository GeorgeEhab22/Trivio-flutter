import 'package:auth/presentation/authentication/widgets/code_box_list.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodeBoxList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final VoidCallback? onComplete;

  const VerifyCodeBoxList({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
      builder: (context, state) {
        final isLoading = state is VerifyCodeLoading;
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
