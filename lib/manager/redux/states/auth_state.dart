import 'package:flutter/material.dart';

@immutable
class AuthState {
  final String errorMessage;
  AuthState({
    required this.errorMessage,
  });

  factory AuthState.initial() {
    return AuthState(
      errorMessage: "",
    );
  }

  AuthState copyWith({
    String? errorMessage,
  }) {
    return AuthState(
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class UpdateAuthAction {
  String? errorMessage;
  UpdateAuthAction({
    this.errorMessage,
  });
}
