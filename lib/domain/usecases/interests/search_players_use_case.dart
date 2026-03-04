import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:auth/domain/entities/player.dart';

class SearchPlayersUseCase {
  final InterestsRepo repo;

  SearchPlayersUseCase(this.repo);

  Future<Either<Failure, List<Player>>> call(
    String query, {
    List<String>? favPlayers,
  }) async {
    if (query.trim().length < 3) {
      return Left(ValidationFailure('Please enter at least 3 characters'));
    }

    final result = await repo.searchPlayersByName(query);

    return result.map((players) {
      if (favPlayers == null || favPlayers.isEmpty) return players;

      List<Player> sortedList = List.from(players);
      sortedList.sort((a, b) {
        bool aSelected = favPlayers.contains(a.name);
        bool bSelected = favPlayers.contains(b.name);
        if (aSelected && !bSelected) return -1;
        if (!aSelected && bSelected) return 1;
        return 0;
      });
      return sortedList;
    });
  }
}
