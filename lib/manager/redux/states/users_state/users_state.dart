import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import '../../../model_exporter.dart';
import '../../middlewares/auth_middleware.dart';

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

class GetUsersListAction {}

class GetUserDetailsDetailAction {}

class GetUserDetailsContractsAction {}

class GetDeleteUserDetailsContractsAction {
  final int id;
  GetDeleteUserDetailsContractsAction({required this.id});
}

class GetPostUserDetailsContractsAction {
  String csd;
  int contractType;
  int hct;
  int awh;
  int jobTitle;
  String wdpw;
  int salaryPH;
  int? contractid;
  String? ced;
  String? jobDescription;
  int? salaryPA;
  int? salaryOT;

  GetPostUserDetailsContractsAction({
    required this.csd,
    required this.contractType,
    required this.hct,
    required this.awh,
    required this.jobTitle,
    required this.wdpw,
    required this.salaryPH,
    this.contractid,
    this.ced,
    this.jobDescription,
    this.salaryPA,
    this.salaryOT,
  });
}

class GetUserDetailsReviewsAction {}

class GetDeleteUserDetailsReviewsAction {
  final int id;
  GetDeleteUserDetailsReviewsAction({required this.id});
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
}

class GetUserDetailsVisasAction {}

class GetUserDetailsQualifsAction {}

class GetUserDetailsStatusAction {}

class GetUserDetailsMobileAction {}

class GetUserDetailsPreferredShiftsAction {}

class GetUserDetailsPhotosAction {}

class GetSaveGeneralDetailsAction {}

class GetSaveUserPhotoAction {}

class GetDeleteUserPhotoAction {}

abstract class DispatcherAction {
  void dispatch();
}
