import 'package:auth/domain/usecases/interests/get_all_players_use_case.dart';
import 'package:auth/domain/usecases/interests/get_all_teams_use_case.dart';
import 'package:auth/domain/usecases/interests/get_selected_fav_players_use_case.dart';
import 'package:auth/domain/usecases/interests/get_selected_fav_teams_use_case.dart';
import 'package:auth/domain/usecases/interests/remove_fav_players_use_case.dart';
import 'package:auth/domain/usecases/interests/remove_fav_teams_use_case.dart';
import 'package:auth/domain/usecases/interests/select_interests.dart';
import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/entities/team.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'select_interests_state.dart';

class SelectInterestsCubit extends Cubit<SelectInterestsState> {
  final SelectInterestsUseCase selectInterestsUseCase;
  final GetSelectedFavTeamsUseCase getFavTeamsUseCase;
  final GetSelectedFavPlayersUseCase getFavPlayersUseCase;
  final RemoveFavTeamsUseCase removeFavTeamsUseCase;
  final RemoveFavPlayersUseCase removeFavPlayersUseCase;
  final GetAllTeamsUseCase getTeamsUseCase;
  final GetAllPlayersUseCase getPlayersUseCase;

  SelectInterestsCubit({
    required this.selectInterestsUseCase,
    required this.getFavTeamsUseCase,
    required this.getFavPlayersUseCase,
    required this.removeFavTeamsUseCase,
    required this.removeFavPlayersUseCase,
    required this.getTeamsUseCase,
    required this.getPlayersUseCase,
  }) : super(SelectInterestsInitial());

  SelectInterestsLoaded get _currentState {
    return state is SelectInterestsLoaded
        ? state as SelectInterestsLoaded
        : const SelectInterestsLoaded();
  }

  Future<void> loadTeams({bool isEdit = false}) async {
    print('--> Cubit: loadTeams called. isEdit: $isEdit');

    if (_currentState.teams.isNotEmpty) {
      print('--> Cubit: Teams already loaded, returning.');
      return;
    }

    if (_currentState.isTeamsLoading) {
      print(
        '--> Cubit: Teams are currently loading, preventing duplicate call.',
      );
      return;
    }

    if (isClosed) return;
    print('--> Cubit: Emitting TeamsLoading state');
    emit(_currentState.copyWith(isTeamsLoading: true));

    final teamsResult = await getTeamsUseCase();
    List<Team> allTeams = [];
    String? errorMessage;

    teamsResult.fold(
      (failure) {
        print('--> Cubit: getTeamsUseCase failed: ${failure.message}');
        errorMessage = failure.message;
      },
      (teams) {
        print('--> Cubit: getTeamsUseCase success. Count: ${teams.length}');
        allTeams = teams;
      },
    );

    if (errorMessage != null) {
      if (!isClosed) emit(SelectInterestsError(message: errorMessage!));
      return;
    }

    List<String> favTeams = [];
    if (isEdit) {
      print('--> Cubit: isEdit is true, fetching user favorite teams');
      final fTeamsResult = await getFavTeamsUseCase();
      fTeamsResult.fold(
        (l) => print('--> Cubit: Failed to fetch favorite teams: ${l.message}'),
        (r) {
          favTeams = r;
          print('--> Cubit: Fetched favorite teams: $favTeams');
        },
      );
    }

    if (favTeams.isNotEmpty) {
      print('--> Cubit: Sorting teams based on favorites');
      allTeams.sort((a, b) {
        bool aIsSelected = favTeams.contains(a.name);
        bool bIsSelected = favTeams.contains(b.name);
        if (aIsSelected && !bIsSelected) return -1;
        if (!aIsSelected && bIsSelected) return 1;
        return 0;
      });
    }

    if (isClosed) return;

    print('--> Cubit: Emitting TeamsLoaded state');
    emit(
      _currentState.copyWith(
        teams: allTeams,
        selectedTeams: favTeams,
        isTeamsLoading: false,
      ),
    );
  }

