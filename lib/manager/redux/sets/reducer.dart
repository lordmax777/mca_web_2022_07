import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/users_list.dart';
import '../states/schedule_state.dart';
import '../states/users_state/saved_user_state.dart';
import '../states/users_state/users_state.dart';

AppState appReducer(AppState state, dynamic action) {
  var newState = state.copyWith(
    authState: _authReducer(state.authState, action),
    usersState: _usersReducer(state.usersState, action),
    generalState: _generalReducer(state.generalState, action),
    savedUserState: _savedUserReducer(state.savedUserState, action),
    scheduleState: _scheduleReducer(state.scheduleState, action),
  );

  return newState;
}

///
/// Schedule Reducer
///
final _scheduleReducer = combineReducers<ScheduleState>(
    [TypedReducer<ScheduleState, UpdateScheduleState>(_updateScheduleState)]);

ScheduleState _updateScheduleState(
    ScheduleState state, UpdateScheduleState action) {
  return state.copyWith(
    calendarView: action.calendarView ?? state.calendarView,
    sidebarType: action.sidebarType ?? state.sidebarType,
    shifts: action.shifts ?? state.shifts,
    userResources: action.userResources ?? state.userResources,
    filteredUsers: action.filteredUsers ?? state.filteredUsers,
    filteredLocations: action.filteredLocations ?? state.filteredLocations,
    backupShifts: action.backupShifts ?? state.backupShifts,
    backupShiftsWeek: action.backupShiftsWeek ?? state.backupShiftsWeek,
    backupShiftsMonth: action.backupShiftsMonth ?? state.backupShiftsMonth,
    locationResources: action.locationResources ?? state.locationResources,
  );
}

///
/// Auth Reducer
///
final _authReducer = combineReducers<AuthState>(
    [TypedReducer<AuthState, UpdateAuthAction>(_updateAuthState)]);

AuthState _updateAuthState(AuthState state, UpdateAuthAction action) {
  return state.copyWith(
    authRes: action.authRes ?? state.authRes,
  );
}

///
/// Users Reducer
///
final _usersReducer = combineReducers<UsersState>([
  TypedReducer<UsersState, UpdateUsersStateAction>(_updateUsersStateAction)
]);

UsersState _updateUsersStateAction(
    UsersState state, UpdateUsersStateAction action) {
  if (action.isInit) {
    final managedUsers = state.usersList;
    final newState = UsersState.initial();
    newState.usersList = managedUsers;
    return newState;
  }
  return state.copyWith(
    isNewUser: action.isNewUser ?? state.isNewUser,
    usersList: action.usersList ?? state.usersList,
    selectedUser: action.selectedUser,
    userDetails: action.userDetails ?? state.userDetails,
    userDetailContracts:
        action.userDetailContracts ?? state.userDetailContracts,
    userDetailReviews: action.userDetailReviews ?? state.userDetailReviews,
    userDetailVisas: action.userDetailVisas ?? state.userDetailVisas,
    userDetailQualifs: action.userDetailQualifs ?? state.userDetailQualifs,
    userDetailStatus: action.userDetailStatus ?? state.userDetailStatus,
    userDetailMobileIsRegistered: action.userDetailMobileIsRegistered ??
        state.userDetailMobileIsRegistered,
    userDetailPreferredShift:
        action.userDetailPreferredShift ?? state.userDetailPreferredShift,
    userDetailPhotos: action.userDetailPhotos ?? state.userDetailPhotos,
    // saveableUserDetails:
    // action.saveableUserDetails ?? state.saveableUserDetails,
  );
}

///
/// General Reducer
///
final _generalReducer = combineReducers<GeneralState>([
  TypedReducer<GeneralState, UpdateGeneralStateAction>(
      _updateGeneralStateAction)
]);

GeneralState _updateGeneralStateAction(
    GeneralState state, UpdateGeneralStateAction action) {
  return state.copyWith(
    paramList: action.paramList ?? state.paramList,
    drawerStates: action.drawerStates ?? state.drawerStates,
    endDrawer: action.endDrawer,
    warehouses: action.warehouses ?? state.warehouses,
    storageItems: action.storageItems ?? state.storageItems,
    checklistTemplates: action.checklistTemplates ?? state.checklistTemplates,
    properties: action.properties ?? state.properties,
    locations: action.locations ?? state.locations,
    clientInfos: action.clientInfos ?? state.clientInfos,
    quotes: action.quotes ?? state.quotes,
    approvals: action.approvals ?? state.approvals,
    approvalUserQualifications:
        action.approvalUserQualifications ?? state.approvalUserQualifications,
    inventoryList: action.inventoryList ?? state.inventoryList,
  );
}

///
/// Saved User Reducer
///
final _savedUserReducer = combineReducers<SavedUserState>([
  TypedReducer<SavedUserState, UpdateSavedUserStateAction>(
      _updateSavedUserStateAction)
]);

SavedUserState _updateSavedUserStateAction(
    SavedUserState state, UpdateSavedUserStateAction action) {
  if (action.isInit) {
    return SavedUserState.initial();
  }
  return state.copyWith(
    username: action.username ?? state.username,
    upass: action.upass ?? state.upass,
    upassRepeat: action.upassRepeat ?? state.upassRepeat,
    title: action.title ?? state.title,
    firstName: action.firstName ?? state.firstName,
    lastName: action.lastName ?? state.lastName,
    birthdate: action.birthdate ?? state.birthdate,
    nationalityCountryCode:
        action.nationalityCountryCode ?? state.nationalityCountryCode,
    addressCity: action.addressCity ?? state.addressCity,
    addressLine1: action.addressLine1 ?? state.addressLine1,
    addressPostcode: action.addressPostcode ?? state.addressPostcode,
    addressCountry: action.addressCountry ?? state.addressCountry,
    addressLine2: action.addressLine2 ?? state.addressLine2,
    exEmail: action.exEmail ?? state.exEmail,
    ethnicId: action.ethnicId ?? state.ethnicId,
    groupId: action.groupId ?? state.groupId,
    isActivate: action.isActivate ?? state.isActivate,
    isGrouoAdmin: action.isGrouoAdmin ?? state.isGrouoAdmin,
    languageCode: action.languageCode ?? state.languageCode,
    locationAdmin: action.locationAdmin ?? state.locationAdmin,
    locationId: action.locationId ?? state.locationId,
    loginMethods: action.loginMethods ?? state.loginMethods,
    loginRequired: action.loginRequired ?? state.loginRequired,
    maritalStatusCode: action.maritalStatusCode ?? state.maritalStatusCode,
    notes: action.notes ?? state.notes,
    nextOfKinName: action.nextOfKinName ?? state.nextOfKinName,
    nextOfKinPhone: action.nextOfKinPhone ?? state.nextOfKinPhone,
    nextOfKinRelation: action.nextOfKinRelation ?? state.nextOfKinRelation,
    payrollCode: action.payrollCode ?? state.payrollCode,
    phoneLandline: action.phoneLandline ?? state.phoneLandline,
    phoneMobile: action.phoneMobile ?? state.phoneMobile,
    photo: action.photo,
    religionId: action.religionId ?? state.religionId,
    latitude: action.latitude ?? state.latitude,
    longitude: action.longitude ?? state.longitude,
    nationalInsuranceNo:
        action.nationalInsuranceNo ?? state.nationalInsuranceNo,
    roleCode: action.roleCode ?? state.roleCode,
    county: action.county ?? state.county,
  );
}
