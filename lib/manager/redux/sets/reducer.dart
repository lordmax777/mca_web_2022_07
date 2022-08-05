import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/error_state.dart';

AppState appReducer(AppState state, dynamic action) {
  var newState = state.copyWith(
    authState: _authReducer(state.authState, action),
    errorState: _errorReducer(state.errorState, action),
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
    errorMessage: action.errorMessage ?? state.errorMessage,
  );
}

///
/// Error Reducer
///
final _errorReducer = combineReducers<ErrorState>(
    [TypedReducer<ErrorState, UpdateErrorAction>(_updateErrorState)]);

ErrorState _updateErrorState(ErrorState state, UpdateErrorAction action) {
  return state.copyWith(
    storeInfoError: action.storeInfoError ?? state.storeInfoError,
  );
}
