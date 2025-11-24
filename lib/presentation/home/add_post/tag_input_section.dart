import 'package:flutter/material.dart';
import 'package:auth/common/basic_app_button.dart';
import 'package:auth/constants/colors';

class TagInputSection extends StatelessWidget {
  const TagInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.tag, color: AppColors.iconsColor, size: 22),
            const SizedBox(width: 8),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tag players or teams...",
                  border: InputBorder.none,
                ),
              ),
            ),
            BasicAppButton(onPressed: () {}, height: 34, width: 80, title: "Tag"),
          ],
        ),
      ),
    );
  }
}
