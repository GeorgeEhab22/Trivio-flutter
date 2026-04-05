import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/tags.dart';
import 'package:auth/domain/repositories/face_recognition_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class AutoTaggingUseCase {
  final FaceRecognitionRepo repo;

  AutoTaggingUseCase(this.repo);

  Future<Either<Failure, List<Tags>>> call(XFile file) async {
    return await repo.recognizeFaces(file);
  }
}
