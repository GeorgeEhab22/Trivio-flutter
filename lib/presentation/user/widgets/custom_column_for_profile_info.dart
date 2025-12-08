import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';

class CustomColumnForProfileInfo extends StatelessWidget {
  final String number;
  final String thing;

  const CustomColumnForProfileInfo({
    super.key,
    required this.number,
    required this.thing,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              number,
              style: Styles.textStyle20.copyWith(color: AppColors.primary),
            ),
            Text(thing),
          ],
        ),
      ),
    );
  }
}
