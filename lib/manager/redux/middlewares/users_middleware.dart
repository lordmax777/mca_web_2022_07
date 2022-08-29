import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/models/users_list.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
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
      case GetUserDetailsReviewsAction:
        return _getUserDetailsReviewsAction(store.state, action, next);
      case GetUserDetailsVisasAction:
        return _getUserDetailsVisasAction(store.state, action, next);
      default:
        return next(action);
    }
  }

  Future<StateValue<List<UserRes>>> _getUsersListAction(
      AppState state, GetUsersListAction action, NextDispatcher next) async {
    StateValue<List<UserRes>> stateValue = StateValue(
        data: [],
        error: ErrorModel<GetUsersListAction>(isLoading: true, action: action));

    next(UpdateUsersStateAction(usersList: stateValue));

    final ApiResponse res =
        await restClient().getUsersList().nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final List l = res.data['users'].values.toList();
      List<UserRes> users = [];
      for (var v in l) {
        users.add(UserRes.fromJson(v));
      }

      stateValue.error.isError = false;
      stateValue.data = users;

      next(UpdateUsersStateAction(usersList: stateValue));
    } else {
      stateValue.error.retries = state.usersState.usersList.error.retries + 1;
      next(UpdateUsersStateAction(usersList: stateValue));
    }
    return stateValue;
  }

  Future<StateValue<UserDetailsMd>> _getUserDetailsDetailAction(AppState state,
      GetUserDetailsDetailAction action, NextDispatcher next) async {
    StateValue<UserDetailsMd> stateValue = StateValue(
        data: null,
        error: ErrorModel<GetUserDetailsDetailAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }

    next(UpdateUsersStateAction(userDetails: stateValue));

    final ApiResponse res =
        await restClient().getUserDetails(id.toString()).nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final r = res.data['details'];
      final UserDetailsMd userDetailsMd = UserDetailsMd.fromJson(r);

      stateValue.error.isError = false;
      stateValue.data = userDetailsMd;

      next(UpdateUsersStateAction(userDetails: stateValue));
    } else {
      stateValue.error.retries = state.usersState.userDetails.error.retries + 1;

      next(UpdateUsersStateAction(userDetails: stateValue));
    }
    return stateValue;
  }

  Future<StateValue<List<ContractMd>>> _getUserDetailsContractsAction(
      AppState state,
      GetUserDetailsContractsAction action,
      NextDispatcher next) async {
    StateValue<List<ContractMd>> stateValue = StateValue(
        data: [],
        error: ErrorModel<GetUserDetailsContractsAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }

    next(UpdateUsersStateAction(userDetailContracts: stateValue));

    final ApiResponse res = await restClient()
        .getUserDetailsContracts(id.toString())
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final r = res.data['contracts'];
      final List<ContractMd> list = [];

      for (var e in r) {
        list.add(ContractMd.fromJson(e));
      }

      stateValue.error.isError = false;
      stateValue.data = list;

      next(UpdateUsersStateAction(userDetailContracts: stateValue));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailContracts.error.retries + 1;

      next(UpdateUsersStateAction(userDetailContracts: stateValue));
    }
    return stateValue;
  }

  Future<StateValue<List<ReviewMd>>> _getUserDetailsReviewsAction(
      AppState state,
      GetUserDetailsReviewsAction action,
      NextDispatcher next) async {
    StateValue<List<ReviewMd>> stateValue = StateValue(
        data: [],
        error: ErrorModel<GetUserDetailsReviewsAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }

    next(UpdateUsersStateAction(userDetailReviews: stateValue));

    final ApiResponse res = await restClient()
        .getUserDetailsReviews(id.toString())
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final r = res.data['reviews'];
      final List<ReviewMd> list = [];

      for (var e in r) {
        list.add(ReviewMd.fromJson(e));
      }

      stateValue.error.isError = false;
      stateValue.data = list;

      next(UpdateUsersStateAction(userDetailReviews: stateValue));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailReviews.error.retries + 1;

      next(UpdateUsersStateAction(userDetailReviews: stateValue));
    }
    return stateValue;
  }

  Future<StateValue<List<VisaMd>>> _getUserDetailsVisasAction(AppState state,
      GetUserDetailsVisasAction action, NextDispatcher next) async {
    StateValue<List<VisaMd>> stateValue = StateValue(
        data: [],
        error: ErrorModel<GetUserDetailsVisasAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }

    next(UpdateUsersStateAction(userDetailVisas: stateValue));

    final ApiResponse res = await restClient()
        .getUserDetailsVisas(id.toString())
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final r = res.data['visas'];
      final List<VisaMd> list = [];

      for (var e in r) {
        list.add(VisaMd.fromJson(e));
      }

      stateValue.error.isError = false;
      stateValue.data = list;

      next(UpdateUsersStateAction(userDetailVisas: stateValue));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailVisas.error.retries + 1;

      next(UpdateUsersStateAction(userDetailVisas: stateValue));
    }
    return stateValue;
  }
}
