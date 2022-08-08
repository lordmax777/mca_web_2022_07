import 'package:flutter/material.dart';

import '../../models/model_exporter.dart';

@immutable
class AuthState {
  final AuthRes? authRes;
  AuthState({
    required this.authRes,
  });

  factory AuthState.initial() {
    return AuthState(
      authRes: null,
    );
  }

  AuthState copyWith({
    AuthRes? authRes,
  }) {
    return AuthState(
      authRes: authRes ?? this.authRes,
    );
  }
}

class UpdateAuthAction {
  AuthRes? authRes;
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
