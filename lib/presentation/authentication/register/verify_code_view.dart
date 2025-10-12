import 'package:auth/common/basic_app_button.dart';
import 'package:auth/common/functions/code_box_handlers.dart';
import 'package:auth/constants/colors';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/register/verify_code_listener.dart';
import 'package:auth/presentation/authentication/widgets/change_email_button.dart';
import 'package:auth/presentation/authentication/widgets/verify_code_box_list.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_state.dart';
import 'package:flutter/material.dart';
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
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyCodeCubit, VerifyCodeState>(
      listener: (context, state) {
        VerifyCodeListener.handleStateChanges(context, state);

        if (state is VerifyCodeError) {
          CodeBoxHandlers.clearCode(_controllers, _focusNodes);
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VerifyCodeBoxList(
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                  ),
                ),
                const SizedBox(height: 48),
                BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
                  builder: (context, state) {
                    final isLoading = state is VerifyCodeLoading;
                    return BasicAppButton(
                      onPressed: isLoading
                          ? null
                          : () => CodeBoxHandlers.handleVerifyCode(
                              context,
                              _controllers,
                            ),
                      title: isLoading ? 'Verifying...' : 'Verify Code',
                    );
                  },
                ),
                const SizedBox(height: 24),
                ChangeEmailButton(isVerifying: true,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
