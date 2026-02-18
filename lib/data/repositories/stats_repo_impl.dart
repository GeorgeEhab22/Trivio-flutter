import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/stats_local_datasource.dart';
import 'package:auth/data/datasource/stats_remote_datasource.dart';
import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/domain/repositories/stats_repo.dart';
import 'package:dartz/dartz.dart';

class StatsRepoImpl extends StatsRepository {
  final StatsRemoteDatasource remoteDatasource;
  final StatsLocalDatasource localDatasource;

  StatsRepoImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, List<Matches>>> fetchMatches() async {
    try {
      final List<dynamic>? cachedJson = localDatasource.getCachedMatches();
      final DateTime? lastFetch = localDatasource.getLastFetchTime();

      if (cachedJson != null && lastFetch != null) {
        final List<Matches> cachedMatches = _parseMatches(cachedJson);
        final now = DateTime.now();

        final bool isMatchLive = cachedMatches.any(
          (m) => m.status == 'IN_PLAY',
        );
        final int refreshThreshold = isMatchLive ? 1 : 20;

        if (now.difference(lastFetch).inMinutes < refreshThreshold) {
          return Right(cachedMatches);
        }
      }
      final matches = await remoteDatasource.fetchMatches();

      return Right(matches);
    } on ServerException catch (e) {
      return _fallbackToCache(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return _fallbackToCache(NetworkFailure(e.message));
    } catch (e) {
      return _fallbackToCache(ServerFailure(e.toString()));
    }
  }

  Either<Failure, List<Matches>> _fallbackToCache(Failure failure) {
    final cachedJson = localDatasource.getCachedMatches();
    if (cachedJson != null) {
      return Right(_parseMatches(cachedJson));
    }
    return Left(failure);
  }

List<Matches> _parseMatches(List<dynamic> jsonList) {
  return jsonList.map((item) {
    final Map<String, dynamic> safeMap = (item as Map).map(
      (key, value) => MapEntry(key.toString(), value),
    );
    
    return Matches.fromMap(safeMap);
  }).toList();
}
}