  Future<void> loadPlayers({bool isEdit = false}) async {
    print('--> Cubit: loadPlayers called. isEdit: $isEdit');

    if (_currentState.players.isNotEmpty) {
      print('--> Cubit: Players already loaded, returning.');
      return;
    }

    if (_currentState.isPlayersLoading) {
      print(
        '--> Cubit: Players are currently loading, preventing duplicate call.',
      );
      return;
    }

    if (isClosed) return;
    print('--> Cubit: Emitting PlayersLoading state');
    emit(_currentState.copyWith(isPlayersLoading: true));

    final playersResult = await getPlayersUseCase();
    List<Player> allPlayers = [];
    String? errorMessage;

    playersResult.fold(
      (failure) {
        print('--> Cubit: getPlayersUseCase failed: ${failure.message}');
        errorMessage = failure.message;
      },
      (players) {
        print('--> Cubit: getPlayersUseCase success. Count: ${players.length}');
        allPlayers = players;
      },
    );

    if (errorMessage != null) {
      if (!isClosed) emit(SelectInterestsError(message: errorMessage!));
      return;
    }

    List<String> favPlayers = [];
    if (isEdit) {
      print('--> Cubit: isEdit is true, fetching user favorite players');
      final fPlayersResult = await getFavPlayersUseCase();
      fPlayersResult.fold(
        (l) =>
            print('--> Cubit: Failed to fetch favorite players: ${l.message}'),
        (r) {
          favPlayers = r;
          print('--> Cubit: Fetched favorite players: $favPlayers');
        },
      );
    }

    if (favPlayers.isNotEmpty) {
      print('--> Cubit: Sorting players based on favorites');
      allPlayers.sort((a, b) {
        bool aIsSelected = favPlayers.contains(a.name);
        bool bIsSelected = favPlayers.contains(b.name);
        if (aIsSelected && !bIsSelected) return -1;
        if (!aIsSelected && bIsSelected) return 1;
        return 0;
      });
    }

    if (isClosed) return;

    print('--> Cubit: Emitting PlayersLoaded state');
    emit(
      _currentState.copyWith(
        players: allPlayers,
        selectedPlayers: favPlayers,
        isPlayersLoading: false,
      ),
    );
  }

  void toggleTeam(String teamName) {
    print('--> Cubit: toggleTeam called for: $teamName');
    final updatedSelected = List<String>.from(_currentState.selectedTeams);
    final updatedToDelete = List<String>.from(_currentState.teamsToDelete);

    if (updatedSelected.contains(teamName)) {
      print('--> Cubit: Removing $teamName from selectedTeams');
      updatedSelected.remove(teamName);
      updatedToDelete.add(teamName);
    } else {
      print('--> Cubit: Adding $teamName to selectedTeams');
      updatedSelected.add(teamName);
      updatedToDelete.remove(teamName);
    }

    if (isClosed) return;
    emit(
      _currentState.copyWith(
        selectedTeams: updatedSelected,
        teamsToDelete: updatedToDelete,
      ),
    );
  }

  void togglePlayer(String playerName) {
    print('--> Cubit: togglePlayer called for: $playerName');
    final updatedSelected = List<String>.from(_currentState.selectedPlayers);
    final updatedToDelete = List<String>.from(_currentState.playersToDelete);

    if (updatedSelected.contains(playerName)) {
      print('--> Cubit: Removing $playerName from selectedPlayers');
      updatedSelected.remove(playerName);
      updatedToDelete.add(playerName);
    } else {
      print('--> Cubit: Adding $playerName to selectedPlayers');
      updatedSelected.add(playerName);
      updatedToDelete.remove(playerName);
    }

    if (isClosed) return;
    emit(
      _currentState.copyWith(
        selectedPlayers: updatedSelected,
        playersToDelete: updatedToDelete,
      ),
    );
  }

  Future<void> submitInterests() async {
    print('--> Cubit: submitInterests called');
    if (isClosed) return;

    final favTeamsToSubmit = List<String>.from(_currentState.selectedTeams);
    final favPlayersToSubmit = List<String>.from(_currentState.selectedPlayers);
    final teamsToDelete = List<String>.from(_currentState.teamsToDelete);
    final playersToDelete = List<String>.from(_currentState.playersToDelete);

    print(
      '--> Cubit: Captured data before loading state - Teams: $favTeamsToSubmit, Players: $favPlayersToSubmit',
    );

    emit(SelectInterestsLoading());

    if (teamsToDelete.isNotEmpty) {
      print('--> Cubit: Submitting teams to delete: $teamsToDelete');
      await removeFavTeamsUseCase(teamsToDelete);
    }
    if (playersToDelete.isNotEmpty) {
      print('--> Cubit: Submitting players to delete: $playersToDelete');
      await removeFavPlayersUseCase(playersToDelete);
    }

    print(
      '--> Cubit: Submitting final interests. Teams: $favTeamsToSubmit, Players: $favPlayersToSubmit',
    );
    final result = await selectInterestsUseCase(
      favTeams: favTeamsToSubmit,
      favPlayers: favPlayersToSubmit,
    );

    if (isClosed) return;

    result.fold(
      (f) {
        print('--> Cubit: submitInterests failed: ${f.message}');
        emit(SelectInterestsError(message: f.message));
      },
      (_) {
        print('--> Cubit: submitInterests success');
        emit(SelectInterestsSuccess());
      },
    );
  }
}
