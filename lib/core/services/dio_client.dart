import 'dart:io';


import 'package:dio/dio.dart';
import 'package:prayer_palace_admin/core/config/api_config.dart';
import 'package:prayer_palace_admin/core/services/api_exceptions.dart';
import 'package:prayer_palace_admin/core/services/dio_interceptor.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    bool validateStatus(int? status) {
      return (status ?? 500) < 400; // Accepts 2xx/3xx
    }

    _dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      validateStatus: validateStatus,
    );

    _dio.interceptors.addAll([DioInterceptor()]);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);

      return response;
    } on Exception catch (e) {
      throw ApiException.getException(e);
    }
  }

}

extension ResponseExtension on Response {
  bool get isSuccess {
    final is200 = statusCode == HttpStatus.ok;
    final is201 = statusCode == HttpStatus.created;
    return is201 || is200;
  }
}
