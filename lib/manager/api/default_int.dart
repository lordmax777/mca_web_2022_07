import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../manager.dart';

class DefaultInterceptor {
  final deps = DependencyManager.instance;
  // CANCEL INTERCEPTOR
  CancelToken cancelToken = CancelToken();
  // CANCEL INTERCEPTOR

  // DUPLICATE REQUEST INTERCEPTOR
  //List of currently active requests, while requesting add to the list so that we avoid double requests
  final List<String> _activeRequests = [];
  List<String> get activeRequests => _activeRequests;
  // DUPLICATE REQUEST INTERCEPTOR

  void cancelRequest() {
    if (cancelToken.isCancelled) return;
    if (activeRequests.isEmpty) return;
    cancelToken.cancel("cancelled token");
    cancelToken = CancelToken();
    activeRequests.clear();
  }

  Interceptor get cancelInterceptor => InterceptorsWrapper(
        onRequest: (options, handler) {
          options.cancelToken = cancelToken;
          handler.next(options); //continue
        },
      );

  Interceptor get duplicateRequestInterceptor =>
      InterceptorsWrapper(onRequest: (options, handler) {
        final path = options.path;
        if (activeRequests.contains(path)) {
          return;
        } else {
          activeRequests.add(path);
        }
        handler.next(options); //continue
      }, onError: (e, handler) {
        activeRequests.remove(e.requestOptions.path);
        handler.next(e); //continue
      }, onResponse: (e, handler) {
        activeRequests.remove(e.requestOptions.path);
        handler.next(e); //continue
      });

  Interceptor get loggingInterceptor =>
      InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
        String headers = "";
        options.headers.forEach((key, value) {
          headers += "| $key: $value";
        });
        Logger.d("| [API_Request]: ${options.method} ${options.path}");

        if (options.queryParameters.isNotEmpty) {
          Logger.d("| [API_Request_Query]: ${options.queryParameters}");
        }
        if (options.data != null) {
          Logger.d("| [API_Data]: ${options.data!.toString()}");
        }
        Logger.d("| [API_Headers]: $headers");

        handler.next(options); //continue
      }, onResponse: (Response response, handler) async {
        try {
          bool skip = false;
          String data = response.data.toString();

          if (data.length > 1200) {
            data = data.substring(0, 1200);
            skip = true;
          }
          if (skip) {
            Logger.i(
                "| [API_Response_${response.requestOptions.path}] [code ${response.statusCode}]: $data"); //:
            handler.next(response);
            return;
          }
          try {
            Logger.json(jsonEncode(response.data),
                tag: "API_Response_${response.requestOptions.path}");
          } catch (e) {
            Logger.i(
                "| [API_Response_${response.requestOptions.path}] [code ${response.statusCode}]: $data"); //:
          }
          handler.next(response);
        } catch (e) {
          bool skip = false;
          String data = response.data.toString();
          if (response.requestOptions.path == "/fe/lists") skip = true;

          if (!skip) {
            Logger.i(
                "| [API_Response_${response.requestOptions.path}] [code ${response.statusCode}]: $data"); //:
          }
          handler.next(response);
        }
      }, onError: (DioError error, handler) async {
        Logger.e(
            "| [API_Error]: ${error.error}: ${error.response?.toString()}");
        handler.next(error); //continue
      });

  Interceptor get tokenRenewInterceptor => InterceptorsWrapper(
        onRequest: (options, handler) async {
          handler.next(options); //continue
        },
        onError: (e, handler) async {
          try {
            if (e.response?.statusCode == 401 &&
                deps.navigation.loginState.isLoggedIn) {
              if (e.response?.data is Map<String, dynamic>) {
                if (e.response?.data?['error_description']
                        .toString()
                        .contains("The access token provided has expired") ==
                    true) {
                  //Renew token by calling the refresh token endpoint
                  final res =
                      await dispatch<TokenMd>(const GetRefreshTokenAction());

                  if (res.isLeft) {
                    e.requestOptions.headers['Authorization'] =
                        'Bearer ${res.left.accessToken}';
                    return handler.resolve(
                        await deps.dioClient.dio.fetch(e.requestOptions));
                  }
                } else if (e.response?.data?['error_description']
                        .toString()
                        .contains("The access token provided is invalid") ==
                    true) {
                  // logout
                  deps.navigation.loginState.logout();
                }
              }
            }
            return handler.next(e);
          } on DioError catch (err) {
            Logger.e(err.stackTrace, tag: "DioException");
            return handler.next(e);
          } catch (err) {
            Logger.e(err.runtimeType, tag: "Exception");
            return handler.next(e);
          }
        },
        onResponse: (e, handler) {
          handler.next(e); //continue
        },
      );

  Interceptor defaultInterceptor(MCADb db) => InterceptorsWrapper(
        onRequest: (options, handler) {
          options.baseUrl = db.getApiBaseUrl();
          final String accessToken = db.getAccessToken();
          final bool hasAccessToken = accessToken.isNotEmpty;
          if (hasAccessToken && !options.path.contains("/oauth")) {
            //add bearer token
            if (accessToken.isNotEmpty) {
              options.headers.addAll({"Authorization": "Bearer $accessToken"});
            }
          }
          handler.next(options); //continue
        },
        onError: (e, handler) {
          handler.next(e); //continue
        },
        onResponse: (e, handler) {
          handler.next(e); //continue
        },
      );

  // Interceptor get handleInvalidToken => InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         handler.next(options); //continue
  //       },
  //       onError: (e, handler) {
  //         if (e.response?.statusCode == 400) {
  //           if (e.response?.data is Map<String, dynamic>) {
  //             if (e.response?.data?['error_description'].toString().contains(
  //                     "Invalid grant_type parameter or parameter missing") ==
  //                 true) {
  //               // logout
  //               deps.navigation.loginState.logout();
  //             }
  //           }
  //         }
  //       },
  //       onResponse: (e, handler) {
  //         handler.next(e); //continue
  //       },
  //     );
}
