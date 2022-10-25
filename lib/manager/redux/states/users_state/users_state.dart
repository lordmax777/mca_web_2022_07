import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/saved_user_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:redux/redux.dart';
import '../../../../app.dart';
import '../../../../comps/show_overlay_popup.dart';
import '../../../model_exporter.dart';
import '../../../rest/nocode_helpers.dart';
import '../../../rest/rest_client.dart';
import '../../middlewares/auth_middleware.dart';
import '../../middlewares/users_middleware.dart';

@immutable
class UsersState {
  UserRes? selectedUser;
  bool isNewUser;
  StateValue<List<UserRes>> usersList;
  StateValue<UserDetailsMd?> userDetails;
  StateValue<List<ContractMd>> userDetailContracts;
  StateValue<List<ReviewMd>> userDetailReviews;
  StateValue<List<VisaMd>> userDetailVisas;
  StateValue<List<QualifsMd>> userDetailQualifs;
  StateValue<StatussMd?> userDetailStatus;
  StateValue<bool> userDetailMobileIsRegistered;
  StateValue<List<PreferredShiftMd>> userDetailPreferredShift;
  StateValue<PhotosMd?> userDetailPhotos;
  // final UserDetailSaveMd? saveableUserDetails;

  UsersState({
    required this.usersList,
    required this.isNewUser,
    required this.selectedUser,
    required this.userDetails,
    required this.userDetailContracts,
    required this.userDetailReviews,
    required this.userDetailVisas,
    required this.userDetailQualifs,
    required this.userDetailStatus,
    required this.userDetailMobileIsRegistered,
    required this.userDetailPreferredShift,
    required this.userDetailPhotos,
    // required this.saveableUserDetails,
  });

  factory UsersState.initial() {
    return UsersState(
      isNewUser: false,
      usersList: StateValue(error: ErrorModel(), data: []),
      selectedUser: null,
      userDetails: StateValue(error: ErrorModel(), data: null),
      userDetailContracts: StateValue(error: ErrorModel(), data: []),
      userDetailReviews: StateValue(error: ErrorModel(), data: []),
      userDetailVisas: StateValue(error: ErrorModel(), data: []),
      userDetailQualifs: StateValue(error: ErrorModel(), data: []),
      userDetailStatus: StateValue(error: ErrorModel(), data: null),
      userDetailMobileIsRegistered:
          StateValue(error: ErrorModel(), data: false),
      userDetailPreferredShift: StateValue(error: ErrorModel(), data: []),
      userDetailPhotos: StateValue(error: ErrorModel(), data: null),
      // saveableUserDetails: null,
    );
  }

