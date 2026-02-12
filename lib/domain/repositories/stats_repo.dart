import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:dartz/dartz.dart';

abstract class StatsRepository {
  Future<Either<Failure, List<Matches>>> fetchMatches();
}