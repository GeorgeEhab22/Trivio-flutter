import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/face_recognition_remote_datasource.dart';
import 'package:auth/domain/entities/tags.dart';
import 'package:auth/domain/repositories/face_recognition_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class FaceRecognitionRepoImpl implements FaceRecognitionRepo {
  final FaceRecognitionRemoteDataSource remoteDatasource;

  FaceRecognitionRepoImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<Tags>>> recognizeFaces(XFile file) async {
    try {
      final tagsModels = await remoteDatasource.recognizeFaces(file);
      return Right(tagsModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
