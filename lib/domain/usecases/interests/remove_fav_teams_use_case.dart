import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class RemoveFavTeamsUseCase {
  final InterestsRepo repo;

  RemoveFavTeamsUseCase(this.repo);

  Future<Either<Failure, Unit>> call(List<String> teams) async {
    return await repo.removeFavTeams(teams);
  }
}
