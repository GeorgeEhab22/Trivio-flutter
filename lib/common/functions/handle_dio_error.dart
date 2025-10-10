import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:auth/data/core/error/exceptions.dart';

class ErrorHandler {
  void handleDioError(Object error) {
    if (error is DioException) {
      dynamic errorData = error.response?.data;
      String errorMessage = 'An unexpected error occurred';

      if (errorData is String) {
        try {
          errorData = jsonDecode(errorData);
        } catch (_) {
        }
      }

      if (errorData is Map) {
        if (errorData['message'] != null) {
          errorMessage = errorData['message'].toString();
        } else if (errorData['error'] is Map && errorData['error']['message'] != null) {
          errorMessage = errorData['error']['message'].toString();
        } else if (errorData['error'] is String) {
          errorMessage = errorData['error'].toString();
        }
      }

      throw ServerException(errorMessage);
    } else if (error is SocketException) {
      throw NetworkException('No internet connection');
    } else {
      throw ServerException('Unexpected error occurred');
    }
  }
}
