import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/models/tags_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

abstract class FaceRecognitionRemoteDataSource {
  Future<List<TagsModel>> recognizeFaces(XFile file);
}

class FaceRecognitionRemoteDataSourceImpl
    implements FaceRecognitionRemoteDataSource {
  final Dio dio;
  final ErrorHandler errorHandler;

  static const String _baseUrl =
      'https://ahmed-ashraf-00-trivio-face-id.hf.space';

  FaceRecognitionRemoteDataSourceImpl({
    required this.dio,
    required this.errorHandler,
  });

  @override
  Future<List<TagsModel>> recognizeFaces(XFile file) async {
    try {
      final fileBytes = await file.readAsBytes();

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: file.name),
      });

      final response = await dio.post('$_baseUrl/recognize', data: formData);

      if (response.statusCode == 200) {
        final List<dynamic> playersList = response.data['players'] ?? [];

        return playersList
            .map((json) => TagsModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to recognize faces: ${response.statusCode}',
        );
      }
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
