import 'package:mca_web_2022_07/manager/models/auth.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../theme/theme.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../states/auth_state.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case GetAccessTokenAction:
        return _getAccessTokenAction(store.state, action, next);
      default:
        return next(action);
    }
  }

  Future<AuthRes?> _getAccessTokenAction(
      AppState state, GetAccessTokenAction action, NextDispatcher next) async {
    final ApiResponse res = await restClient()
        .getAccessToken(Constants.grant_type, action.domain, Constants.clientId,
            Constants.clientSecret, action.username, action.password)
        .nocodeErrorHandler();

    if (res.success) {
      final AuthRes r = AuthRes.fromJson(res.data);
      next(UpdateAuthAction(authRes: r));
      return r;
    }
    return null;
  }
}
