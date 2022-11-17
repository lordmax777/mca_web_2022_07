import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import '../../model_exporter.dart';

@immutable
class AuthState {
  final StateValue<AuthRes?> authRes;
  AuthState({
    required this.authRes,
  });

  factory AuthState.initial() {
    return AuthState(
      authRes: StateValue(error: ErrorModel(), data: null),
    );
  }

  AuthState copyWith({StateValue<AuthRes?>? authRes}) {
    return AuthState(
      authRes: authRes ?? this.authRes,
    );
  }
}

class UpdateAuthAction {
  StateValue<AuthRes>? authRes;
  UpdateAuthAction({
    this.authRes,
  });
}

class GetAccessTokenAction {
  final String domain;
  final String username;
  final String password;

  GetAccessTokenAction({
    required this.domain,
    required this.username,
    required this.password,
  });
}

class GetRefreshTokenAction {}
