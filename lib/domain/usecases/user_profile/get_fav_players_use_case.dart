import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetFavPlayersUseCase {
  final UserProfileRepo repo;

  GetFavPlayersUseCase(this.repo);

  Future<Either<Failure, List<String>>> call() async {
    return await repo.getFavPlayers();
  }
}