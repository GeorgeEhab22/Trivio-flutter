import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class InterestsHeader extends StatelessWidget {
  final String title;
  final String subTitle;

  const InterestsHeader({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subTitle,
            style: Styles.textStyle14.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
