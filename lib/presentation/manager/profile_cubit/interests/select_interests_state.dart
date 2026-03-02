import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/entities/team.dart';
import 'package:equatable/equatable.dart';

abstract class SelectInterestsState extends Equatable {
  const SelectInterestsState();
  @override
  List<Object?> get props => [];
}

final class SelectInterestsInitial extends SelectInterestsState {}

final class SelectInterestsSuccess extends SelectInterestsState {
  const SelectInterestsSuccess();
}

final class SelectInterestsError extends SelectInterestsState {
  final String message;
  const SelectInterestsError({required this.message});
  @override
  List<Object?> get props => [message];
}

abstract class InterestsContentState extends SelectInterestsState {
  final List<Team> teams;
  final List<Player> players;
  final List<String> selectedTeams;
  final List<String> selectedPlayers;
  final List<String> initialSelectedTeams;
  final List<String> initialSelectedPlayers;
  final List<String> teamsToDelete;
  final List<String> playersToDelete;
  final List<Team> filteredTeams;
  final List<Player> filteredPlayers;

  const InterestsContentState({
    this.teams = const [],
    this.players = const [],
    this.selectedTeams = const [],
    this.selectedPlayers = const [],
    this.initialSelectedTeams = const [],
    this.initialSelectedPlayers = const [],
    this.teamsToDelete = const [],
    this.playersToDelete = const [],
    this.filteredTeams = const [],
    this.filteredPlayers = const [],
  });

  bool get hasChanges {
    bool teamsUnchanged =
        selectedTeams.length == initialSelectedTeams.length &&
        selectedTeams.toSet().containsAll(initialSelectedTeams);

    bool playersUnchanged =
        selectedPlayers.length == initialSelectedPlayers.length &&
        selectedPlayers.toSet().containsAll(initialSelectedPlayers);

    return !(teamsUnchanged && playersUnchanged);
  }

  @override
  List<Object?> get props => [
    teams,
    players,
    selectedTeams,
    selectedPlayers,
    initialSelectedTeams,
    initialSelectedPlayers,
    teamsToDelete,
    playersToDelete,
    filteredTeams,
    filteredPlayers,
  ];
}

final class InterestsLoadingState extends InterestsContentState {
  final bool loadingTeams;
  final bool loadingPlayers;

  const InterestsLoadingState({
    super.teams,
    super.players,
    super.selectedTeams,
    super.selectedPlayers,
    super.initialSelectedTeams,
    super.initialSelectedPlayers,
    super.teamsToDelete,
    super.playersToDelete,
    super.filteredTeams,
    super.filteredPlayers,
    this.loadingTeams = false,
    this.loadingPlayers = false,
  });

  @override
  List<Object?> get props => [...super.props, loadingTeams, loadingPlayers];
}

final class InterestsDisplayState extends InterestsContentState {
  const InterestsDisplayState({
    super.teams,
    super.players,
    super.selectedTeams,
    super.selectedPlayers,
    super.initialSelectedTeams,
    super.initialSelectedPlayers,
    super.teamsToDelete,
    super.playersToDelete,
    super.filteredTeams,
    super.filteredPlayers,
  });
}

final class InterestsSubmittingState extends InterestsContentState {
  const InterestsSubmittingState({
    super.teams,
    super.players,
    super.selectedTeams,
    super.selectedPlayers,
    super.initialSelectedTeams,
    super.initialSelectedPlayers,
    super.teamsToDelete,
    super.playersToDelete,
    super.filteredTeams,
    super.filteredPlayers,
  });
}
