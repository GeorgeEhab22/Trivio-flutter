import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/profile_remote_datasource.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class UserProfileRepositoryImpl implements UserProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfile>> getMyProfile() async {
    try {
      // final model = await remoteDataSource.getMyProfile();
      // final entity = model.toEntity();
      final dummyProfile = UserProfile(
        id: "65f1a2b3c4d5e6f7890abc12",
        name: "John Doe",
        email: "john.doe@example.com",
        role: "user",
        privacy: "private",
        followersCount: 42,
        followingCount: 15,
      );
      return Right(dummyProfile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateInterests({
    required List<String> favTeams,
    required List<String> favPlayers,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'favTeams': favTeams,
        'favPlayers': favPlayers,
      };

      final model = await remoteDataSource.updateInterests(updateData);
      print(model);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      print(e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      print(e);
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<String>>> getFavTeams() async {
    try {
      final teams = await remoteDataSource.getFavTeams();
      return Right(teams);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFavPlayers() async {
    try {
      final players = await remoteDataSource.getFavPlayers();
      return Right(players);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavTeams(List<String> teams) async {
    try {
      await remoteDataSource.removeFavTeams(teams);
      return const Right(unit); 
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavPlayers(List<String> players) async {
    try {
      await remoteDataSource.removeFavPlayers(players);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
