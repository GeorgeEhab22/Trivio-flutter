import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class GetAllPlayersUseCase {
  final InterestsRepo repo;

  GetAllPlayersUseCase(this.repo);

  Future<Either<Failure, List<Player>>> call() async {
    return await repo.getAllPlayers();
  }
}