import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/models/users_list.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
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
      case GetSaveGeneralDetailsAction:
        return _getSaveGeneralDetailsAction(store.state, action, next);
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

      users.sort((a, b) => a.firstName.compareTo(b.firstName));

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
      var savedUserDetails = state.savedUserState;
      final UserDetailsMd userDetailsMd = UserDetailsMd.fromJson(r);
      final general = appStore.state.generalState.paramList.data!;
      final loginms = userDetailsMd.account.login_methods
          .replaceAll(" ", "")
          .split(',')
          .map((e) => e.toLowerCase())
          .toList();

      savedUserDetails.addressCity =
          TextEditingController(text: userDetailsMd.address.city);
      next(UpdateSavedUserStateAction(
        loginRequired: userDetailsMd.account.login_required,
        loginMethods: LoginMethds(
          api: loginms.contains('api'),
          mobile: loginms.contains('mobile'),
          web: loginms.contains('web'),
          mobileAdmin: loginms.contains('mobileadmin'),
          tablet: loginms.contains('tablet'),
        ),
        nationalInsuranceNo: TextEditingController(
            text: userDetailsMd.payroll.national_insurance),
        exEmail: TextEditingController(text: userDetailsMd.email),
        payrollCode:
            TextEditingController(text: userDetailsMd.payroll.payroll_code),
        username: TextEditingController(
            text: state.usersState.selectedUser?.username),
        notes: TextEditingController(text: userDetailsMd.notes),
        phoneLandline:
            TextEditingController(text: userDetailsMd.phones.landline),
        phoneMobile: TextEditingController(text: userDetailsMd.phones.mobile),
        addressCity: TextEditingController(text: userDetailsMd.address.city),
        addressLine1: TextEditingController(text: userDetailsMd.address.line1),
        addressPostcode:
            TextEditingController(text: userDetailsMd.address.postcode),
        groupId: CodeMap(
          name: userDetailsMd.account.group,
          code: general.groups
              .firstWhereOrNull(
                (element) =>
                    element.name.toString() == userDetailsMd.account.group,
              )
              ?.id
              .toString(),
        ),
        roleCode: CodeMap(
          code: userDetailsMd.account.role.first.toString(),
          name: general.roles
              .firstWhereOrNull(
                  (element) => element.code == userDetailsMd.account.role.first)
              ?.name
              .toString(),
        ),
        locationId: CodeMap(
          name: userDetailsMd.account.location,
          code: general.locations
              .firstWhereOrNull(
                  (element) => element.name == userDetailsMd.account.location)
              ?.id
              .toString(),
        ),
        addressCountry: CodeMap(
            name: userDetailsMd.address.country,
            code: general.countries
                .firstWhereOrNull(
                  (element) => element.name == userDetailsMd.address.country,
                )
                ?.code
                .toString()),
        firstName: TextEditingController(text: userDetailsMd.first_name),
        lastName: TextEditingController(text: userDetailsMd.last_name),
        county: TextEditingController(text: userDetailsMd.address.county),
        title: userDetailsMd.title.isNotEmpty
            ? CodeMap(
                name: userDetailsMd.title,
                code: Constants.userTitleTypes.entries
                    .firstWhereOrNull(
                        (element) => element.value == userDetailsMd.title)
                    ?.key)
            : CodeMap(name: null, code: null),
        birthdate: userDetailsMd.date_of_birth != null
            ? DateTime.tryParse(userDetailsMd.date_of_birth!.date)
            : null,
        nationalityCountryCode: CodeMap(
            name: userDetailsMd.nationality,
            code: general.countries
                .firstWhereOrNull(
                    (element) => element.name == userDetailsMd.nationality)
                ?.code),
        maritalStatusCode: CodeMap(
            name: userDetailsMd.marital_status,
            code: Constants.userMartialStatusTypes.entries
                .firstWhere(
                    (element) => element.value == userDetailsMd.marital_status)
                .key),
        isActivate: CodeMap(
          name: Constants.userAccountStatusTypes[userDetailsMd.account.active],
          code: userDetailsMd.account.active ? 1.toString() : 0.toString(),
        ),
        isGrouoAdmin: userDetailsMd.account.group_admin,
        locationAdmin: userDetailsMd.account.location_admin,
        ethnicId: CodeMap(
            name: userDetailsMd.ethnic,
            code: general.ethnics
                .firstWhereOrNull(
                    (element) => element.name == userDetailsMd.ethnic)
                ?.id
                .toString()),
        religionId: CodeMap(
            name: userDetailsMd.religion,
            code: general.religions
                .firstWhereOrNull(
                    (element) => element.name == userDetailsMd.religion)
                ?.id
                .toString()),
        nextOfKinName:
            TextEditingController(text: userDetailsMd.next_of_kin.name),
        nextOfKinPhone:
            TextEditingController(text: userDetailsMd.next_of_kin.phone),
        nextOfKinRelation:
            TextEditingController(text: userDetailsMd.next_of_kin.relation),
        languageCode: CodeMap(
          code: userDetailsMd.account.locale,
          name: Constants.userDisplayLangs.entries
              .firstWhereOrNull(
                  (element) => element.key == userDetailsMd.account.locale)
              ?.value,
        ),
        upass: TextEditingController(),
        upassRepeat: TextEditingController(),
      ));

      stateValue.error.isError = false;
      stateValue.data = userDetailsMd;

      next(UpdateUsersStateAction(
        userDetails: stateValue,
        //  saveableUserDetails: savedUserDetails
      ));
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

    if (res.success) {
      final r = res.data['photos'];
      var list;
      if (r.isNotEmpty) {
        list = PhotosMd.fromJson(r.first);
        next(UpdateSavedUserStateAction(photo: list.photo));
      }

      stateValue.error.isError = false;

      if (list != null) {
        stateValue.data = list;
      }

      next(UpdateUsersStateAction(
        userDetailPhotos: stateValue,
        //  saveableUserDetails: savedUser
      ));
    } else {
      stateValue.error.retries =
          state.usersState.userDetailPhotos.error.retries + 1;

      next(UpdateUsersStateAction(userDetailPhotos: stateValue));
    }
    return stateValue;
  }

  Future<void> _getSaveGeneralDetailsAction(AppState state,
      GetSaveGeneralDetailsAction action, NextDispatcher next) async {
    //Loading

    //Check if is new user

    //if new user => create user
    //if not new user => update user
    final int id = state.usersState.selectedUser?.id ?? 0;
    final savedUser = state.savedUserState;

    //Call post user details

    final ApiResponse res = await restClient()
        .getSaveUserGeneralDetails(
          id,

          // marital_status: 'single', //TODO: Find marital status codes
          // login_methods: savedUser.loginMethods.methods, //TODO: Is not working
          // login_required: savedUser.loginRequired ? "1" : "0", //TODO: Is not working

          firstName: savedUser.firstName.text,
          lastName: savedUser.lastName.text,
          isActive: savedUser.isActivate.code,
          title: savedUser.title.name,
          addressCity: savedUser.addressCity.text,
          addressLine1: savedUser.addressLine1.text,
          addressPostcode: savedUser.addressPostcode.text,
          addressCountry: savedUser.addressCountry.code,
          addressCounty: savedUser.county.text,
          phoneMobile: savedUser.phoneMobile.text,
          phoneLandline: savedUser.phoneLandline.text,
          birthday: savedUser.birthdate?.formattedDate,
          email: savedUser.exEmail.text,
          payrolCode: savedUser.payrollCode.text,
          group: toIntOrNull(savedUser.groupId.code)!,
          location: toIntOrNull(savedUser.locationId.code)!,
          role: savedUser.roleCode.code!,
          language: savedUser.languageCode.code!,
          notes: savedUser.notes.text,
          ni: savedUser.nationalInsuranceNo.text,
          groupAdmin: savedUser.isGrouoAdmin ? "1" : "0",
          locationAdmin: savedUser.locationAdmin,
          ethnic: toIntOrNull(savedUser.ethnicId.code),
          religion: toIntOrNull(savedUser.religionId.code),
          nokName: savedUser.nextOfKinName.text,
          nokRelation: savedUser.nextOfKinRelation.text,
          nokPhone: savedUser.nextOfKinPhone.text,
          upass: savedUser.upass.text,
          nationality: savedUser.nationalityCountryCode.code,
        )
        .nocodeErrorHandler();

    if (res.success) {
      await Future.wait([
        fetch(GetUserDetailsDetailAction()),
        fetch(GetUsersListAction()),
      ]);
    } else {
      String errorMessage = "";
      jsonDecode(res.data)['errors'].entries.forEach((e) {
        errorMessage += e.value.first.toString() + "\n";
      });
      showOverlayPopup(
          body: TableWrapperWidget(
              padding: const EdgeInsets.all(60),
              child: SpacedColumn(verticalSpace: 40.0, children: [
                KText(
                    text: errorMessage,
                    isSelectable: false,
                    fontSize: 20.0,
                    textColor: Colors.black,
                    fontWeight: FWeight.medium),
                ButtonLarge(
                  text: "OK",
                  onPressed: () =>
                      appRouter.navigatorKey.currentContext!.popRoute(),
                )
              ])),
          context: appRouter.navigatorKey.currentContext!);
    }
  }
}
