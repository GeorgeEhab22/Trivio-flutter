import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/interests/widgets/search_box.dart';
import 'package:auth/presentation/interests/widgets/selection_item.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SelectTeamsView extends StatelessWidget {
  final bool isEditTeams;
  const SelectTeamsView({super.key, this.isEditTeams = false});

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
                  "Your favourite teams",
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

          SearchBox(),

          BlocConsumer<SelectInterestsCubit, SelectInterestsState>(
            listener: (context, state) {
              if (state is SelectInterestsSuccess) {
                isEditTeams
                    ? context.pop()
                    : context.push(AppRoutes.selectPlayers);
              }
              if (state is SelectInterestsError) {
                showCustomSnackBar(context, state.message, false);
              }
            },
            builder: (context, state) {
              final cubit = context.read<SelectInterestsCubit>();
              final selectedTeams = (state is SelectInterestsInitial)
                  ? state.selectedTeams
                  : <String>[];
              return Expanded(
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
                      itemName: "Team $index",
                      itemLogo: "https://picsum.photos/200",
                      isSelected: selectedTeams.contains("Team $index"),
                      onTap: () {
                        cubit.toggleTeam("Team $index");
                      },
                    );
                  },
                ),
              );
            },
          ),
          if (!isEditTeams) ...[
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
                      context.read<SelectInterestsCubit>().submitInterests();
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
