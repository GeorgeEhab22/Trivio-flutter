import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/domain/repositories/stats_repo.dart';
import 'package:dartz/dartz.dart';

class StatsUseCase {
  final StatsRepository statsRepository;
  
  StatsUseCase(this.statsRepository);

  Future<Either<Failure, List<Matches>>> call() async {
    final result = await statsRepository.fetchMatches();
    
    return result.fold(
      (failure) => Left(failure),
      (allMatches) {
        const allowedLeagues = ['PL', 'PD', 'SA'];

        return Right(allMatches.where((match) {
          final code = match.competition?.code;
          return allowedLeagues.contains(code);
        }).toList());
      },
    );
  }
}