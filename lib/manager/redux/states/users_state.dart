import 'package:flutter/material.dart';

import '../../model_exporter.dart';

@immutable
class UsersState {
  final List<UserRes> usersList;
  final UserRes? selectedUser;
  final UserDetailsMd? userDetails;
  final List<ContractMd> userDetailContracts;
  UsersState({
    required this.usersList,
    required this.selectedUser,
    required this.userDetails,
    required this.userDetailContracts,
  });

  factory UsersState.initial() {
    return UsersState(
      usersList: [],
      selectedUser: null,
      userDetails: null,
      userDetailContracts: [],
    );
  }

  UsersState copyWith({
    List<UserRes>? usersList,
    UserRes? selectedUser,
    UserDetailsMd? userDetails,
    List<ContractMd>? userDetailContracts,
  }) {
    return UsersState(
      usersList: usersList ?? this.usersList,
      selectedUser: selectedUser ?? this.selectedUser,
      userDetails: userDetails ?? this.userDetails,
      userDetailContracts: userDetailContracts ?? this.userDetailContracts,
    );
  }
}

class UpdateUsersStateAction {
  List<UserRes>? usersList;
  UserRes? selectedUser;
  UserDetailsMd? userDetails;
  List<ContractMd>? userDetailContracts;
  UpdateUsersStateAction({
    this.usersList,
    this.selectedUser,
    this.userDetails,
    this.userDetailContracts,
  });
}

class GetUsersListAction {}

class GetUserDetailsDetailAction {}

class GetUserDetailsContractsAction {}
