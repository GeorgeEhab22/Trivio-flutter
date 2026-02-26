import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/entities/team.dart';
import 'package:equatable/equatable.dart';

abstract class SelectInterestsState extends Equatable {
  const SelectInterestsState();
  @override
  List<Object?> get props => [];
}

final class SelectInterestsInitial extends SelectInterestsState {}

final class SelectInterestsLoading extends SelectInterestsState {}

final class SelectInterestsLoaded extends SelectInterestsState {
  final List<Team> teams;
  final List<Player> players;
  final List<String> selectedTeams;
  final List<String> selectedPlayers;
  final List<String> teamsToDelete;
  final List<String> playersToDelete;
  
  final bool isTeamsLoading;
  final bool isPlayersLoading;

//search
  final List<Team> filteredTeams;

  const SelectInterestsLoaded({
    this.teams = const [],
    this.players = const [],
    this.selectedTeams = const [],
    this.selectedPlayers = const [],
    this.teamsToDelete = const [],
    this.playersToDelete = const [],
    this.isTeamsLoading = false,
    this.isPlayersLoading = false,
    this.filteredTeams = const [], 
  });

  SelectInterestsLoaded copyWith({
    List<Team>? teams,
    List<Player>? players,
    List<String>? selectedTeams,
    List<String>? selectedPlayers,
    List<String>? teamsToDelete,
    List<String>? playersToDelete,
    bool? isTeamsLoading,
    bool? isPlayersLoading,
    List<Team>? filteredTeams,
  }) {
    return SelectInterestsLoaded(
      teams: teams ?? this.teams,
      players: players ?? this.players,
      selectedTeams: selectedTeams ?? this.selectedTeams,
      selectedPlayers: selectedPlayers ?? this.selectedPlayers,
      teamsToDelete: teamsToDelete ?? this.teamsToDelete,
      playersToDelete: playersToDelete ?? this.playersToDelete,
      isTeamsLoading: isTeamsLoading ?? this.isTeamsLoading,
      isPlayersLoading: isPlayersLoading ?? this.isPlayersLoading,
      filteredTeams: filteredTeams ?? this.filteredTeams,
    );
  }
  
  @override
  List<Object?> get props => [
    teams, players, selectedTeams, selectedPlayers, 
    teamsToDelete, playersToDelete, isTeamsLoading, isPlayersLoading, filteredTeams
  ];
}

class SelectInterestsSuccess extends SelectInterestsState {
  const SelectInterestsSuccess();
}

 class SelectInterestsError extends SelectInterestsState {
  final String message;
  const SelectInterestsError({required this.message});
  @override
  List<Object?> get props => [message];
}
