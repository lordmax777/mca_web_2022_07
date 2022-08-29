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
  UsersState({
    required this.usersList,
    required this.selectedUser,
    required this.userDetails,
    required this.userDetailContracts,
    required this.userDetailReviews,
  });

  factory UsersState.initial() {
    return UsersState(
      usersList: StateValue(error: ErrorModel(), data: []),
      selectedUser: null,
      userDetails: StateValue(error: ErrorModel(), data: null),
      userDetailContracts: StateValue(error: ErrorModel(), data: []),
      userDetailReviews: StateValue(error: ErrorModel(), data: []),
    );
  }

  UsersState copyWith({
    StateValue<List<UserRes>>? usersList,
    UserRes? selectedUser,
    StateValue<UserDetailsMd?>? userDetails,
    StateValue<List<ContractMd>>? userDetailContracts,
    StateValue<List<ReviewMd>>? userDetailReviews,
  }) {
    return UsersState(
      usersList: usersList ?? this.usersList,
      selectedUser: selectedUser ?? this.selectedUser,
      userDetails: userDetails ?? this.userDetails,
      userDetailContracts: userDetailContracts ?? this.userDetailContracts,
      userDetailReviews: userDetailReviews ?? this.userDetailReviews,
    );
  }
}

class UpdateUsersStateAction {
  UserRes? selectedUser;
  StateValue<List<UserRes>>? usersList;
  StateValue<UserDetailsMd>? userDetails;
  StateValue<List<ContractMd>>? userDetailContracts;
  StateValue<List<ReviewMd>>? userDetailReviews;
  UpdateUsersStateAction({
    this.usersList,
    this.selectedUser,
    this.userDetails,
    this.userDetailContracts,
    this.userDetailReviews,
  });
}

class GetUsersListAction {}

class GetUserDetailsDetailAction {}

class GetUserDetailsContractsAction {}

class GetUserDetailsReviewsAction {}
