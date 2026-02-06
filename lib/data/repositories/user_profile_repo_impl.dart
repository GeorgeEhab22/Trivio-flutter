import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/profile_remote_datasource.dart';
import 'package:auth/data/models/user_model.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class UserProfileRepoImpl implements UserProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  UserProfileRepoImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<UserModel>>> getFollowRequests() async {
    try {
      final users = await remoteDataSource.getFollowRequests();
      return Right(users);
    } on NetworkException catch (e){
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unexpected error occurred while fetching follow requests'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> acceptFollowRequest({
    required String requestId,
  }) async {
    try {
      final user =
          await remoteDataSource.acceptFollowRequest(requestId: requestId);
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unexpected error occurred while accepting follow request'));
    }
  }

  @override
  Future<Either<Failure, Unit>> declineFollowRequest({
    required String requestId,
  }) async {
    try {
      await remoteDataSource.declineFollowRequest(requestId: requestId);
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unexpected error occurred while declining follow request'));
    }
  }
}
