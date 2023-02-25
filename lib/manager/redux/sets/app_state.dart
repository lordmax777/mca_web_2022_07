import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/reducer.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';
import '../middlewares/auth_middleware.dart';
import '../middlewares/general_middleware.dart';
import '../middlewares/schedule_middleware.dart';
import '../states/general_state.dart';
import '../states/schedule_state.dart';
import '../states/users_state/saved_user_state.dart';

final appStore = Store<AppState>(
  appReducer,
  initialState: AppState.initial(),
  middleware: [
    AuthMiddleware(),
    UsersMiddleware(),
    GeneralMiddleware(),
    ScheduleMiddleware(),
  ],
);

@immutable
class AppState {
  final AuthState authState;
  final UsersState usersState;
  final SavedUserState savedUserState;
  final GeneralState generalState;
  final ScheduleState scheduleState;

  const AppState({
    required this.authState,
    required this.usersState,
    required this.savedUserState,
    required this.generalState,
    required this.scheduleState,
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      usersState: UsersState.initial(),
      generalState: GeneralState.initial(),
      savedUserState: SavedUserState.initial(),
      scheduleState: ScheduleState.initial(),
    );
  }
  AppState copyWith({
    AuthState? authState,
    UsersState? usersState,
    SavedUserState? savedUserState,
    GeneralState? generalState,
    ScheduleState? scheduleState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      usersState: usersState ?? this.usersState,
      savedUserState: savedUserState ?? this.savedUserState,
      generalState: generalState ?? this.generalState,
      scheduleState: scheduleState ?? this.scheduleState,
    );
  }
}
