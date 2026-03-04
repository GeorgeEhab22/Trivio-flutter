import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/entities/team.dart';
import 'package:dartz/dartz.dart';

abstract class InterestsRepo {
  Future<Either<Failure, List<Team>>> getAllTeams();
  Future<Either<Failure, List<Player>>> getAllPlayers();

  Future<Either<Failure, List<String>>> getSelectedFavTeams();
  Future<Either<Failure, List<String>>> getSelectedFavPlayers();
  Future<Either<Failure, Unit>> removeFavTeams(List<String> teams);
  Future<Either<Failure, Unit>> removeFavPlayers(List<String> players);
  Future<Either<Failure, void>> updateInterests({
    required List<String> favTeams,
    required List<String> favPlayers,
  });
  Future<Either<Failure, List<Player>>> searchPlayersByName(String query);
}
