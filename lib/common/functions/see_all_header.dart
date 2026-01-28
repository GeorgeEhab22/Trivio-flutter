import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class SeeAllHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SeeAllHeader({
    super.key,
    required this.title,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Styles.textStyle18),
          CustomSquareButton(
            label: "See all",
            isExpanded: false,
            textColor: Colors.blue,
            onTap: onSeeAll,
          ),
        ],
      ),
    );
  }
}