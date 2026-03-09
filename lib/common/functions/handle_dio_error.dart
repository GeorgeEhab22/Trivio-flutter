import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:auth/data/core/error/exceptions.dart';

class ErrorHandler {
  void handleDioError(Object error) {
    if (error is DioException) {
      dynamic errorData = error.response?.data;
      
      String errorKey = 'unexpected_error'; 

      if (errorData is String) {
        try {
          errorData = jsonDecode(errorData);
        } catch (_) {}
      }

      if (errorData is Map) {
        if (errorData['message'] != null) {
          errorKey = errorData['message'].toString();
        } else if (errorData['error'] is Map && errorData['error']['message'] != null) {
          errorKey = errorData['error']['message'].toString();
        } else if (errorData['error'] is String) {
          errorKey = errorData['error'].toString();
        }
      }

      throw ServerException(errorKey);
    } else if (error is SocketException) {
      throw NetworkException('no_internet');
    } else {
      throw ServerException('unexpected_error');
    }
  }
}