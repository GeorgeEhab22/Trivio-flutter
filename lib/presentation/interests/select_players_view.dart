import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/interests/widgets/search_box.dart';
import 'package:auth/presentation/interests/widgets/selection_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectPlayersView extends StatelessWidget {
  final bool isEditPlayers;
  const SelectPlayersView({super.key, this.isEditPlayers = false});

  @override
  Widget build(BuildContext context) {
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
                  "Your favourite players",
                  style: Styles.textStyle20.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Select your interested players to get better recommendations",
                  style: Styles.textStyle14.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),

          SearchBox(),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.82,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return SelectionItem(
                  teamName: "Player $index",
                  teamLogo: "https://picsum.photos/200",
                  isSelected: true,
                  onTap: () {
                    // TODO : use update user info cubit (players)
                  },
                );
              },
            ),
          ),
          if (!isEditPlayers) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSquareButton(
                    label: "Back",
                    height: 11,
                    backgroundColor: Theme.of(context).cardColor,
                    onTap: () {
                      context.pop();
                    },
                  ),
                  CustomSquareButton(
                    label: "Finish",
                    textColor: Colors.white,
                    height: 11,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.9),
                    onTap: () {
                      context.go(AppRoutes.home);
                    },
                  ),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomSquareButton(
                    label: "Update",
                    textColor: Colors.white,
                    height: 11,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.9),
                    onTap: () {
                      // TODO : first get selected players and then use update user info cubit (players)
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
