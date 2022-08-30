import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import '../../model_exporter.dart';

@immutable
class UsersState {
  final StateValue<List<UserRes>> usersList;
  final UserRes? selectedUser;
  final StateValue<UserDetailsMd?> userDetails;
  final StateValue<List<ContractMd>> userDetailContracts;
  final StateValue<List<ReviewMd>> userDetailReviews;
  final StateValue<List<VisaMd>> userDetailVisas;
  final StateValue<List<QualifsMd>> userDetailQualifs;
  final StateValue<StatussMd?> userDetailStatus;
  final StateValue<bool> userDetailMobileIsRegistered;
  final StateValue<List<PreferredShiftMd>> userDetailPreferredShift;

  UsersState({
    required this.usersList,
    required this.selectedUser,
    required this.userDetails,
    required this.userDetailContracts,
    required this.userDetailReviews,
    required this.userDetailVisas,
    required this.userDetailQualifs,
    required this.userDetailStatus,
    required this.userDetailMobileIsRegistered,
    required this.userDetailPreferredShift,
  });

  factory UsersState.initial() {
    return UsersState(
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
    );
  }

  UsersState copyWith({
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
    );
  }
}

class UpdateUsersStateAction {
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
  UpdateUsersStateAction({
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
  });
}

class GetUsersListAction {}

class GetUserDetailsDetailAction {}

class GetUserDetailsContractsAction {}

class GetUserDetailsReviewsAction {}

class GetUserDetailsVisasAction {}

class GetUserDetailsQualifsAction {}

class GetUserDetailsStatusAction {}

class GetUserDetailsMobileAction {}

class GetUserDetailsPreferredShiftsAction {}
