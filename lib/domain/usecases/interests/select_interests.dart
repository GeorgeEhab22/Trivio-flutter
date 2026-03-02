import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class SelectInterestsUseCase {
  final InterestsRepo repo;

  SelectInterestsUseCase(this.repo);

  Future<Either<Failure, void>> call({
    required List<String> favTeams,
    required List<String> favPlayers,
    required List<String> teamsToDelete,
    required List<String> playersToDelete,
  }) async {
    try {
      if (favTeams.isEmpty &&
          favPlayers.isEmpty &&
          teamsToDelete.isEmpty &&
          playersToDelete.isEmpty) {
        return const Right(null);
      }

      if (teamsToDelete.isNotEmpty) {
        await repo.removeFavTeams(teamsToDelete);
      }

      if (playersToDelete.isNotEmpty) {
        await repo.removeFavPlayers(playersToDelete);
      }

      return await repo.updateInterests(
        favTeams: favTeams,
        favPlayers: favPlayers,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
