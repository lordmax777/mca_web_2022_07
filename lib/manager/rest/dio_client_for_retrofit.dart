import 'dart:developer';

import "package:dio/dio.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

class DioClientForRetrofit {
  final String? bearerToken;
  final String? contentType;
  final ResponseType responseType;
  DioClientForRetrofit(
      {this.bearerToken,
      this.contentType,
      this.responseType = ResponseType.json});

  Map<String, dynamic>? get headers {
    if (bearerToken != null) {
      return {
        "Authorization": "Bearer $bearerToken",
        "Content-Type": contentType ?? "application/json",
        "Accept": "application/json",
        "Accept-Encoding": 'gzip,compress'
      };
    }
    return {
      "Content-Type": contentType ?? "application/json",
      "Accept": "application/json",
      "Accept-Encoding": "gzip,compress"
    };
  }

  Dio init({List<Interceptor>? customInterceptors, bool prettyLog = true}) {
    Dio _dio = Dio();

    if (prettyLog) {
      _dio.interceptors.add(loggerInterceptor);
    }
    if (customInterceptors != null && customInterceptors.isNotEmpty) {
      _dio.interceptors.addAll(customInterceptors);
    }
    BaseOptions options = BaseOptions(
        headers: headers,
        responseType: responseType,
        receiveDataWhenStatusError: true);
    _dio.options = options;
    return _dio;
  }
}

final loggerInterceptor =
    InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
  String headers = "";
  options.headers.forEach((key, value) {
    headers += "| $key: $value";
  });
  Logger.d("| [DIO] Request: ${options.method} ${options.uri}");
  Logger.d(
      "| [DIO] Options: ${options.data != null ? options.data.toString() : ''}");
  Logger.d("| [DIO] Headers: $headers");

  handler.next(options); //continue
}, onResponse: (Response response, handler) async {
  Logger.i(
      "| [DIO] Response [code ${response.statusCode}]: ${response.data.toString().length > 1000 ? response.data.toString().substring(0, 1000) : response.data.toString()}");
  handler.next(response);
  // return response; // continue
}, onError: (DioError error, handler) async {
  Logger.e("| [DIO] Error: ${error.error}: ${error.response?.toString()}");
  handler.next(error); //continue
});
