import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:auth/domain/entities/team.dart';

class GetAllTeamsUseCase {
  final InterestsRepo repo;
  GetAllTeamsUseCase(this.repo);

  Future<Either<Failure, List<Team>>> call({List<String>? favTeams}) async {
    final result = await repo.getAllTeams();

    return result.map((teams) {
      if (favTeams == null || favTeams.isEmpty) return teams;

      List<Team> sortedList = List.from(teams);
      sortedList.sort((a, b) {
        bool aSelected = favTeams.contains(a.name);
        bool bSelected = favTeams.contains(b.name);
        if (aSelected && !bSelected) return -1;
        if (!aSelected && bSelected) return 1;
        return 0;
      });
      return sortedList;
    });
  }
}
