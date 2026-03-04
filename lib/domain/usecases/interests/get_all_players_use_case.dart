import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:auth/domain/entities/player.dart';

class GetAllPlayersUseCase {
  final InterestsRepo repo;

  GetAllPlayersUseCase(this.repo);

  Future<Either<Failure, List<Player>>> call({
    List<String>? favPlayers,
    bool isEdit = false,
  }) async {
    final result = await repo.getAllPlayers();

    if (result.isLeft()) return result;

    List<Player> finalPlayersList = List.from(result.getOrElse(() => []));
    final safeFavPlayers = favPlayers ?? [];

    // fallback
    if (isEdit && safeFavPlayers.isNotEmpty) {
      List<String> currentNames = finalPlayersList.map((p) => p.name).toList();

      for (String favName in safeFavPlayers) {
        if (!currentNames.contains(favName)) {
          final searchResult = await repo.searchPlayersByName(favName);
          bool isPlayerAdded = false;

          searchResult.fold((_) {}, (searchedPlayers) {
            try {
              final match = searchedPlayers.firstWhere(
                (p) => p.name == favName,
              );
              finalPlayersList.insert(0, match);
              isPlayerAdded = true;
            } catch (_) {}
          });

          if (!isPlayerAdded) {
            finalPlayersList.insert(
              0,
              Player(
                idTeam: 'fallback_team',
                id: 'fallback_id',
                name: favName,
                playerImage: '',
              ),
            );
          }
        }
      }
    }

    finalPlayersList.sort((a, b) {
      bool aSelected = safeFavPlayers.contains(a.name);
      bool bSelected = safeFavPlayers.contains(b.name);
      if (aSelected && !bSelected) return -1;
      if (!aSelected && bSelected) return 1;
      return 0;
    });

    return Right(finalPlayersList);
  }
}
