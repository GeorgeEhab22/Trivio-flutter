import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/interests_remote_datasource.dart';
import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/entities/team.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:dartz/dartz.dart';

class InterestsRepoImpl implements InterestsRepo {
  final InterestsRemoteDataSource remoteDatasource;

  InterestsRepoImpl({
    required this.remoteDatasource,
  });

  @override
  Future<Either<Failure, List<Team>>> getAllTeams() async {
    print('--> Repo: getAllTeams called');
    try {
      final teams = await remoteDatasource.fetchTeams();
      print('--> Repo: getAllTeams Success. Count: ${teams.length}');
      return Right(teams);
    } catch (e) {
      print('--> Repo: getAllTeams Failed. Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Player>>> getAllPlayers() async {
    print('--> Repo: getAllPlayers called');
    try {
      final players = await remoteDatasource.fetchAllPlayers();
      print('--> Repo: getAllPlayers Success. Count: ${players.length}');
      return Right(players);
    } catch (e) {
      print('--> Repo: getAllPlayers Failed. Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSelectedFavTeams() async {
    print('--> Repo: getSelectedFavTeams called');
    try {
      final teams = await remoteDatasource.getFavTeams();
      return Right(teams);
    } on ServerException catch (e) {
      print('--> Repo: getSelectedFavTeams Failed. Error: ${e.message}');
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSelectedFavPlayers() async {
    print('--> Repo: getSelectedFavPlayers called');
    try {
      final players = await remoteDatasource.getFavPlayers();
      return Right(players);
    } on ServerException catch (e) {
      print('--> Repo: getSelectedFavPlayers Failed. Error: ${e.message}');
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavTeams(List<String> teams) async {
    print('--> Repo: removeFavTeams called with: $teams');
    try {
      await remoteDatasource.removeFavTeams(teams);
      return const Right(unit);
    } on ServerException catch (e) {
      print('--> Repo: removeFavTeams Failed. Error: ${e.message}');
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavPlayers(List<String> players) async {
    print('--> Repo: removeFavPlayers called with: $players');
    try {
      await remoteDatasource.removeFavPlayers(players);
      return const Right(unit);
    } on ServerException catch (e) {
      print('--> Repo: removeFavPlayers Failed. Error: ${e.message}');
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateInterests({
    required List<String> favTeams,
    required List<String> favPlayers,
  }) async {
    print('--> Repo: updateInterests called. favTeams: $favTeams, favPlayers: $favPlayers');
    try {
      final Map<String, dynamic> updateData = {
        'favTeams': favTeams,
        'favPlayers': favPlayers,
      };

      final model = await remoteDatasource.updateInterests(updateData);
      print('--> Repo: updateInterests Success');
      return Right(model.toEntity());
    } on ServerException catch (e) {
      print('--> Repo: updateInterests Failed. Error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('--> Repo: updateInterests Failed. Exception: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}