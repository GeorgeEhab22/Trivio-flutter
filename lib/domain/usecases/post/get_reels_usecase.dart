import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';

class GetReelsUseCase {
  final PostRepo repository;

  GetReelsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call({int page = 1}) async {
    return await repository.getReels(page: page);
  }
}