import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/reducer.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/error_state.dart';

import '../middlewares/auth_middleware.dart';

final appStore = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
  middleware: [
    AuthMiddleware(),
  ],
);

@immutable
class AppState {
  final AuthState authState;
  final ErrorState errorState;
  const AppState({
    required this.authState,
    required this.errorState,
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      errorState: ErrorState.initial(),
    );
  }
  AppState copyWith({
    AuthState? authState,
    ErrorState? errorState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      errorState: errorState ?? this.errorState,
    );
  }
}
