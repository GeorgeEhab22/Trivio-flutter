import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Styles.textStyle18),
          CustomSquareButton(
            label: l10n.getSeeAll,
            isExpanded: false,
            textColor: Colors.blue,
            onTap: onSeeAll,
          ),
        ],
      ),
    );
  }
}