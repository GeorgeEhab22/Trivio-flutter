import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/interests/widgets/selection_item.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InterestsGridView extends StatelessWidget {
  final bool isTeams;
  final bool isEdit;

  const InterestsGridView({
    super.key,
    required this.isTeams,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<SelectInterestsCubit, SelectInterestsState>(
      listener: (context, state) {
        if (state is SelectInterestsSuccess) {
          if (isEdit) {
            context.pop();
          } else {
            if (!isTeams) {
              showCustomSnackBar(context, l10n.welcomeBack, true);
              context.go(AppRoutes.home);
            }
          }
        }

        if (state is SelectInterestsError) {
          final displayMessage = state.message == "failed_to_load"
              ? l10n.failedToLoadData
              : state.message;
          showCustomSnackBar(context, displayMessage, false);
        }
      },
      buildWhen: (previous, current) {
        if (current is SelectInterestsSuccess) return false;
        if (previous is SelectInterestsLoaded &&
            current is SelectInterestsLoading) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        final bool isLoading =
            state is SelectInterestsInitial ||
            state is SelectInterestsLoading ||
            (state is SelectInterestsLoaded &&
                (isTeams ? state.isTeamsLoading : state.isPlayersLoading));

        final List currentTeams = state is SelectInterestsLoaded
            ? state.filteredTeams 
            : DummyData.dummyTeams;

        final List currentPlayers = state is SelectInterestsLoaded
            ? state.players
            : DummyData.dummyPlayers;

        final List selectedItems = state is SelectInterestsLoaded
            ? (isTeams ? state.selectedTeams : state.selectedPlayers)
            : [];

        final itemsCount = isTeams
            ? currentTeams.length
            : currentPlayers.length;

        if (!isLoading && itemsCount == 0) {
          return Expanded(
            child: Center(
              child: Text(isTeams ? l10n.noTeamsFound : l10n.noPlayersFound),
            ),
          );
        }

        return Expanded(
          child: Skeletonizer(
            enabled: isLoading,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              itemCount: itemsCount,
              itemBuilder: (context, index) {
                final String name = isTeams
                    ? currentTeams[index].name
                    : currentPlayers[index].name;
                final String image = isTeams
                    ? currentTeams[index].logo
                    : currentPlayers[index].playerImage;

                return SelectionItem(
                  itemName: name,
                  itemLogo: image,
                  isSelected: selectedItems.contains(name),
                  onTap: () {
                    if (isLoading) return;

                    if (isTeams) {
                      context.read<SelectInterestsCubit>().toggleTeam(
                        currentTeams[index].name,
                      );
                    } else {
                      context.read<SelectInterestsCubit>().togglePlayer(
                        currentPlayers[index].name,
                      );
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
