import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class RemoveFavPlayersUseCase {
  final InterestsRepo repo;

  RemoveFavPlayersUseCase(this.repo);

  Future<Either<Failure, Unit>> call(List<String> players) async {
    return await repo.removeFavPlayers(players);
  }
}
