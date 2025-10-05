import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLogin;

  const EmailField({super.key, required this.controller, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: isLogin ? 'Enter username or email' : 'Enter email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          if (isLogin) return 'Please enter your username or email';
          return 'Please enter your email';
        }
        return null;
      },
    );
  }
}
