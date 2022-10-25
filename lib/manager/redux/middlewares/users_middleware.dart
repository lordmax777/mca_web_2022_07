import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/models/users_list.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../comps/show_overlay_popup.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../states/users_state/saved_user_state.dart';
import '../states/users_state/users_state.dart';
import 'auth_middleware.dart';

class UsersMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case GetUsersListAction:
        return GetUsersListAction.getUsersListAction(store.state, action, next);
      case GetUserDetailsDetailAction:
        return GetUserDetailsDetailAction.getUserDetailsDetailAction(
            store.state, action, next);
      case GetUserDetailsContractsAction:
        return GetUserDetailsContractsAction.getUserDetailsContractsAction(
            store.state, action, next);
      case GetUserDetailsReviewsAction:
        return GetUserDetailsReviewsAction.getUserDetailsReviewsAction(
            store.state, action, next);
      case GetUserDetailsVisasAction:
        return GetUserDetailsVisasAction.getUserDetailsVisasAction(
            store.state, action, next);
      case GetUserDetailsQualifsAction:
        return GetUserDetailsQualifsAction.getUserDetailsQualifsAction(
            store.state, action, next);
      case GetUserDetailsStatusAction:
        return GetUserDetailsStatusAction.getUserDetailsStatusAction(
            store.state, action, next);
      case GetUserDetailsMobileAction:
        return GetUserDetailsMobileAction.getUserDetailsMobileAction(
            store.state, action, next);
      case GetUserDetailsPreferredShiftsAction:
        return GetUserDetailsPreferredShiftsAction
            .getUserDetailsPreferredShiftsAction(store.state, action, next);
      case GetUserDetailsPhotosAction:
        return GetUserDetailsPhotosAction.getUserDetailsPhotosAction(
            store.state, action, next);
      case GetSaveGeneralDetailsAction:
        return GetSaveGeneralDetailsAction.getSaveGeneralDetailsAction(
            store.state, action, next);
      case GetSaveUserPhotoAction:
        return GetSaveUserPhotoAction.getSaveUserPhotoAction(
            store.state, action, next);
      case GetDeleteUserPhotoAction:
        return GetDeleteUserPhotoAction.getDeleteUserPhotoAction(
            store.state, action, next);
      case GetPostUserDetailsReviewAction:
        return GetPostUserDetailsReviewAction.getPostUserDetailsReviewAction(
            store.state, action, next);
      case GetDeleteUserDetailsReviewsAction:
        return GetPostUserDetailsReviewAction.getDeleteUserDetailsReviewsAction(
            store.state, action, next);
      case GetPostUserDetailsVisaAction:
        return GetPostUserDetailsVisaAction.getPostUserDetailsVisaAction(
            store.state, action, next);
      case GetDeleteUserDetailsVisaAction:
        return GetDeleteUserDetailsVisaAction.getDeleteUserDetailsVisaAction(
            store.state, action, next);
      case GetPostUserDetailsQualifsAction:
        return GetPostUserDetailsQualifsAction.getPostUserDetailsQualifsAction(
            store.state, action, next);
      case GetDeleteUserDetailsQualifsAction:
        return GetDeleteUserDetailsQualifsAction
            .getDeleteUserDetailsQualifsAction(store.state, action, next);
      default:
        return next(action);
    }
  }

  Future<ApiResponse?> _getDeleteUserDetailsContractAction(AppState state,
      GetDeleteUserDetailsContractAction action, NextDispatcher next) async {
    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return null;
    }
    showLoading();
    final ApiResponse res = await restClient()
        .deleteUserDetailsContracts(id.toString(), action.id)
        .nocodeErrorHandler();
    if (res.success) {
      await appStore.dispatch(GetUserDetailsContractsAction());
      closeLoading();
    } else {
      await closeLoading();
      showError(res.rawError?.data.toString() ?? "");

      return res;
    }
    return null;
  }
}

Future<void> showLoading({bool? barrierDismissible = false}) async {
  showDialog(
    barrierDismissible: barrierDismissible!,
    context: appRouter.navigatorKey.currentContext!,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Future<void> showError(String msg, {bool? barrierDismissible = false}) async {
  showDialog(
    context: appRouter.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => context.popRoute(),
          )
        ],
      );
    },
  );
}

Future<void> closeLoading() async {
  await appRouter.pop();
}
