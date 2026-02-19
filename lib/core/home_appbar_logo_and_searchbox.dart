import 'package:auth/constants/colors.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeAppBarLogoAndSearchBox extends StatelessWidget {
  const HomeAppBarLogoAndSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        const Text(
          'Trivio',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 110,
            minWidth: 80,
            maxHeight: 36,
          ),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: AppColors.iconsColor, size: 20),
                const SizedBox(width: 6),
                 Flexible(
                  child: Text(
                    l10n.search,
                    style: TextStyle(color: Color(0xFF565d6d), fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
