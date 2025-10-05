import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;
  final VoidCallback onSubmit;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  
  final passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).+$');

   PasswordField({
    super.key,
    required this.controller,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
    required this.onSubmit,
    this.label = 'Password',
    this.hint = 'Password',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) {
        FocusScope.of(context).unfocus();
        onSubmit();
      },
      decoration: InputDecoration(
        helperText: label == "Password"
            ? "Min 8 chars, 1 uppercase, 1 number, 1 special char"
            : null,
        labelText: label,
        hintText: hint,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onVisibilityToggle,
        ),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if(!passwordRegex.hasMatch(value)){
              return 'Min 8 chars, 1 uppercase, 1 number, 1 special char';
            }
            
            return null;
          },
    );
  }
  
}
