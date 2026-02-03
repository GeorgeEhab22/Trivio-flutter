import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class MemberRuleRow extends StatelessWidget {
  const MemberRuleRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Moderator",
            style: Styles.textStyle14.copyWith(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
