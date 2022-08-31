import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';

import '../states/users_state.dart';

AppState appReducer(AppState state, dynamic action) {
  var newState = state.copyWith(
    authState: _authReducer(state.authState, action),
    usersState: _usersReducer(state.usersState, action),
    generalState: _generalReducer(state.generalState, action),
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
    isNewUser: action.isNewUser ?? state.isNewUser,
    usersList: action.usersList ?? state.usersList,
    selectedUser: action.selectedUser,
    userDetails: action.userDetails ?? state.userDetails,
    userDetailContracts:
        action.userDetailContracts ?? state.userDetailContracts,
    userDetailReviews: action.userDetailReviews ?? state.userDetailReviews,
    userDetailVisas: action.userDetailVisas ?? state.userDetailVisas,
    userDetailQualifs: action.userDetailQualifs ?? state.userDetailQualifs,
    userDetailStatus: action.userDetailStatus ?? state.userDetailStatus,
    userDetailMobileIsRegistered: action.userDetailMobileIsRegistered ??
        state.userDetailMobileIsRegistered,
    userDetailPreferredShift:
        action.userDetailPreferredShift ?? state.userDetailPreferredShift,
    userDetailPhotos: action.userDetailPhotos ?? state.userDetailPhotos,
    saveableUserDetails:
        action.saveableUserDetails ?? state.saveableUserDetails,
  );
}

///
/// General Reducer
///
final _generalReducer = combineReducers<GeneralState>([
  TypedReducer<GeneralState, UpdateGeneralStateAction>(
      _updateGeneralStateAction)
]);

GeneralState _updateGeneralStateAction(
    GeneralState state, UpdateGeneralStateAction action) {
  return state.copyWith(
    paramList: action.paramList ?? state.paramList,
  );
}
