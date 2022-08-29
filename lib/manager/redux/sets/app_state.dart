import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/reducer.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';
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
  const AppState({
    required this.authState,
    required this.usersState,
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      usersState: UsersState.initial(),
    );
  }
  AppState copyWith({
    AuthState? authState,
    UsersState? usersState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      usersState: usersState ?? this.usersState,
    );
  }
}
