

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
      final model = await remoteDataSource.getMyProfile();
      final entity = model.toEntity();
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
