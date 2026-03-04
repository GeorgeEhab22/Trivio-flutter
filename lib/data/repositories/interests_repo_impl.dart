import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/interests_local_datasource.dart';
import 'package:auth/data/datasource/interests_remote_datasource.dart';
import 'package:auth/data/models/user_profile_model.dart';
import 'package:auth/domain/entities/player.dart';
import 'package:auth/domain/entities/team.dart';
import 'package:auth/domain/repositories/interests_repo.dart';
import 'package:auth/data/models/player_model.dart';
import 'package:dartz/dartz.dart';

class InterestsRepoImpl implements InterestsRepo {
  final InterestsRemoteDataSource remoteDatasource;
  final InterestsLocalDataSource localDatasource;

  InterestsRepoImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  bool _isCacheValid(DateTime? lastFetch) {
    if (lastFetch == null) return false;
    return DateTime.now().difference(lastFetch).inMinutes < 2;
  }

  @override
  Future<Either<Failure, List<Team>>> getAllTeams() async {
    try {
      final teams = await remoteDatasource.fetchTeams();
      return Right(teams);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Player>>> getAllPlayers() async {
    try {
      final cachedJson = localDatasource.getCachedPlayers();
      final lastFetch = localDatasource.getPlayersLastFetchTime();

      if (cachedJson != null && _isCacheValid(lastFetch)) {
        final cachedPlayers = cachedJson
            .map((json) => PlayerModel.fromJson(json))
            .toList();
        return Right(cachedPlayers);
      }

      final players = await remoteDatasource.fetchAllPlayers();
      await localDatasource.savePlayers(
        players.map((p) => (p).toJson()).toList(),
      );

      return Right(players);
    } on ServerException catch (e) {
      return _fallbackToPlayersCache(ServerFailure(e.message));
    } catch (e) {
      return _fallbackToPlayersCache(ServerFailure(e.toString()));
    }
  }

  Either<Failure, List<Player>> _fallbackToPlayersCache(Failure failure) {
    final cachedJson = localDatasource.getCachedPlayers();
    if (cachedJson != null) {
      return Right(
        cachedJson.map((json) => PlayerModel.fromJson(json)).toList(),
      );
    }
    return Left(failure);
  }

  @override
  Future<Either<Failure, List<Player>>> searchPlayersByName(
    String query,
  ) async {
    try {
      final cachedJson = localDatasource.getCachedSearchResults(query);
      final lastFetch = localDatasource.getSearchLastFetchTime(query);

      if (cachedJson != null && _isCacheValid(lastFetch)) {
        final cachedPlayers = cachedJson
            .map((json) => PlayerModel.fromJson(json))
            .toList();
        return Right(cachedPlayers);
      }

      final players = await remoteDatasource.searchPlayersByName(query);
      await localDatasource.saveSearchResults(
        query,
        players.map((p) => (p).toJson()).toList(),
      );
      return Right(players);
    } catch (e) {
      final cachedJson = localDatasource.getCachedSearchResults(query);
      if (cachedJson != null) {
        return Right(
          cachedJson.map((json) => PlayerModel.fromJson(json)).toList(),
        );
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSelectedFavTeams() async {
    try {
      final teams = await remoteDatasource.getFavTeams();
      return Right(teams);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSelectedFavPlayers() async {
    try {
      final players = await remoteDatasource.getFavPlayers();
      return Right(players);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavTeams(List<String> teams) async {
    try {
      await remoteDatasource.removeFavTeams(teams);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavPlayers(List<String> players) async {
    try {
      await remoteDatasource.removeFavPlayers(players);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> updateInterests({
    required List<String> favTeams,
    required List<String> favPlayers,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'favTeams': favTeams,
        'favPlayers': favPlayers,
      };
      final model = await remoteDatasource.updateInterests(updateData);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
