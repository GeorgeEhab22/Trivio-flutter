import 'package:auth/domain/usecases/user_profile/get_fav_players_use_case.dart';
import 'package:auth/domain/usecases/user_profile/remove_fav_players_use_case.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/fav_players_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavPlayersCubit extends Cubit<FavPlayersState> {
  final GetFavPlayersUseCase getFavPlayersUseCase;
  final RemoveFavPlayersUseCase removeFavPlayersUseCase;

  FavPlayersCubit({
    required this.getFavPlayersUseCase,
    required this.removeFavPlayersUseCase,
  }) : super(FavPlayersInitial());

  Future<void> fetchPlayers() async {
    emit(FavPlayersLoading());
    final result = await getFavPlayersUseCase();
    result.fold(
      (failure) => emit(FavPlayersError(failure.message)),
      (players) => emit(FavPlayersLoaded(players)),
    );
  }

  Future<void> deletePlayers(List<String> playersToRemove) async {
    final result = await removeFavPlayersUseCase(playersToRemove);
    result.fold(
      (failure) => emit(FavPlayersError(failure.message)),
      (_) => fetchPlayers(),
    );
  }
}
