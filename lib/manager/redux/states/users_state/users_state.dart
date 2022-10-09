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

class GetDeleteUserDetailsVisaAction {
  final int id;
  GetDeleteUserDetailsVisaAction({required this.id});
}

class GetPostUserDetailsVisaAction {
  DateTime startDate;
  DateTime endDate;
  bool notExpire;
  CodeMap visaTypeId;
  int? visaid;
  String? notes;

  GetPostUserDetailsVisaAction({
    required this.startDate,
    required this.notExpire,
    required this.endDate,
    required this.visaTypeId,
    this.visaid,
    this.notes,
  });
}

class GetUserDetailsQualifsAction {}

class GetDeleteUserDetailsQualifsAction {
  final int id;
  GetDeleteUserDetailsQualifsAction({required this.id});
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
}

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
