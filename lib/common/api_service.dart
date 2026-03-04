import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;
  final Future<String?> Function()? getToken;

  ApiService({required this.baseUrl, Dio? dio, this.getToken})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            )){
    //this is to save the token in the header of every request if it exists automatically without the need to pass it in every request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Use the callback to get the token if it exists
        final token = await getToken!();
  print("📤 SENDING TOKEN: Bearer $token");
        if (getToken != null) {
          final token = await getToken!();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
    ));
  }

  // 1. Added 'options' parameter
  Future<Map<String, dynamic>> get(
    String endPoint, {
    Map<String, dynamic>? query,
    Options? options, 
  }) async {
    final res = await _dio.get(
      endPoint,
      queryParameters: query,
      options: options, // Pass it to Dio
    );
    return res.data;
  }

  // 2. Changed 'data' to dynamic (to accept FormData) AND added 'options'
  Future<Map<String, dynamic>> post(
    String endPoint, {
    dynamic data, 
    Options? options,
  }) async {
    final res = await _dio.post(
      endPoint,
      data: data,
      options: options,
    );
    return res.data;
  }

  Future<Map<String, dynamic>> patch(
    String endPoint, {
    dynamic data, // Changed to dynamic
    Options? options, // Added options
  }) async {
    //FILE upload handling 
    if (data is Map<String, dynamic>) {
    // Check if any value in the map is a MultipartFile
    bool hasFile = data.values.any((value) => value is MultipartFile);
    
    if (hasFile) {
      data = FormData.fromMap(data); // Convert Map to FormData for Dio
      // Optional: Dio usually overrides this automatically, but this is safer
      options ??= Options();
      options.headers ??= {};
      options.headers!['Content-Type'] = 'multipart/form-data';
    }
  }
    final res = await _dio.patch(
      endPoint,
      data: data,
      options: options,
    );
    return res.data;
  }

  Future< dynamic> delete(
    String endPoint, {
    dynamic data, // Changed to dynamic
    Options? options, // Added options
  }) async {
    final res = await _dio.delete(
      endPoint,
      data: data,
      options: options,
    );
    if (res.data == null || res.data == "") {
    return <String, dynamic>{}; 
  }
    return res.data;
  }

  Future<Map<String, dynamic>> put(
    String endPoint, {
    dynamic data, // Changed to dynamic
    Options? options, // Added options
  }) async {
    final res = await _dio.put(
      endPoint,
      data: data,
      options: options,
    );
    return res.data;
  }
}