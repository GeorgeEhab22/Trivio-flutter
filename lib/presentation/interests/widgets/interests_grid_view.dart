import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/interests/widgets/selection_item.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        if (state is SelectInterestsError) {
          final displayMessage = state.message == "failed_to_load"
              ? l10n.failedToLoadData
              : state.message;
          showCustomSnackBar(context, displayMessage, false);
        }
      },
      buildWhen: (previous, current) {
        if (current is SelectInterestsSuccess) return false;

        if (previous.runtimeType != current.runtimeType) return true;

        if (previous is InterestsContentState &&
            current is InterestsContentState) {
          return previous.filteredTeams != current.filteredTeams ||
              previous.filteredPlayers != current.filteredPlayers ||
              previous.selectedTeams != current.selectedTeams ||
              previous.selectedPlayers != current.selectedPlayers;
        }
        return true;
      },
      builder: (context, state) {
        final bool isLoading =
            state is SelectInterestsInitial ||
            (state is InterestsLoadingState &&
                (isTeams ? state.loadingTeams : state.loadingPlayers));

        final contentState = state is InterestsContentState ? state : null;

        final List currentTeams = isLoading
            ? DummyData.dummyTeams
            : (contentState?.filteredTeams ?? []);

        final List currentPlayers = isLoading
            ? DummyData.dummyPlayers
            : (contentState?.filteredPlayers ?? []);

        final List selectedItems = isTeams
            ? (contentState?.selectedTeams ?? [])
            : (contentState?.selectedPlayers ?? []);

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
                      context.read<SelectInterestsCubit>().toggleTeam(name);
                    } else {
                      context.read<SelectInterestsCubit>().togglePlayer(name);
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
