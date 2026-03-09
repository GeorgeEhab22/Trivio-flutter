import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/register_cubit/verify_code_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeBoxHandlers {
  static void _requestFocusAfterBuild(FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
    });
  }

  static void _setControllerValue(TextEditingController controller, String value) {
    controller.text = value;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
  }

  static void _fillControllersFromIndex(
    String value,
    int startIndex,
    List<TextEditingController> controllers,
  ) {
    var target = startIndex;
    for (var i = 0; i < value.length && target < controllers.length; i++) {
      _setControllerValue(controllers[target], value[i]);
      target++;
    }
  }

  static void onCodeChanged(
    String value,
    int index,
    List<FocusNode> focusNodes,
    List<TextEditingController> controllers,
    BuildContext context,
    VoidCallback? onComplete,
    bool isForVerification,
  ) {
    final lastIndex = controllers.length - 1;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      // Backspace: go to previous box
      if (index > 0) {
        _requestFocusAfterBuild(focusNodes[index - 1]);
      }
      return;
    }

    if (digits.length > 1) {
      _fillControllersFromIndex(digits, index, controllers);
      final firstEmptyIndex = controllers.indexWhere((c) => c.text.isEmpty);

      if (firstEmptyIndex == -1) {
        if (isForVerification) {
          FocusScope.of(context).unfocus();
          handleVerifyCode(context, controllers);
        } else {
          onComplete?.call();
        }
      } else {
        _requestFocusAfterBuild(focusNodes[firstEmptyIndex]);
      }
      return;
    }

    _setControllerValue(controllers[index], digits);

    if (index < lastIndex) {
      // Move to next box when current one is filled
      _requestFocusAfterBuild(focusNodes[index + 1]);
    } else if (index == lastIndex && isForVerification) {
      // Last box filled — submit
      FocusScope.of(context).unfocus();
      handleVerifyCode(context, controllers);
    } else if (index == lastIndex) {
      onComplete?.call();
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
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
  }

  static void handleVerifyCode(
    BuildContext context,
    List<TextEditingController> controllers,
  ) {
    String code = controllers.map((c) => c.text).join();
    final l10n = AppLocalizations.of(context)!;
    if (code.length == 6) {
      context.read<VerifyCodeCubit>().verify(code);
    } else {
      clearCode(controllers, []);
      showCustomSnackBar(context, l10n.errInvalidCode, false);
    }
  }
}
