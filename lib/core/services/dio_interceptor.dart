import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    debugPrint('Error massage: ${err.message}');
    debugPrint('Error on path: ${err.requestOptions.path}');
    debugPrint('Error data: $data');
    debugPrint("Status code $statusCode");
    debugPrint("Error type ${err.type}");

    switch (statusCode) {
      case 400:
        final errorMessage = _parseErrorMessage(data);
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: errorMessage,
            response: err.response,
          ),
        );
        break;
      case 404:
        // Handle not found error
        if (err.response?.data is Map) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: err.response?.data?['message'] ?? 'Resource not found',
              response: err.response,
            ),
          );
        } else {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: err.response?.data?.statusMessage ?? 'Resource not found',
              response: err.response,
            ),
          );
        }
        break;
      case 500:
        // Handle server error
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Internal server error',
            response: err.response,
          ),
        );
        break;
      default:
        handler.reject(err);
    }
  }

  String _parseErrorMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? 'Bad request';
      }
      return 'Bad request';
    } catch (e) {
      return 'Bad request';
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log('Request url ${options.method} ${options.uri}');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      'Response data for ${response.requestOptions.path}: ${jsonEncode(response.data)}',
    );

    handler.next(response);
  }
}
