import 'package:flutter/material.dart';

//error_state.dart

@immutable

///State name
class ErrorState {
  ///State values are defined here, and are final
  final ErrorModel usersListError;
  final ErrorModel tokenError;
  final ErrorModel userDetailsError;
  final ErrorModel userDetailsContractsError;

  ///Always parameters are required and are named params
  const ErrorState({
    required this.usersListError,
    required this.tokenError,
    required this.userDetailsError,
    required this.userDetailsContractsError,
  });

  ///Initial factory function, which must be named same as shown
  factory ErrorState.initial() {
    ///Return the State with all initial values of State values
    ///Make sure to put proper initial values
    return ErrorState(
      usersListError: ErrorModel(),
      tokenError: ErrorModel(),
      userDetailsError: ErrorModel(),
      userDetailsContractsError: ErrorModel(),
    );
  }

  ///copyWith function which is responsible for mutating the state.
  ///It returns the current state and has named, nullable parameters.
  ///Param names are same as actual state param names.
  ErrorState copyWith({
    ErrorModel? usersListError,
    ErrorModel? tokenError,
    ErrorModel? userDetailsError,
    ErrorModel? userDetailsContractsError,
  }) {
    ///Return the state only by checking its values for nullability.
    ///If null return old value, else return the copyWith param value
    return ErrorState(
      usersListError: usersListError ?? this.usersListError,
      tokenError: tokenError ?? this.tokenError,
      userDetailsError: userDetailsError ?? this.userDetailsError,
      userDetailsContractsError:
          userDetailsContractsError ?? this.userDetailsContractsError,
    );
  }
}

///Update Action
class UpdateErrorAction {
  ///Define changeable values as nullable with proper type
  final ErrorModel? usersListError;
  final ErrorModel? tokenError;
  final ErrorModel? userDetailsError;
  final ErrorModel? userDetailsContractsError;

  ///Add values as named params
  ///These are responsible for mutating the state with the given new values.
  UpdateErrorAction({
    this.usersListError,
    this.tokenError,
    this.userDetailsError,
    this.userDetailsContractsError,
  });
}

class ErrorModel {
  ///If needs to save data before fail
  final dynamic data;
  //isError boolean value is to check if fail or not.
  ///This will help to show proper data after checking the above condition.
  ///By Default it is true
  final bool isError;

  ///Error Message in order to show it to the UI
  final String? errorMessage;

  ///Error Code is to handle the error by code or show to the UI
  final int? errorCode;
  //Retries is incremented every time it fails. If isError == true, make it 0!
  ///By Default it is 0
  final int retries;

  final dynamic action;

  final bool isLoading;
  ErrorModel({
    this.isError = true,
    this.errorMessage,
    this.action,
    this.isLoading = false,
    this.errorCode,
    this.data,
    this.retries = 0,
  });
}
