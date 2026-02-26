import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/team.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class GetAllTeamsUseCase {
  final InterestsRepo repo;
  GetAllTeamsUseCase(this.repo);

  Future<Either<Failure, List<Team>>> call() async {
    return await repo.getAllTeams();
  }
}
