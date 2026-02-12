import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/domain/repositories/stats_repo.dart';

class StatsUseCase {
  final StatsRepository statsRepository;
  
  StatsUseCase(this.statsRepository);

  Future<List<Matches>> call() async {
    final result = await statsRepository.fetchMatches();
    
    return result.fold(
      (failure) => throw Exception(failure.toString()),
      (allMatches) {
        const allowedLeagues = ['PL', 'PD', 'SA'];

        return allMatches.where((match) {
          final code = match.competition?.code;
          return allowedLeagues.contains(code);
        }).toList();
      },
    );
  }
}