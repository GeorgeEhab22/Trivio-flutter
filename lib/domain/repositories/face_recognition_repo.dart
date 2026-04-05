import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/tags.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class FaceRecognitionRepo {
  Future<Either<Failure, List<Tags>>> recognizeFaces(XFile file);
}
