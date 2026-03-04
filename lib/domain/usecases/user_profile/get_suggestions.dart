import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:auth/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetSuggestions {
  final UserProfileRepo repository;
  GetSuggestions(this.repository);

  Future<Either<Failure, List<UserProfilePreview>>> call() async {
    return await repository.getSuggestions();
  }
}
