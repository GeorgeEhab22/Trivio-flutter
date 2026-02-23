import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/interests/widgets/selection_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectTeamsView extends StatelessWidget {
  const SelectTeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 10,
              top: 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose your teams",
                  style: Styles.textStyle20.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Select your interested teams to get better recommendations",
                  style: Styles.textStyle14.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: l10n.search,
                        hintStyle: Styles.textStyle16.copyWith(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.82,
              ),
              itemCount: 15,
              itemBuilder: (context, index) {
                return SelectionItem(
                  teamName: "Team $index",
                  teamLogo: "https://picsum.photos/200",
                  isSelected: false,
                  onTap: () {},
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomSquareButton(
                  label: "Skip",
                  height: 11,
                  backgroundColor: Theme.of(context).cardColor,
                  onTap: () {
                    context.go(AppRoutes.home);
                  },
                ),
                CustomSquareButton(
                  label: "Next",
                  textColor: Colors.white,
                  row: true,
                  trailingIcon: Icons.arrow_forward_ios,
                  iconColor: Colors.white,
                  height: 11,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.9),
                  onTap: () {
                    context.push(AppRoutes.selectPlayers);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
