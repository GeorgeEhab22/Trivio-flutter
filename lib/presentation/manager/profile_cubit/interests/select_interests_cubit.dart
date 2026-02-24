import 'package:auth/domain/usecases/user_profile/get_fav_players_use_case.dart';
import 'package:auth/domain/usecases/user_profile/get_fav_teams_use_case.dart';
import 'package:auth/domain/usecases/user_profile/remove_fav_players_use_case.dart';
import 'package:auth/domain/usecases/user_profile/remove_fav_teams_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/usecases/user_profile/select_interests.dart';
import 'select_interests_state.dart';

class SelectInterestsCubit extends Cubit<SelectInterestsState> {
  final SelectInterestsUseCase selectInterestsUseCase;
  final GetFavTeamsUseCase getFavTeamsUseCase;
  final GetFavPlayersUseCase getFavPlayersUseCase;
  final RemoveFavTeamsUseCase removeFavTeamsUseCase;
  final RemoveFavPlayersUseCase removeFavPlayersUseCase;

  SelectInterestsCubit({
    required this.selectInterestsUseCase,
    required this.getFavTeamsUseCase,
    required this.getFavPlayersUseCase,
    required this.removeFavTeamsUseCase,
    required this.removeFavPlayersUseCase,
  }) : super(const SelectInterestsInitial());

  void safeEmit(SelectInterestsState state) {
    if (!isClosed) emit(state);
  }

  Future<void> getFavTeams() async {
    safeEmit(const SelectInterestsLoading());
    final result = await getFavTeamsUseCase();
    
    result.fold(
      (failure) => safeEmit(SelectInterestsError(failure.message)),
      (teams) {
        final currentState = state;
        final currentPlayers = (currentState is SelectInterestsInitial)
            ? currentState.selectedPlayers
            : <String>[];

        safeEmit(
          SelectInterestsInitial(
            selectedTeams: teams,
            selectedPlayers: currentPlayers,
          ),
        );
      },
    );
  }

  Future<void> getFavPlayers() async {
    safeEmit(const SelectInterestsLoading());
    final result = await getFavPlayersUseCase();
    
    result.fold(
      (failure) => safeEmit(SelectInterestsError(failure.message)),
      (players) {
        final currentState = state;
        final currentTeams = (currentState is SelectInterestsInitial)
            ? currentState.selectedTeams
            : <String>[];

        safeEmit(
          SelectInterestsInitial(
            selectedTeams: currentTeams,
            selectedPlayers: players,
          ),
        );
      },
    );
  }

  void toggleTeam(String teamName, {bool isEdit = false}) async {
    if (state is SelectInterestsInitial) {
      final currentState = state as SelectInterestsInitial;
      final updatedTeams = List<String>.from(currentState.selectedTeams);
      final wasSelected = updatedTeams.contains(teamName);

      if (wasSelected) {
        updatedTeams.remove(teamName);
      } else {
        updatedTeams.add(teamName);
      }

      safeEmit(currentState.copyWith(selectedTeams: updatedTeams));

      if (isEdit && wasSelected) {
        final result = await removeFavTeamsUseCase([teamName]);
        result.fold(
          (failure) {
            final rollbackTeams = List<String>.from(updatedTeams)..add(teamName);
            safeEmit(currentState.copyWith(selectedTeams: rollbackTeams));
            safeEmit(SelectInterestsError(failure.message));
          },
          (_) => null,
        );
      }
    }
  }

  void togglePlayer(String playerName, {bool isEdit = false}) async {
    if (state is SelectInterestsInitial) {
      final currentState = state as SelectInterestsInitial;
      final updatedPlayers = List<String>.from(currentState.selectedPlayers);
      final wasSelected = updatedPlayers.contains(playerName);

      if (wasSelected) {
        updatedPlayers.remove(playerName);
      } else {
        updatedPlayers.add(playerName);
      }

      safeEmit(currentState.copyWith(selectedPlayers: updatedPlayers));

      if (isEdit && wasSelected) {
        final result = await removeFavPlayersUseCase([playerName]);
        result.fold(
          (failure) {
            final rollbackPlayers = List<String>.from(updatedPlayers)..add(playerName);
            safeEmit(currentState.copyWith(selectedPlayers: rollbackPlayers));
            safeEmit(SelectInterestsError(failure.message));
          },
          (_) => null,
        );
      }
    }
  }

  Future<void> submitInterests() async {
    if (state is SelectInterestsInitial) {
      final currentState = state as SelectInterestsInitial;
      safeEmit(const SelectInterestsLoading());

      final result = await selectInterestsUseCase(
        favTeams: currentState.selectedTeams,
        favPlayers: currentState.selectedPlayers,
      );

      result.fold(
        (failure) => safeEmit(SelectInterestsError(failure.message)),
        (_) => safeEmit(const SelectInterestsSuccess()),
      );
    }
  }
}