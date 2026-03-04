import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class GetSelectedFavTeamsUseCase {
  final InterestsRepo repo;

  GetSelectedFavTeamsUseCase(this.repo);

  Future<Either<Failure, List<String>>> call() async {
    return await repo.getSelectedFavTeams();
  }
}
