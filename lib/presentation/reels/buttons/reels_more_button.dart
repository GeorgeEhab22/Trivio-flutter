import 'package:flutter/material.dart';

class ReelsMoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const ReelsMoreButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(Icons.more_vert, color: Colors.white, size: 26),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}
