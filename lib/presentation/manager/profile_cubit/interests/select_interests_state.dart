import 'package:equatable/equatable.dart';

abstract class SelectInterestsState extends Equatable {
  const SelectInterestsState();
  @override
  List<Object?> get props => [];
}

class SelectInterestsInitial extends SelectInterestsState {
  final List<String> selectedTeams;
  final List<String> selectedPlayers;

  const SelectInterestsInitial({
    this.selectedTeams = const [],
    this.selectedPlayers = const [],
  });

  SelectInterestsInitial copyWith({
    List<String>? selectedTeams,
    List<String>? selectedPlayers,
  }) {
    return SelectInterestsInitial(
      selectedTeams: selectedTeams ?? this.selectedTeams,
      selectedPlayers: selectedPlayers ?? this.selectedPlayers,
    );
  }

  @override
  List<Object?> get props => [selectedTeams, selectedPlayers];
}

class SelectInterestsLoading extends SelectInterestsState {
  const SelectInterestsLoading();
}

class SelectInterestsSuccess extends SelectInterestsState {
  const SelectInterestsSuccess();
}

class SelectInterestsError extends SelectInterestsState {
  final String message;
  const SelectInterestsError(this.message);
  @override
  List<Object?> get props => [message];
}
