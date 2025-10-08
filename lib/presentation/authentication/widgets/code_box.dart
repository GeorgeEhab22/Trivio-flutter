import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeBox extends StatelessWidget {
  const CodeBox({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.onKeyEvent,
    this.enabled = true, // Add this
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String)? onChanged;
  final Function(KeyEvent)? onKeyEvent;
  final bool enabled; // Add this

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[100], // Change color when disabled
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focusNode.hasFocus
              ? Theme.of(context).primaryColor
              : Colors.grey[300]!,
          width: focusNode.hasFocus ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: onKeyEvent,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled, // Add this
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: enabled ? Colors.black : Colors.grey, // Change text color
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}