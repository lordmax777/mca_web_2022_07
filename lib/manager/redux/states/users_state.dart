import 'package:flutter/material.dart';

import '../../models/model_exporter.dart';

@immutable
class UsersState {
  final List<UserRes> usersList;
  final UserRes? selectedUser;
  UsersState({
    required this.usersList,
    required this.selectedUser,
  });

  factory UsersState.initial() {
    return UsersState(
      usersList: [],
      selectedUser: null,
    );
  }

  UsersState copyWith({
    List<UserRes>? usersList,
    UserRes? selectedUser,
  }) {
    return UsersState(
      usersList: usersList ?? this.usersList,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }
}

class UpdateUsersStateAction {
  List<UserRes>? usersList;
  UserRes? selectedUser;
  UpdateUsersStateAction({
    this.usersList,
    this.selectedUser,
  });
}

class GetUsersListAction {}
