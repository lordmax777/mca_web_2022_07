import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class ApiResponse {
  String? resMessage;
  int? resCode;
  bool success;
  dynamic data;
  RequestOptions? requestOptions;
  Response<dynamic>? rawError;

  ApiResponse(
      {this.resMessage,
      this.rawError,
      this.resCode,
      this.data,
      required this.success,
      this.requestOptions});

  factory ApiResponse.fromDioResponse(Response res) => ApiResponse(
        success: res.statusCode == 200,
        data: res.data,
        rawError: res,
        requestOptions: res.requestOptions,
        resCode: res.statusCode,
        resMessage: res.statusMessage,
      );
}

extension FutureExceptionHandler on Future {
  /// This will handle the exception and return the ApiResponse which contains the error message, code, success status and the request options.
  /// if success is false then the error message will be returned and data is null or dynamic.
  /// if success is true then the data will be returned and error message is null or ok.
  /// Fits properly with retrofit.
  Future<ApiResponse> nocodeErrorHandler() async {
    final ApiResponse apiResponse = ApiResponse(success: false);
    return await then((successRes) {
      //Success Case -> Converting to ApiResponse
      final res = successRes as HttpResponse<dynamic>;
      apiResponse.success = true;
      apiResponse.resCode = res.response.statusCode;
      apiResponse.resMessage = successRes.response.statusMessage;
      apiResponse.requestOptions = successRes.response.requestOptions;
      apiResponse.data = successRes.data;
      return apiResponse;
    }).catchError((Object errorRes) {
      //Error Case -> Converting to ApiResponse
      apiResponse.success = false;
      switch (errorRes.runtimeType) {
        case DioError:
          final dioError = (errorRes as DioError);
          final errorType = dioError.type;
          apiResponse.rawError = dioError.response;
          apiResponse.requestOptions = dioError.requestOptions;
          switch (errorType) {
            case DioErrorType.response:
              apiResponse.resCode = dioError.response!.statusCode;
              apiResponse.resMessage = dioError.response!.statusMessage;
              apiResponse.data = dioError.response!.data;
              break;
            case DioErrorType.other:
              Type otherErrorType = dioError.error.runtimeType;
              switch (otherErrorType) {
                case SocketException:
                  //Handle no Internet access
                  apiResponse.resCode =
                      900; // 900 is custom error code for no internet
                  apiResponse.resMessage = 'ERR_INTERNET_DISCONNECTED';
                  break;
                default:
                  //Handle Unknown error
                  apiResponse.resCode =
                      800; // 800 is custom error code for unknown error
                  apiResponse.resMessage =
                      'ERR_UNKNOWN - [${dioError.message}]\n[stack_trace: ${dioError.stackTrace}]';
              }
              break;
            case DioErrorType.connectTimeout:
              apiResponse.resCode =
                  910; // 910 is custom error code for connect timeout
              apiResponse.resMessage = dioError.message;
              break;
            case DioErrorType.sendTimeout:
              apiResponse.resCode =
                  920; // 920 is custom error code for send timeout
              apiResponse.resMessage = dioError.message;
              break;
            case DioErrorType.receiveTimeout:
              apiResponse.resCode =
                  930; // 930 is custom error code for receive timeout
              apiResponse.resMessage = dioError.message;
              break;
            case DioErrorType.cancel:
              apiResponse.resCode = 940; // 940 is custom error code for cancel
              apiResponse.resMessage = dioError.message;
              break;
          }
          break;
        default:
          //Handle Unknown error
          apiResponse.resCode =
              801; // 801 is custom error code for unknown(1) error
          final errType = errorRes.runtimeType;
          switch (errType) {
            case UnsupportedError:
              final unsupportedErr = errorRes as UnsupportedError;
              apiResponse.resMessage =
                  'ERR_UNKNOWN_1  - [${unsupportedErr.message}]\n[stack_trace: ${unsupportedErr.stackTrace}]';
              break;
            default:
              apiResponse.resMessage =
                  'ERR_UNKNOWN_1  - [${errorRes.toString()}], [err_type: $errType]';
          }

          break;
      }
      return apiResponse;
    });
  }
}
