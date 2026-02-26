import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class SelectInterestsUseCase {
  final InterestsRepo repo;
  SelectInterestsUseCase(this.repo);
  Future<Either<Failure, void>> call({
    required List<String> favTeams,
    required List<String> favPlayers,
  }) async {
    return await repo.updateInterests(
      favTeams: favTeams,
      favPlayers: favPlayers,
    );
  }
}
