import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/models/auth.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../app.dart';
import '../../../theme/theme.dart';
import '../../hive.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../../talker_controller.dart';
import '../sets/state_value.dart';
import '../states/auth_state.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case GetAccessTokenAction:
        return _getAccessTokenAction(store.state, action, next);
      case GetRefreshTokenAction:
        return _getRefreshTokenAction(store.state, action, next);
      default:
        return next(action);
    }
  }

  Future<ApiResponse> _getAccessTokenAction(
      AppState state, GetAccessTokenAction action, NextDispatcher next) async {
    StateValue<AuthRes> stateValue = StateValue(
        data: null,
        error:
            ErrorModel<GetAccessTokenAction>(isLoading: true, action: action));

    next(UpdateAuthAction(authRes: stateValue));

    final ApiResponse res = await restClient()
        .getAccessToken(
            Constants.grant_type(),
            action.domain,
            Constants.clientId,
            Constants.clientSecret,
            action.username,
            action.password)
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;
    stateValue.error.data = res.data;

    if (res.success) {
      final AuthRes r = AuthRes.fromJson(res.data);
      stateValue.error.isError = false;
      stateValue.data = r;

      next(UpdateAuthAction(authRes: stateValue));

      await HiveController.to.setAccessToken(r.access_token);
      await HiveController.to.setRefreshToken(r.refresh_token);

      await GeneralController.to.getLoggedInUser();
    } else {
      stateValue.error.retries = state.authState.authRes.error.retries + 1;

      next(UpdateAuthAction(authRes: stateValue));
    }
    return res;
  }

  Future<StateValue<AuthRes>> _getRefreshTokenAction(
      AppState state, GetRefreshTokenAction action, NextDispatcher next) async {
    StateValue<AuthRes> stateValue = StateValue(
        data: null,
        error:
            ErrorModel<GetRefreshTokenAction>(isLoading: true, action: action));

    next(UpdateAuthAction(authRes: stateValue));

    final refresh_token = HiveController.to.getRefreshToken()!;

    final ApiResponse res = await restClient()
        .refreshToken(Constants.grant_type(refresh: true), refresh_token,
            Constants.clientId, Constants.clientSecret)
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final AuthRes r = AuthRes.fromJson(res.data);
      stateValue.error.isError = false;
      stateValue.data = r;

      next(UpdateAuthAction(authRes: stateValue));

      await HiveController.to.setAccessToken(r.access_token);
      await HiveController.to.setRefreshToken(r.refresh_token);

      if (action.doInitFunc) {
        await GeneralController.to.getLoggedInUser();
      }
    } else {
      stateValue.error.retries = state.authState.authRes.error.retries + 1;

      next(UpdateAuthAction(authRes: stateValue));
    }
    return stateValue;
  }
}

///Must pass the action in StateValue<T> as T type
Future fetch(action) async {
  final talker = TalkerController.to.talker;
  if (action == null) return;
  final res = await appStore.dispatch(action);

  final ErrorModel? e = res.error;

  if (e == null) {
    return res;
  }

  if (e.isError) {
    if (e.errorCode == 401) {
      final re = e.rawError;
      if (re != null && re.data is Map) {
        final Map m = re.data;
        if (m.containsKey('error_description')) {
          final bool eee = m['error_description']
              .contains("The access token provided has expired.");
          if (eee) {
            talker.error('Token Expired');
            await appStore.dispatch(GetAccessTokenAction(
                domain: Constants.domain,
                username: Constants.username,
                password: Constants.password));

            return await appStore.dispatch(action);
          }
        }
      }
    } else {
      return res;
    }
  } else {
    return res;
  }
}
