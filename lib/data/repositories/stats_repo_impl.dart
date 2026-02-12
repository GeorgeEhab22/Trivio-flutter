import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/stats_remote_datasource.dart';
import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/domain/repositories/stats_repo.dart';
import 'package:dartz/dartz.dart';

class StatsRepoImpl extends StatsRepository {
  final StatsRemoteDatasource remoteDatasource;
  StatsRepoImpl({required this.remoteDatasource});
  @override
  Future<Either<Failure, List<Matches>>> fetchMatches() async {
    try {
      final matches = await remoteDatasource.fetchMatches();
      return Right(matches);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e, stacktrace) {
      print("Repository Error: $e"); // Check your console for the real error
      print("Stacktrace: $stacktrace");
      return Left(ServerFailure(e.toString()));
    }
  }
}
