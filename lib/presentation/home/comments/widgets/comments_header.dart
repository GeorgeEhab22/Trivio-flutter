import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class CommentsHeader extends StatelessWidget {
  final int reactionsCount;

  const CommentsHeader({super.key, required this.reactionsCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
      child: Center(child: Text("comments", style: Styles.textStyle20)),
    );
  }
}
