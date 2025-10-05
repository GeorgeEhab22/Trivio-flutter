import 'package:flutter/material.dart';

class SignInDivider extends StatelessWidget {
  const SignInDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider()),
        SizedBox(width: 10),
        Text(
          'Or',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
        ),
        SizedBox(width: 10),
        Expanded(child: Divider()),
      ],
    );
  }
}
