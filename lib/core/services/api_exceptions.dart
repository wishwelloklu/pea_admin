// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show ClientException;

/// custom exception class for handling exceptions in the api_client
class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  // ignore: prefer_constructors_over_static_methods, type_annotate_public_apis
  static ApiException getException(err) {
    log('error ${err.response}');
    if (err is ApiException) {
      log('error ApiException $err');
      return err;
    } else {
      switch (err.type) {
        // if the request was cancelled
        case DioExceptionType.cancel:
          return OtherExceptions(kRequestCancelledError);

        // timeout errors
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return InternetConnectException(kTimeOutError);

        // others - handle other types of custom exceptions here
        case DioExceptionType.unknown:
          // format exception

          if (err.error is FormatException) {
            return FormatException();
          }

          // socket exception
          if (err.error is SocketException) {
            return InternetConnectException(kInternetConnectionError);
          }
          if (err.response.data is Map) {
            if (err.response.data['message'] is List) {
              return OtherExceptions(err.response.data['message'][0]);
            }
            return OtherExceptions(err.response.data['message']);
          }
          return OtherExceptions(err.response.data?.message);

        case DioExceptionType.badResponse:
          try {
            if (err.response?.data != null &&
                err.response?.data is Map<dynamic, dynamic>) {
              debugPrint('DioError has data');
              String errorMsg = (err.response?.data as Map)['message'];
              debugPrint(
                  'DioError:: $errorMsg  || ${err.response?.statusCode}');
              if ((err.response?.statusCode == 401 ||
                      err.response?.statusCode == 403) &&
                  errorMsg.toLowerCase().contains('invalid token')) {
                debugPrint('Due for a refresh-token call');
                return UnAuthorizedException();
              }
              return OtherExceptions((err.response?.data as Map)['message']);
            } else {
              debugPrint('DioError has no data');
              switch (err.response?.statusCode) {
                case 500:
                  return InternalServerException();
                case 404:
                  return OtherExceptions(kNotFoundError);
                case 502:
                  return OtherExceptions(kNotFoundError);
                case 400:
                  return OtherExceptions(kBadRequestError);
                case 403:
                  ClientException(err.response?.statusMessage);
                case 401:
                  return UnAuthorizedException();
                case 413:
                  return OtherExceptions(kFileTooLarge);
                default:
                  // default exception error message
                  return OtherExceptions(kDefaultError);
              }
            }
          } catch (err) {
            return OtherExceptions(kDefaultError);
          }
      }
      // default exception error message
      if (err.response?.data is Map) {
        return OtherExceptions(err.response?.data?['message'] ?? kDefaultError);
      }
      return OtherExceptions(
          err.response?.data?.statusMessage ?? kDefaultError);
    }
  }
}

class OtherExceptions implements ApiException {
  OtherExceptions(this.newMessage);

  final String newMessage;

  @override
  String toString() => message;

  @override
  String get message => newMessage;
}

class FormatException implements ApiException {
  @override
  String toString() => message;

  @override
  String get message => kFormatError;
}

class InternetConnectException implements ApiException {
  InternetConnectException(this.newMessage);

  final String newMessage;

  @override
  String toString() => message;

  @override
  String get message => newMessage;
}

class InternalServerException implements ApiException {
  @override
  String toString() {
    return message;
  }

  @override
  String get message => kServerError;
}

class UnAuthorizedException implements ApiException {
  @override
  String toString() {
    return message;
  }

  @override
  String get message => kUnAuthorizedError;
}

class CacheException implements Exception {
  CacheException(this.message) : super();

  String message;

  @override
  String toString() {
    return message;
  }
}

// exceptions messages
// const kInternetConnectionError = 'No internet connection, try again.';
const kInternetConnectionError = 'Connection error. Please try again.';
const kTimeOutError = 'Request timed out. Please try again.';
const kServerError = 'Something went wrong, try again.';
const kFormatError = 'Unable to process data at this time.';
const kUnAuthorizedError = 'Session expired, please login to proceed.';
const kDefaultError = 'Oops something went wrong!';
const kBadRequestError = 'Bad request, please try again.';
const kFileTooLarge = 'File too large.';
const kNotFoundError = 'An error occured, please try again.';
const kRequestCancelledError = 'Request to server was cancelled.';
const kfileTooLargeError = 'File too large.';
