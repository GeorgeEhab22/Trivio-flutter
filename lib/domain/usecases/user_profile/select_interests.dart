import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class SelectInterestsUseCase {
  final UserProfileRepo repo;
  SelectInterestsUseCase(this.repo);
  Future<Either<Failure, UserProfile>> call({
    required List<String> favTeams,
    required List<String> favPlayers,
  }) async {
    return await repo.updateInterests(
      favTeams: favTeams,
      favPlayers: favPlayers,
    );
  }
}
