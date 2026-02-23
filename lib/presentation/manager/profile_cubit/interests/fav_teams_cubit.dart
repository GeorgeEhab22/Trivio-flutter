import 'package:auth/domain/usecases/user_profile/get_fav_teams_use_case.dart';
import 'package:auth/domain/usecases/user_profile/remove_fav_teams_use_case.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/fav_teams_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavTeamsCubit extends Cubit<FavTeamsState> {
  final GetFavTeamsUseCase getFavTeamsUseCase;
  final RemoveFavTeamsUseCase removeFavTeamsUseCase;

  FavTeamsCubit({required this.getFavTeamsUseCase, required this.removeFavTeamsUseCase}) 
      : super(FavTeamsInitial());

  Future<void> fetchTeams() async {
    emit(FavTeamsLoading());
    final result = await getFavTeamsUseCase();
    result.fold(
      (failure) => emit(FavTeamsError(failure.message)),
      (teams) => emit(FavTeamsLoaded(teams)),
    );
  }

  Future<void> deleteTeams(List<String> teamsToRemove) async {
    final result = await removeFavTeamsUseCase(teamsToRemove);
    result.fold(
      (failure) => emit(FavTeamsError(failure.message)),
      (_) => fetchTeams(), 
    );
  }
}