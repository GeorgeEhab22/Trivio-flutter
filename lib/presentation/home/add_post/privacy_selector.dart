import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors';

class PrivacySelector extends StatelessWidget {
  final String privacy;
  final ValueChanged<String> onChange;
  const PrivacySelector({
    super.key,
    required this.privacy,
    required this.onChange,
  });

 

  @override
  Widget build(BuildContext context) {
    final bool isPublic = privacy == "Public";
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
                Icon(
                  isPublic ? Icons.public : Icons.lock,
                  color: AppColors.iconsColor,
                ),
                const SizedBox(width: 8),
                Text(privacy),
              ],
            ),
            InkWell(
              onTap: () => BottomSheetManager.showPrivacyOptions(context, onChange),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.arrow_drop_down, color: AppColors.iconsColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
