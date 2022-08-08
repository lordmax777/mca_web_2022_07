import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state.dart';
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
    UsersMiddleware(),
  ],
);

@immutable
class AppState {
  final AuthState authState;
  final UsersState usersState;
  final ErrorState errorState;
  const AppState({
    required this.authState,
    required this.usersState,
    required this.errorState,
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      errorState: ErrorState.initial(),
      usersState: UsersState.initial(),
    );
  }
  AppState copyWith({
    AuthState? authState,
    ErrorState? errorState,
    UsersState? usersState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      errorState: errorState ?? this.errorState,
      usersState: usersState ?? this.usersState,
    );
  }
}