  UsersState copyWith({
    bool? isNewUser,
    StateValue<List<UserRes>>? usersList,
    UserRes? selectedUser,
    StateValue<UserDetailsMd?>? userDetails,
    StateValue<List<ContractMd>>? userDetailContracts,
    StateValue<List<ReviewMd>>? userDetailReviews,
    StateValue<List<VisaMd>>? userDetailVisas,
    StateValue<List<QualifsMd>>? userDetailQualifs,
    StateValue<StatussMd?>? userDetailStatus,
    StateValue<bool>? userDetailMobileIsRegistered,
    StateValue<List<PreferredShiftMd>>? userDetailPreferredShift,
    StateValue<PhotosMd?>? userDetailPhotos,
    // UserDetailSaveMd? saveableUserDetails,
  }) {
    return UsersState(
      usersList: usersList ?? this.usersList,
      selectedUser: selectedUser ?? this.selectedUser,
      userDetails: userDetails ?? this.userDetails,
      userDetailContracts: userDetailContracts ?? this.userDetailContracts,
      userDetailReviews: userDetailReviews ?? this.userDetailReviews,
      userDetailVisas: userDetailVisas ?? this.userDetailVisas,
      userDetailQualifs: userDetailQualifs ?? this.userDetailQualifs,
      userDetailStatus: userDetailStatus ?? this.userDetailStatus,
      userDetailMobileIsRegistered:
          userDetailMobileIsRegistered ?? this.userDetailMobileIsRegistered,
      userDetailPreferredShift:
          userDetailPreferredShift ?? this.userDetailPreferredShift,
      userDetailPhotos: userDetailPhotos ?? this.userDetailPhotos,
      // saveableUserDetails: saveableUserDetails,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}

class UpdateUsersStateAction {
  bool? isNewUser;
  UserRes? selectedUser;
  StateValue<List<UserRes>>? usersList;
  StateValue<UserDetailsMd>? userDetails;
  StateValue<List<ContractMd>>? userDetailContracts;
  StateValue<List<ReviewMd>>? userDetailReviews;
  StateValue<List<VisaMd>>? userDetailVisas;
  StateValue<List<QualifsMd>>? userDetailQualifs;
  StateValue<StatussMd>? userDetailStatus;
  StateValue<bool>? userDetailMobileIsRegistered;
  StateValue<List<PreferredShiftMd>>? userDetailPreferredShift;
  StateValue<PhotosMd>? userDetailPhotos;
  // UserDetailSaveMd? saveableUserDetails;

  bool isInit;
  UpdateUsersStateAction({
    this.isInit = false,
    this.isNewUser,
    this.usersList,
    this.selectedUser,
    this.userDetails,
    this.userDetailContracts,
    this.userDetailReviews,
    this.userDetailVisas,
    this.userDetailQualifs,
    this.userDetailStatus,
    this.userDetailMobileIsRegistered,
    this.userDetailPreferredShift,
    this.userDetailPhotos,
  });
}

class GetUsersListAction {
  static Future<StateValue<List<UserRes>>> getUsersListAction(
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
}

class GetUserDetailsDetailAction {
  static Future<StateValue<UserDetailsMd>> getUserDetailsDetailAction(
      AppState state,
      GetUserDetailsDetailAction action,
      NextDispatcher next) async {
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

      // logger(userDetailsMd.toJson(), hint: 'Error on');

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
            code: general.marital_statuses
                .firstWhereOrNull(
                    (element) => element.name == userDetailsMd.marital_status)
                ?.code
                .toString()),
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
}

class GetUserDetailsContractsAction {
  static Future<StateValue<List<ContractMd>>> getUserDetailsContractsAction(
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
}

class GetDeleteUserDetailsContractAction {
  final int id;
  GetDeleteUserDetailsContractAction({required this.id});
}

class GetPostUserDetailsContractAction {
  String csd;
  CodeMap contractType;
  int hct;
  int awh;
  CodeMap jobTitle;
  String wdpw;
  int salaryPH;
  int? contractid;
  String? ced;
  String? jobDescription;
  int? salaryPA;
  int? salaryOT;
  int AHEonYS;

  GetPostUserDetailsContractAction({
    required this.jobTitle,

    ///Agreed Holiday Entitlement start on Year Start
    required this.AHEonYS,
    required this.contractType,

    ///Holiday Calculation Type
    required this.hct,

    ///Contract Start Date
    required this.csd,

    ///Contract End Date
    this.ced,

    ///Agreed Weekly Hours
    required this.awh,

    ///Working Days Per Week
    required this.wdpw,

    ///Salary Per Hour
    required this.salaryPH,

    ///Salary Per Annum
    this.salaryPA,

    ///Salary Overtime
    this.salaryOT,
    this.jobDescription,
    this.contractid,
  });
}

class GetUserDetailsReviewsAction {
  static Future<StateValue<List<ReviewMd>>> getUserDetailsReviewsAction(
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
}

class GetDeleteUserDetailsReviewsAction {
  final List<int> ids;
  GetDeleteUserDetailsReviewsAction({required this.ids});

  static Future<ApiResponse?> getDeleteUserDetailsReviewsAction(AppState state,
      GetDeleteUserDetailsReviewsAction action, NextDispatcher next) async {
    final int? userId = state.usersState.selectedUser?.id;
    if (userId == null) {
      appRouter.navigateBack();
      return null;
    }
    showLoading();
    bool allSuccess = true;
    ApiResponse? resp;
    for (int i = 0; i < action.ids.length; i++) {
      final id = action.ids[i];
      final ApiResponse res = await restClient()
          .deleteUserDetailsReviews(userId.toString(), id)
          .nocodeErrorHandler();
      if (!res.success) {
        allSuccess = false;
        resp = res;
        break;
      }
    }

    if (allSuccess) {
      await appStore.dispatch(GetUserDetailsReviewsAction());
      closeLoading();
    } else {
      await closeLoading();
      showError(resp?.rawError?.data.toString() ?? "");
    }
    return null;
  }
}

class GetPostUserDetailsReviewAction {
  String title;
  DateTime date;
  CodeMap conductedBy;
  int? reviewid; // needed for update
  String? notes;

  GetPostUserDetailsReviewAction({
    required this.title,
    required this.date,
    required this.conductedBy,
    this.reviewid,
    this.notes,
  });

  static Future<ApiResponse?> getPostUserDetailsReviewAction(AppState state,
      GetPostUserDetailsReviewAction action, NextDispatcher next) async {
    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return null;
    }
    showLoading();

    final ApiResponse res = await restClient()
        .postUserDetailsReviews(
          id.toString(),
          title: action.title,
          conductedBy: int.parse(action.conductedBy.code!),
          date: action.date.formattedDate,
          notes: action.notes,
          reviewid: action.reviewid,
        )
        .nocodeErrorHandler();

    if (res.success) {
      await appStore.dispatch(GetUserDetailsReviewsAction());
      await closeLoading();
      appRouter.pop();
    } else {
      closeLoading();
      // logger(res.rawError?.data);
      return res;
    }
    return null;
  }
}

class GetUserDetailsVisasAction {
  static Future<StateValue<List<VisaMd>>> getUserDetailsVisasAction(
      AppState state,
      GetUserDetailsVisasAction action,
      NextDispatcher next) async {
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

class GetDeleteUserDetailsVisaAction {
  final List<int> ids;
  GetDeleteUserDetailsVisaAction({required this.ids});

  static Future<ApiResponse?> getDeleteUserDetailsVisaAction(AppState state,
      GetDeleteUserDetailsVisaAction action, NextDispatcher next) async {
    final int? userId = state.usersState.selectedUser?.id;
    if (userId == null) {
      appRouter.navigateBack();
      return null;
    }
    showLoading();
    bool allSuccess = true;
    ApiResponse? resp;
    for (int i = 0; i < action.ids.length; i++) {
      final id = action.ids[i];
      final ApiResponse res = await restClient()
          .deleteUserDetailsVisa(userId.toString(), id.toString())
          .nocodeErrorHandler();
      if (!res.success) {
        allSuccess = false;
        resp = res;
        break;
      }
    }

    if (allSuccess) {
      await appStore.dispatch(GetUserDetailsVisasAction());
      closeLoading();
    } else {
      await closeLoading();
      showError(resp?.rawError?.data.toString() ?? "");
    }
    return null;
  }
}

class GetPostUserDetailsVisaAction {
  DateTime startDate;
  DateTime endDate;
  String documentNo;
  bool notExpire;
  CodeMap visaTypeId;
  int? visaid;
  String? notes;

  GetPostUserDetailsVisaAction({
    required this.startDate,
    required this.notExpire,
    required this.endDate,
    required this.documentNo,
    required this.visaTypeId,
    this.visaid,
    this.notes,
  });

  static Future<ApiResponse?> getPostUserDetailsVisaAction(AppState state,
      GetPostUserDetailsVisaAction action, NextDispatcher next) async {
    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return null;
    }
    showLoading();

    final ApiResponse res = await restClient()
        .postUserDetailsVisa(
          id.toString(),
          startDate: action.startDate.formattedDate,
          endDate: action.endDate.formattedDate,
          visaid: action.visaid,
          notExpire: action.notExpire ? 0 : 1,
          visaTypeId: int.parse(action.visaTypeId.code!),
          notes: action.notes,
          documentNo: action.documentNo,
        )
        .nocodeErrorHandler();

    if (res.success) {
      await appStore.dispatch(GetUserDetailsVisasAction());
      closeLoading();
    } else {
      closeLoading();
      return res;
    }
    return null;
  }
}

class GetUserDetailsQualifsAction {
  static Future<StateValue<List<QualifsMd>>> getUserDetailsQualifsAction(
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
}

class GetDeleteUserDetailsQualifsAction {
  final List<int> ids;
  GetDeleteUserDetailsQualifsAction({required this.ids});

  static Future<ApiResponse?> getDeleteUserDetailsQualifsAction(AppState state,
      GetDeleteUserDetailsQualifsAction action, NextDispatcher next) async {
    final int? userId = state.usersState.selectedUser?.id;
    if (userId == null) {
      appRouter.navigateBack();
      return null;
    }
    showLoading();
    bool allSuccess = true;
    ApiResponse? resp;
    for (int i = 0; i < action.ids.length; i++) {
      final id = action.ids[i];
      final ApiResponse res = await restClient()
          .deleteUserDetailsQualifs(userId.toString(), id)
          .nocodeErrorHandler();
      if (!res.success) {
        allSuccess = false;
        resp = res;
        break;
      }
    }

    if (allSuccess) {
      await appStore.dispatch(GetUserDetailsQualifsAction());
      closeLoading();
    } else {
      await closeLoading();
      showError(resp?.rawError?.data.toString() ?? "");
    }
    return null;
  }
}

class GetPostUserDetailsQualifsAction {
  int? userqualificationid;
  CodeMap qualificationId;
  CodeMap levelId;
  DateTime achievementDate;
  DateTime? expiryDate;
  String certificateNumber;
  String? comments;

  GetPostUserDetailsQualifsAction({
    this.userqualificationid,
    required this.qualificationId,
    required this.levelId,
    required this.achievementDate,
    this.expiryDate,
    required this.certificateNumber,
    this.comments,
  });

  static Future<ApiResponse?> getPostUserDetailsQualifsAction(AppState state,
      GetPostUserDetailsQualifsAction action, NextDispatcher next) async {
    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return null;
    }
    showLoading();

    final ApiResponse res = await restClient()
        .postUserDetailsQualifs(
          id.toString(),
          achievementDate: action.achievementDate.formattedDate,
          expiryDate: action.expiryDate?.formattedDate,
          certificateNumber: action.certificateNumber,
          levelId: int.parse(action.levelId.code!),
          qualificationId: int.parse(action.qualificationId.code!),
          comments: action.comments,
          userqualificationid: action.userqualificationid,
        )
        .nocodeErrorHandler();

    if (res.success) {
      await appStore.dispatch(GetUserDetailsQualifsAction());
      closeLoading();
    } else {
      closeLoading();
      return res;
    }
    return null;
  }
}

class GetUserDetailsStatusAction {
  static Future<StateValue<StatussMd>> getUserDetailsStatusAction(
      AppState state,
      GetUserDetailsStatusAction action,
      NextDispatcher next) async {
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
}

class GetUserDetailsMobileAction {
  static Future<StateValue<bool>> getUserDetailsMobileAction(AppState state,
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
}

class GetUserDetailsPreferredShiftsAction {
  static Future<StateValue<List<PreferredShiftMd>>>
      getUserDetailsPreferredShiftsAction(
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
}

class GetUserDetailsPhotosAction {
  static Future<StateValue<PhotosMd>> getUserDetailsPhotosAction(AppState state,
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
}

class GetSaveGeneralDetailsAction {
  static Future<StateValue<void>> getSaveGeneralDetailsAction(AppState state,
      GetSaveGeneralDetailsAction action, NextDispatcher next) async {
    //Loading
    StateValue<void> stateValue = StateValue(
        data: null,
        error: ErrorModel<GetSaveGeneralDetailsAction>(
            isLoading: true, action: action));

    //if new user => create user
    //if not new user => update user
    final int id = state.usersState.selectedUser?.id ?? 0;
    final savedUser = state.savedUserState;

    //Call post user details
    final ApiResponse res = await restClient()
        .getSaveUserGeneralDetails(
          id,
          // login_methods: savedUser.loginMethods.methods, //TODO: Is not working
          loginRequired: savedUser.loginRequired ? "1" : "0",
          maritalStatus: savedUser.maritalStatusCode.code,
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

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      stateValue.error.isError = false;

      await appStore.dispatch(GetSaveUserPhotoAction());

      await Future.wait([
        fetch(GetUserDetailsDetailAction()),
        fetch(GetUsersListAction()),
      ]);
    } else {
      String errorMessage = "";
      // jsonDecode(res.data)['errors'].entries.forEach((e) {
      //   errorMessage += "${e.value.first}\n";
      // });

      errorMessage = res.data['error'].toString();
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
    return stateValue;
  }
}

class GetSaveUserPhotoAction {
  static Future<void> getSaveUserPhotoAction(AppState state,
      GetSaveUserPhotoAction action, NextDispatcher next) async {
    if (state.savedUserState.photo == null) return;

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return;
    }

    final ApiResponse res = await restClient()
        .addUserDetailsPhotos(id.toString(), photo: state.savedUserState.photo!)
        .nocodeErrorHandler();

    if (res.success) {
    } else {}
  }
}

class GetDeleteUserPhotoAction {
  static Future<void> getDeleteUserPhotoAction(AppState state,
      GetDeleteUserPhotoAction action, NextDispatcher next) async {
    if (state.usersState.userDetailPhotos.data == null) return;

    final int? id = state.usersState.selectedUser?.id;
    if (id == null) {
      appRouter.navigateBack();
      return;
    }

    final ApiResponse res = await restClient()
        .deleteUserDetailsPhotos(
            id.toString(), state.usersState.userDetailPhotos.data!.id)
        .nocodeErrorHandler();

    if (res.success) {
    } else {}
  }
}

abstract class DispatcherAction {
  void dispatch();
}
