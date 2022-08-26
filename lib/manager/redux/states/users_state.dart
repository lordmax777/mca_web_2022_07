import 'package:flutter/material.dart';

import '../../model_exporter.dart';

@immutable
class UsersState {
  final List<UserRes> usersList;
  final UserRes? selectedUser;
  final UserDetailsMd? userDetails;
  UsersState({
    required this.usersList,
    required this.selectedUser,
    required this.userDetails,
  });

  factory UsersState.initial() {
    return UsersState(
      usersList: [],
      selectedUser: null,
      userDetails: null,
    );
  }

  UsersState copyWith({
    List<UserRes>? usersList,
    UserRes? selectedUser,
    UserDetailsMd? userDetails,
  }) {
    return UsersState(
      usersList: usersList ?? this.usersList,
      selectedUser: selectedUser ?? this.selectedUser,
      userDetails: userDetails ?? this.userDetails,
    );
  }
}

class UpdateUsersStateAction {
  List<UserRes>? usersList;
  UserRes? selectedUser;
  UserDetailsMd? userDetails;
  UpdateUsersStateAction({
    this.usersList,
    this.selectedUser,
    this.userDetails,
  });
}

class GetUsersListAction {}

class GetUserDetailsAction {}
