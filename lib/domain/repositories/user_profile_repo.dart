import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:dartz/dartz.dart';

abstract class UserProfileRepo {
  Future<Either<Failure, UserProfile>> getMyProfile();

  Future<Either<Failure, UserProfile>> updateInterests({
    required List<String> favTeams,
    required List<String> favPlayers,
  });
  Future<Either<Failure, List<String>>> getFavTeams();
  Future<Either<Failure, List<String>>> getFavPlayers();
  Future<Either<Failure, Unit>> removeFavTeams(List<String> teams);
  Future<Either<Failure, Unit>> removeFavPlayers(List<String> players);
}
