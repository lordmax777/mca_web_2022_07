import 'dart:async';

import "package:dio/dio.dart";
import 'package:flutter_easylogger/flutter_logger.dart';

import 'package:mca_web_2022_07/theme/theme.dart';

import '../models/auth.dart';
import '../redux/sets/app_state.dart';
import '../redux/sets/state_value.dart';
import '../redux/states/auth_state.dart';

class TokenHandler {
  static DateTime tokenStartTime = DateTime.now();
  static int tokenExpireTime = 6; // in minutes

  static Future<void> handleOnExpire(RequestOptions options) async {
    final DateTime now = DateTime.now();
    final int diff = now.difference(tokenStartTime).inMinutes;
    if (options.path != "/oauth/v2/token") {
      if (diff >= tokenExpireTime) {
        logger("The Difference is $diff minutes");
        final StateValue<AuthRes> res =
            await appStore.dispatch(GetRefreshTokenAction(doInitFunc: false));
        options.headers["Authorization"] = "Bearer ${res.data?.access_token}";
        tokenExpireTime = res.data!.expires_in ~/ 100;
        logger("Token Expired and Renewed at ${now.toIso8601String()}");
      }
    }
  }

  static Future<void> handleOnSetTime(Response response) async {
    final DateTime tokenRequestTime = DateTime.now();

    if (response.requestOptions.path == '/oauth/v2/token') {
      if (response.statusCode == 200) {
        tokenStartTime = DateTime.now();
        tokenExpireTime = response.data["expires_in"] ~/ 100;
        logger("Token Set at ${tokenRequestTime.toIso8601String()}");
        logger("Token Start Time $tokenStartTime");
        logger("Token Expire Time $tokenExpireTime");
      }
    }
  }

  static InterceptorsWrapper interceptor =
      InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
    await handleOnExpire(options);
    handler.next(options); //continue
  }, onResponse: (Response response, handler) async {
    await handleOnSetTime(response);
    handler.next(response);
  }, onError: (DioError error, handler) async {
    handler.next(error); //continue
  });
}

class DioClientForRetrofit {
  final String? bearerToken;
  final String? contentType;
  final ResponseType responseType;
  final String? baseUrl;
  DioClientForRetrofit(
      {this.bearerToken,
      this.contentType,
      this.baseUrl,
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
    Dio dio = Dio();

    if (prettyLog) {
      dio.interceptors.add(loggerInterceptor);
      dio.interceptors.add(TokenHandler.interceptor);
    }
    if (customInterceptors != null && customInterceptors.isNotEmpty) {
      dio.interceptors.addAll(customInterceptors);
    }
    // _dio.interceptors.add(tokenInterceptor);
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl ?? Constants.apiBaseUrl,
      headers: headers,
      responseType: responseType,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      followRedirects: false,
    );
    dio.options = options;
    return dio;
  }
}

final loggerInterceptor =
    InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
  String headers = "";
  options.headers.forEach((key, value) {
    headers += "| $key: $value";
  });
  Logger.d("| [API_Request]: ${options.method} ${options.uri}");
  Logger.d("| [API_Options]: ${options.data?.toString() ?? ''}");
  Logger.d("| [API_Headers]: $headers");

  handler.next(options); //continue
}, onResponse: (Response response, handler) async {
  bool skip = false;
  if (response.requestOptions.path == "/fe/lists") skip = true;

  if (!skip) {
    Logger.i(
        "| [API_Response] [code ${response.statusCode}]: ${response.data}"); //:
  }
  handler.next(response);
  // return response; // continue
}, onError: (DioError error, handler) async {
  Logger.e("| [API_Error]: ${error.error}: ${error.response?.toString()}");
  handler.next(error); //continue
});
