import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class RemoveFavPlayersUseCase {
  final UserProfileRepo repo;

  RemoveFavPlayersUseCase(this.repo);

  Future<Either<Failure, Unit>> call(List<String> players) async {
    return await repo.removeFavPlayers(players);
  }
}