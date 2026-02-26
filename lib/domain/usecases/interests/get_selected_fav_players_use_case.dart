import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class GetSelectedFavPlayersUseCase {
  final InterestsRepo repo;

  GetSelectedFavPlayersUseCase(this.repo);

  Future<Either<Failure, List<String>>> call() async {
    return await repo.getSelectedFavPlayers();
  }
}
