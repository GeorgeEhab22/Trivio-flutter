import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeBoxHandlers {
  static void onCodeChanged(
    String value,
    int index,
    List<FocusNode> focusNodes,
    List<TextEditingController> controllers,
    BuildContext context,
    VoidCallback? onComplete, 
  ) {
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    } else if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (index == 5 && value.isNotEmpty) {
      handleVerifyCode(context, controllers); 
    }
  }

  static void onKeyEvent(
    KeyEvent event,
    int index,
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
  ) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        controllers[index].text.isEmpty &&
        index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  static void clearCode(
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
  ) {
    for (var controller in controllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  static void handleVerifyCode(
    BuildContext context,
    List<TextEditingController> controllers,
  ) {
    String code = controllers.map((c) => c.text).join();
    if (code.length == 6) {
      context.read<VerifyCodeCubit>().verify(code);
    } else {
      showCustomSnackBar(context, 'Please enter all 6 digits', false);
    }
  }
}