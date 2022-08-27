import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/models/users_list.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../states/error_state.dart';
import '../states/users_state.dart';

class UsersMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case GetUsersListAction:
        return _getUsersListAction(store.state, action, next);
      case GetUserDetailsDetailAction:
        return _getUserDetailsDetailAction(store.state, action, next);
      case GetUserDetailsContractsAction:
        return _getUserDetailsContractsAction(store.state, action, next);
      default:
        return next(action);
    }
  }

  Future<List<UserRes>?> _getUsersListAction(
      AppState state, GetUsersListAction action, NextDispatcher next) async {
    next(UpdateErrorAction(usersListError: ErrorModel(isLoading: true)));

    final ApiResponse res =
        await restClient().getUsersList().nocodeErrorHandler();

    if (res.success) {
      final List l = res.data['users'].values.toList();
      List<UserRes> users = [];
      for (var v in l) {
        users.add(UserRes.fromJson(v));
      }
      next(UpdateUsersStateAction(usersList: users));
      next(UpdateErrorAction(
          usersListError: ErrorModel(isError: false, isLoading: false)));
      return users;
    } else {
      next(UpdateErrorAction(
          usersListError: ErrorModel(
              errorCode: res.resCode,
              isLoading: false,
              action: action,
              errorMessage: res.resMessage,
              retries: state.errorState.usersListError.retries + 1)));
    }
    return null;
  }

  Future<UserDetailsMd?> _getUserDetailsDetailAction(AppState state,
      GetUserDetailsDetailAction action, NextDispatcher next) async {
    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return null;
    }
    next(UpdateErrorAction(userDetailsError: ErrorModel(isLoading: true)));

    final ApiResponse res =
        await restClient().getUserDetails(id.toString()).nocodeErrorHandler();

    if (res.success) {
      final r = res.data['details'];
      final UserDetailsMd userDetailsMd = UserDetailsMd.fromJson(r);
      next(UpdateUsersStateAction(userDetails: userDetailsMd));
      next(UpdateErrorAction(
          userDetailsError: ErrorModel(isError: false, isLoading: false)));
      return userDetailsMd;
    } else {
      next(UpdateErrorAction(
          userDetailsError: ErrorModel(
              errorCode: res.resCode,
              isLoading: false,
              action: action,
              errorMessage: res.resMessage,
              retries: state.errorState.userDetailsError.retries + 1)));
    }
    return null;
  }

  Future<List<ContractMd>?> _getUserDetailsContractsAction(AppState state,
      GetUserDetailsContractsAction action, NextDispatcher next) async {
    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return null;
    }
    next(UpdateErrorAction(
        userDetailsContractsError: ErrorModel(isLoading: true)));

    final ApiResponse res = await restClient()
        .getUserDetailsContracts(id.toString())
        .nocodeErrorHandler();

    if (res.success) {
      final r = res.data['contracts'];
      final List<ContractMd> list = [];

      for (var e in r) {
        list.add(ContractMd.fromJson(e));
      }

      next(UpdateUsersStateAction(userDetailContracts: list));

      next(UpdateErrorAction(
          userDetailsContractsError:
              ErrorModel(isError: false, isLoading: false)));
      return list;
    } else {
      next(UpdateErrorAction(
          userDetailsContractsError: ErrorModel(
              errorCode: res.resCode,
              isLoading: false,
              action: action,
              errorMessage: res.resMessage,
              retries:
                  state.errorState.userDetailsContractsError.retries + 1)));
    }
    return null;
  }
}
