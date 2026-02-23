import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/usecases/user_profile/select_interests.dart';
import 'select_interests_state.dart';

class SelectInterestsCubit extends Cubit<SelectInterestsState> {
  final SelectInterestsUseCase selectInterestsUseCase;

  SelectInterestsCubit({required this.selectInterestsUseCase})
    : super(const SelectInterestsInitial());

  void toggleTeam(String teamName) {
    if (state is SelectInterestsInitial) {
      final currentState = state as SelectInterestsInitial;
      final updatedTeams = List<String>.from(currentState.selectedTeams);

      if (updatedTeams.contains(teamName)) {
        updatedTeams.remove(teamName);
      } else {
        updatedTeams.add(teamName);
      }

      emit(
        SelectInterestsInitial(
          selectedTeams: updatedTeams,
          selectedPlayers: currentState.selectedPlayers,
        ),
      );
    }
  }

  void togglePlayer(String playerName) {
    if (state is SelectInterestsInitial) {
      final currentState = state as SelectInterestsInitial;
      final updatedPlayers = List<String>.from(currentState.selectedPlayers);

      if (updatedPlayers.contains(playerName)) {
        updatedPlayers.remove(playerName);
      } else {
        updatedPlayers.add(playerName);
      }

      emit(
        SelectInterestsInitial(
          selectedTeams: currentState.selectedTeams,
          selectedPlayers: updatedPlayers,
        ),
      );
    }
  }

  Future<void> submitInterests() async {
    if (state is SelectInterestsInitial) {
      final currentState = state as SelectInterestsInitial;

      emit(SelectInterestsLoading());

      final result = await selectInterestsUseCase(
        favTeams: currentState.selectedTeams,
        favPlayers: currentState.selectedPlayers,
      );

      result.fold(
        (failure) => emit(SelectInterestsError(failure.message)),
        (userProfile) => emit(SelectInterestsSuccess()),
      );
    }
  }
}
