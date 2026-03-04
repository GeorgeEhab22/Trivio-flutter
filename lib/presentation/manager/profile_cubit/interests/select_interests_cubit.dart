import 'dart:async';
import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/entities/team.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/usecases/interests/get_all_players_use_case.dart';
import 'package:auth/domain/usecases/interests/get_all_teams_use_case.dart';
import 'package:auth/domain/usecases/interests/get_selected_fav_players_use_case.dart';
import 'package:auth/domain/usecases/interests/get_selected_fav_teams_use_case.dart';
import 'package:auth/domain/usecases/interests/search_players_use_case.dart';
import 'package:auth/domain/usecases/interests/select_interests.dart';
import 'select_interests_state.dart';

class SelectInterestsCubit extends Cubit<SelectInterestsState> {
  final SelectInterestsUseCase selectInterestsUseCase;
  final GetSelectedFavTeamsUseCase getFavTeamsUseCase;
  final GetSelectedFavPlayersUseCase getFavPlayersUseCase;
  final GetAllTeamsUseCase getTeamsUseCase;
  final GetAllPlayersUseCase getPlayersUseCase;
  final SearchPlayersUseCase searchPlayersUseCase;

  Timer? _searchDebounce;

  SelectInterestsCubit({
    required this.selectInterestsUseCase,
    required this.getFavTeamsUseCase,
    required this.getFavPlayersUseCase,
    required this.getTeamsUseCase,
    required this.getPlayersUseCase,
    required this.searchPlayersUseCase,
  }) : super(SelectInterestsInitial());

