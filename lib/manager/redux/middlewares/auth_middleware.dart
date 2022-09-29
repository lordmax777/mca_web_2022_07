import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/manager/models/auth.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../app.dart';
import '../../../theme/theme.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../sets/state_value.dart';
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

  Future<StateValue<AuthRes>> _getAccessTokenAction(
      AppState state, GetAccessTokenAction action, NextDispatcher next) async {
    StateValue<AuthRes> stateValue = StateValue(
        data: null,
        error:
            ErrorModel<GetAccessTokenAction>(isLoading: true, action: action));

    next(UpdateAuthAction(authRes: stateValue));

    final ApiResponse res = await restClient()
        .getAccessToken(Constants.grant_type, action.domain, Constants.clientId,
            Constants.clientSecret, action.username, action.password)
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
    } else {
      stateValue.error.retries = state.authState.authRes.error.retries + 1;

      next(UpdateAuthAction(authRes: stateValue));
    }
    return stateValue;
  }
}

///Must pass the action in StateValue<T> as T type
Future<void> fetch(action) async {
  final res = await appStore.dispatch(action);

  final ErrorModel e = res.error;

  if (e.isError) {
    if (e.errorCode == 401) {
      final re = e.rawError;
      if (re != null && re.data is Map) {
        final Map m = re.data;
        if (m.containsKey('error_description')) {
          final bool eee = m['error_description']
              .contains("The access token provided has expired.");
          if (eee) {
            Logger.e('Token Expired');
            // showDialog(
            //   context: appRouter.navigatorKey.currentContext!,
            //   // barrierDismissible: false,
            //   builder: (context) {
            //     return PopupLayout(
            //       borderRadius: 16.0,
            //       backgroundColor: Colors.white,
            //       children: [
            //         SizedBox(
            //             width: 300,
            //             height: 200,
            //             child: SpacedColumn(
            //               verticalSpace: 32,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: const [
            //                 CircularProgressIndicator(),
            //                 Text(
            //                   "Please wait! Loading!",
            //                   style: TextStyle(
            //                       fontSize: 20, fontWeight: FontWeight.w600),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ],
            //             )),
            //       ],
            //     );
            //   },
            // );
            //Get Token Again and Fetch the failed action
            await appStore.dispatch(GetAccessTokenAction(
                domain: Constants.domain,
                username: Constants.username,
                password: Constants.password));

            await appStore.dispatch(action);
            // await appRouter.pop();
          }
        }
      }
    }
  }
}
