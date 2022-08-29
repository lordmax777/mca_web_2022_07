import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

@immutable
class StateValue<T> {
  ErrorModel error;
  T? data;

  StateValue({this.data, required this.error});
}

class ErrorModel<T> {
  ///If needs to save data before fail
  dynamic data;
  //isError boolean value is to check if fail or not.
  ///This will help to show proper data after checking the above condition.
  ///By Default it is true
  bool isError;

  ///Error Message in order to show it to the UI
  String? errorMessage;

  ///Error Code is to handle the error by code or show to the UI
  int? errorCode;
  //Retries is incremented every time it fails. If isError == true, make it 0!
  ///By Default it is 0
  int retries;

  T? action;

  bool isLoading;

  Response<dynamic>? rawError;

  ErrorModel({
    this.isError = true,
    this.errorMessage,
    this.action,
    this.isLoading = false,
    this.errorCode,
    this.data,
    this.retries = 0,
    this.rawError,
  });
}
