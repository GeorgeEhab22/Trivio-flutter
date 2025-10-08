import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl, Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ));

  Future<Map<String, dynamic>> get(String endPoint, {Map<String, dynamic>? query}) async {
    final res = await _dio.get(endPoint, queryParameters: query);
    return res.data;
  }

  Future<Map<String, dynamic>> post(String endPoint, {Map<String, dynamic>? data}) async {
    final res = await _dio.post(endPoint, data: data);
    return res.data;
  }
   Future<Map<String, dynamic>> patch(String endPoint, {Map<String, dynamic>? data}) async {
    final res = await _dio.patch(endPoint, data: data);
    return res.data;
  }
}
