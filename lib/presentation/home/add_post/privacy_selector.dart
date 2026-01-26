import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';

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
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: InkWell(
          onTap: () => BottomSheetManager.showPrivacyOptions(context, onChange),
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isPublic ? Icons.public : Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      privacy,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
