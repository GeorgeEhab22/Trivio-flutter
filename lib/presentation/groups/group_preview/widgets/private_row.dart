import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class PrivateRow extends StatelessWidget {
  const PrivateRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.lock_outline, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            "Only members can see who's in the group and what they post.",
            style: Styles.textStyle14.copyWith(color: Colors.grey),
            maxLines: 2,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
