import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';

import '../states/users_state.dart';

AppState appReducer(AppState state, dynamic action) {
  var newState = state.copyWith(
    authState: _authReducer(state.authState, action),
    usersState: _usersReducer(state.usersState, action),
  );

  return newState;
}

///
/// Auth Reducer
///
final _authReducer = combineReducers<AuthState>(
    [TypedReducer<AuthState, UpdateAuthAction>(_updateAuthState)]);

AuthState _updateAuthState(AuthState state, UpdateAuthAction action) {
  return state.copyWith(
    authRes: action.authRes ?? state.authRes,
  );
}

///
/// Users Reducer
///
final _usersReducer = combineReducers<UsersState>([
  TypedReducer<UsersState, UpdateUsersStateAction>(_updateUsersStateAction)
]);

UsersState _updateUsersStateAction(
    UsersState state, UpdateUsersStateAction action) {
  return state.copyWith(
    usersList: action.usersList ?? state.usersList,
    selectedUser: action.selectedUser ?? state.selectedUser,
    userDetails: action.userDetails ?? state.userDetails,
    userDetailContracts:
        action.userDetailContracts ?? state.userDetailContracts,
    userDetailReviews: action.userDetailReviews ?? state.userDetailReviews,
  );
}
