import 'package:flutter/material.dart';
import 'package:auth/constants/colors';

class PrivacySelector extends StatelessWidget {
  final String privacy;
  final ValueChanged<String> onChange;
  const PrivacySelector({super.key, required this.privacy, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(privacy == "Public" ? Icons.public : Icons.lock,
                    color: AppColors.iconsColor),
                const SizedBox(width: 8),
                Text(privacy),
              ],
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.public),
                        title: const Text("Public"),
                        onTap: () {
                          onChange("Public");
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text("Private"),
                        onTap: () {
                          onChange("Private");
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.arrow_drop_down, color: AppColors.iconsColor),
            ),
          ],
        ),
      ),
    );
  }
}
