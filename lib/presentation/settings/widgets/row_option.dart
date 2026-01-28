import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

Widget rowOption(
  BuildContext context, {
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return ListTile(
    onTap: onTap,
    title: Text(title, style: Styles.textStyle16),
    trailing: Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    ),
  );
}
