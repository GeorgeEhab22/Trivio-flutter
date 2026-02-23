import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class RemoveFavTeamsUseCase {
  final UserProfileRepo repo;

  RemoveFavTeamsUseCase(this.repo);

  Future<Either<Failure, Unit>> call(List<String> teams) async {
    return await repo.removeFavTeams(teams);
  }
}