  InterestsContentState get currentData => state is InterestsContentState
      ? state as InterestsContentState
      : const InterestsDisplayState();

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  void onSearchChanged(String query, {required bool isTeams}) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 700), () {
      isTeams ? searchLocalTeams(query) : searchRemotePlayers(query);
    });
  }

  Future<void> loadTeams({bool isEdit = false}) async {
    if (isClosed) return;

    if (currentData.teams.isNotEmpty ||
        (state is InterestsLoadingState &&
            (state as InterestsLoadingState).loadingTeams)) {
      return;
    }

    emit(_mapToLoading(loadingTeams: true));

    List<String> favTeams = [];
    if (isEdit) {
      final fTeamsResult = await getFavTeamsUseCase();
      if (isClosed) return;
      fTeamsResult.fold((l) => null, (r) => favTeams = r);
    }

    final teamsResult = await getTeamsUseCase(favTeams: favTeams);
    if (isClosed) return;

    teamsResult.fold(
      (failure) => emit(SelectInterestsError(message: failure.message)),
      (sortedTeams) => emit(
        InterestsDisplayState(
          teams: sortedTeams,
          filteredTeams: sortedTeams,
          selectedTeams: favTeams,
          initialSelectedTeams: currentData.initialSelectedTeams.isEmpty
              ? favTeams
              : currentData.initialSelectedTeams,
          players: currentData.players,
          selectedPlayers: currentData.selectedPlayers,
          initialSelectedPlayers: currentData.initialSelectedPlayers,
          teamsToDelete: currentData.teamsToDelete,
          playersToDelete: currentData.playersToDelete,
          filteredPlayers: currentData.filteredPlayers,
        ),
      ),
    );
  }

  Future<void> loadPlayers({bool isEdit = false}) async {
    if (isClosed) return;
    if (state is InterestsLoadingState &&
        (state as InterestsLoadingState).loadingPlayers) {
      return;
    }
    emit(_mapToLoading(loadingPlayers: true));

    List<String> favPlayers = [];
    if (isEdit) {
      final fPlayersResult = await getFavPlayersUseCase();
      if (isClosed) return;
      fPlayersResult.fold((l) => null, (r) => favPlayers = r);
    }

    final playersResult = await getPlayersUseCase(
      favPlayers: favPlayers,
      isEdit: isEdit,
    );
    if (isClosed) return;

    playersResult.fold(
      (failure) => emit(SelectInterestsError(message: failure.message)),
      (finalPlayersList) => emit(
        InterestsDisplayState(
          players: finalPlayersList,
          filteredPlayers: finalPlayersList,
          selectedPlayers: favPlayers,
          initialSelectedPlayers: currentData.initialSelectedPlayers.isEmpty
              ? favPlayers
              : currentData.initialSelectedPlayers,
          teams: currentData.teams,
          selectedTeams: currentData.selectedTeams,
          initialSelectedTeams: currentData.initialSelectedTeams,
          teamsToDelete: currentData.teamsToDelete,
          playersToDelete: currentData.playersToDelete,
          filteredTeams: currentData.filteredTeams,
        ),
      ),
    );
  }

  void searchLocalTeams(String query) {
    final results = query.isEmpty
        ? currentData.teams
        : currentData.teams
              .where((t) => t.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

    emit(_mapToDisplay(filteredTeams: results));
  }

  Future<void> searchRemotePlayers(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 3) {
      emit(_mapToDisplay(filteredPlayers: currentData.players));
      return;
    }

    emit(_mapToLoading(loadingPlayers: true));

    final result = await searchPlayersUseCase(
      trimmedQuery,
      favPlayers: currentData.selectedPlayers,
    );
    if (isClosed) return;

    result.fold((failure) {
      emit(SelectInterestsError(message: failure.message));
      emit(_mapToDisplay());
    }, (sortedPlayers) => emit(_mapToDisplay(filteredPlayers: sortedPlayers)));
  }

  void toggleTeam(String teamName) {
    final updatedSelected = List<String>.from(currentData.selectedTeams);
    final updatedToDelete = List<String>.from(currentData.teamsToDelete);

    if (updatedSelected.contains(teamName)) {
      updatedSelected.remove(teamName);
      updatedToDelete.add(teamName);
    } else {
      updatedSelected.add(teamName);
      updatedToDelete.remove(teamName);
    }
    emit(
      _mapToDisplay(
        selectedTeams: updatedSelected,
        teamsToDelete: updatedToDelete,
      ),
    );
  }

  void togglePlayer(String playerName) {
    final updatedSelected = List<String>.from(currentData.selectedPlayers);
    final updatedToDelete = List<String>.from(currentData.playersToDelete);

    if (updatedSelected.contains(playerName)) {
      updatedSelected.remove(playerName);
      updatedToDelete.add(playerName);
    } else {
      updatedSelected.add(playerName);
      updatedToDelete.remove(playerName);
    }
    emit(
      _mapToDisplay(
        selectedPlayers: updatedSelected,
        playersToDelete: updatedToDelete,
      ),
    );
  }

  Future<bool> submitInterests() async {
    emit(_mapToSubmitting());

    final result = await selectInterestsUseCase(
      favTeams: currentData.selectedTeams,
      favPlayers: currentData.selectedPlayers,
      teamsToDelete: currentData.teamsToDelete,
      playersToDelete: currentData.playersToDelete,
    );

    if (isClosed) return false;

    return result.fold(
      (f) {
        emit(SelectInterestsError(message: f.message));
        emit(_mapToDisplay());
        return false;
      },
      (_) {
        emit(const SelectInterestsSuccess());
        return true;
      },
    );
  }


  InterestsLoadingState _mapToLoading({
    bool loadingTeams = false,
    bool loadingPlayers = false,
  }) {
    return InterestsLoadingState(
      teams: currentData.teams,
      players: currentData.players,
      selectedTeams: currentData.selectedTeams,
      selectedPlayers: currentData.selectedPlayers,
      initialSelectedTeams: currentData.initialSelectedTeams,
      initialSelectedPlayers: currentData.initialSelectedPlayers,
      teamsToDelete: currentData.teamsToDelete,
      playersToDelete: currentData.playersToDelete,
      filteredTeams: currentData.filteredTeams,
      filteredPlayers: currentData.filteredPlayers,
      loadingTeams: loadingTeams,
      loadingPlayers: loadingPlayers,
    );
  }

  InterestsDisplayState _mapToDisplay({
    List<Team>? filteredTeams,
    List<Player>? filteredPlayers,
    List<String>? selectedTeams,
    List<String>? selectedPlayers,
    List<String>? teamsToDelete,
    List<String>? playersToDelete,
  }) {
    return InterestsDisplayState(
      teams: currentData.teams,
      players: currentData.players,
      selectedTeams: selectedTeams ?? currentData.selectedTeams,
      selectedPlayers: selectedPlayers ?? currentData.selectedPlayers,
      initialSelectedTeams: currentData.initialSelectedTeams,
      initialSelectedPlayers: currentData.initialSelectedPlayers,
      teamsToDelete: teamsToDelete ?? currentData.teamsToDelete,
      playersToDelete: playersToDelete ?? currentData.playersToDelete,
      filteredTeams: filteredTeams ?? currentData.filteredTeams,
      filteredPlayers: filteredPlayers ?? currentData.filteredPlayers,
    );
  }

  InterestsSubmittingState _mapToSubmitting() {
    return InterestsSubmittingState(
      teams: currentData.teams,
      players: currentData.players,
      selectedTeams: currentData.selectedTeams,
      selectedPlayers: currentData.selectedPlayers,
      initialSelectedTeams: currentData.initialSelectedTeams,
      initialSelectedPlayers: currentData.initialSelectedPlayers,
      teamsToDelete: currentData.teamsToDelete,
      playersToDelete: currentData.playersToDelete,
      filteredTeams: currentData.filteredTeams,
      filteredPlayers: currentData.filteredPlayers,
    );
  }
}
