import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/models/users_list.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
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
      case GetUserDetailsQualifsAction:
        return _getUserDetailsQualifsAction(store.state, action, next);
      case GetUserDetailsStatusAction:
        return _getUserDetailsStatusAction(store.state, action, next);
      case GetUserDetailsMobileAction:
        return _getUserDetailsMobileAction(store.state, action, next);
      case GetUserDetailsPreferredShiftsAction:
        return _getUserDetailsPreferredShiftsAction(store.state, action, next);
      case GetUserDetailsPhotosAction:
        return _getUserDetailsPhotosAction(store.state, action, next);
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
      var savedUserDetails = state.usersState.saveableUserDetails;
      final UserDetailsMd userDetailsMd = UserDetailsMd.fromJson(r);

      savedUserDetails = UserDetailSaveMd.fromUserDetails(userDetailsMd);

      stateValue.error.isError = false;
      stateValue.data = userDetailsMd;

      next(UpdateUsersStateAction(
          userDetails: stateValue, saveableUserDetails: savedUserDetails));
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

  Future<StateValue<List<QualifsMd>>> _getUserDetailsQualifsAction(
      AppState state,
      GetUserDetailsQualifsAction action,
      NextDispatcher next) async {
    StateValue<List<QualifsMd>> stateValue = StateValue(
        data: [],
        error: ErrorModel<GetUserDetailsQualifsAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }

    next(UpdateUsersStateAction(userDetailQualifs: stateValue));

    final ApiResponse res = await restClient()
        .getUserDetailsQalifications(id.toString())
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final r = res.data['qualifications'];
      final List<QualifsMd> list = [];

      for (var e in r) {
        list.add(QualifsMd.fromJson(e));
      }

      stateValue.error.isError = false;
      stateValue.data = list;

      next(UpdateUsersStateAction(userDetailQualifs: stateValue));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailQualifs.error.retries + 1;

      next(UpdateUsersStateAction(userDetailQualifs: stateValue));
    }
    return stateValue;
  }

  Future<StateValue<StatussMd>> _getUserDetailsStatusAction(AppState state,
      GetUserDetailsStatusAction action, NextDispatcher next) async {
    StateValue<StatussMd> stateValue = StateValue(
        data: null,
        error: ErrorModel<GetUserDetailsStatusAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }

    next(UpdateUsersStateAction(userDetailStatus: stateValue));

    final ApiResponse res = await restClient()
        .getUserDetailsStatus(id.toString())
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final r = res.data['status'];
      final StatussMd list = StatussMd.fromJson(r);

      stateValue.error.isError = false;
      stateValue.data = list;

      next(UpdateUsersStateAction(userDetailStatus: stateValue));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailStatus.error.retries + 1;

      next(UpdateUsersStateAction(userDetailStatus: stateValue));
    }
    return stateValue;
  }

  Future<StateValue<bool>> _getUserDetailsMobileAction(AppState state,
      GetUserDetailsMobileAction action, NextDispatcher next) async {
    StateValue<bool> stateValue = StateValue(
        data: null,
        error: ErrorModel<GetUserDetailsMobileAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }

    next(UpdateUsersStateAction(userDetailMobileIsRegistered: stateValue));

    final ApiResponse res = await restClient()
        .getUserDetailsMobile(id.toString())
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final r = res.data['mobile'];
      final String list = r['registered'];

      stateValue.error.isError = false;
      stateValue.data = list == "true";

      next(UpdateUsersStateAction(userDetailMobileIsRegistered: stateValue));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailMobileIsRegistered.error.retries + 1;

      next(UpdateUsersStateAction(userDetailMobileIsRegistered: stateValue));
    }
    return stateValue;
  }

  Future<StateValue<List<PreferredShiftMd>>>
      _getUserDetailsPreferredShiftsAction(
          AppState state,
          GetUserDetailsPreferredShiftsAction action,
          NextDispatcher next) async {
    StateValue<List<PreferredShiftMd>> stateValue = StateValue(
        data: [],
        error: ErrorModel<GetUserDetailsPreferredShiftsAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }

    next(UpdateUsersStateAction(userDetailPreferredShift: stateValue));

    final ApiResponse res = await restClient()
        .getUserDetailsPreferredShifts(id.toString())
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      var r;
      if (res.data['preferredshifts'] is List) {
        r = res.data['preferredshifts'];
      } else {
        r = res.data['preferredshifts'].values.toList();
      }
      final List<PreferredShiftMd> list = [];
      for (var e in r) {
        for (var ea in e.values.toList()) {
          for (var eae in ea) {
            list.add(PreferredShiftMd.fromJson(eae));
          }
        }
      }

      stateValue.error.isError = false;
      stateValue.data = list;

      next(UpdateUsersStateAction(userDetailPreferredShift: stateValue));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailPreferredShift.error.retries + 1;

      next(UpdateUsersStateAction(userDetailPreferredShift: stateValue));
    }
    return stateValue;
  }

  Future<StateValue<PhotosMd>> _getUserDetailsPhotosAction(AppState state,
      GetUserDetailsPhotosAction action, NextDispatcher next) async {
    StateValue<PhotosMd> stateValue = StateValue(
        data: null,
        error: ErrorModel<GetUserDetailsPhotosAction>(
            isLoading: true, action: action));

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return stateValue;
    }
    next(UpdateUsersStateAction(userDetailPhotos: stateValue));

    final ApiResponse res = await restClient()
        .getUserDetailsPhotos(id.toString())
        .nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    final savedUser = state.usersState.saveableUserDetails;
    if (res.success) {
      final r = res.data['photos'];
      var list;
      if (r.isNotEmpty) {
        list = PhotosMd.fromJson(r.first);
        savedUser?.photo = list.photo;
      }

      stateValue.error.isError = false;

      if (list != null) {
        stateValue.data = list;
      }

      next(UpdateUsersStateAction(
          userDetailPhotos: stateValue, saveableUserDetails: savedUser));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailPhotos.error.retries + 1;

      next(UpdateUsersStateAction(userDetailPhotos: stateValue));
    }
    return stateValue;
  }
}
