import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

final class UserMd extends Equatable {
  //{
  //             "id": 797,
  //             "username": "12785030",
  //             "title": "",
  //             "firstName": "Admin",
  //             "lastName": "Four",
  //             "lastTime": {
  //                 "date": "2022-03-21 00:35:03.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "lastStatus": "2",
  //             "lastIpAddress": "::1",
  //             "lastLocationId": "47",
  //             "lastLatitude": null,
  //             "lastLongitude": null,
  //             "payrolCode": "",
  //             "lastComment": "AUTO SIGN OUT",
  //             "groupId": "46",
  //             "locationId": "43",
  //             "groupAdmin": false,
  //             "locationAdmin": false,
  //             "loginRequired": false,
  //             "locked": null,
  //             "fullname": "Admin Four"
  //         }

  final int id;
  final String username;
  final String title;
  final String firstName;
  final String lastName;

  // final LastTime? lastTime;
  // final String lastStatus;

  final String? groupId;

  int? get groupIdInt => groupId != null ? int.tryParse(groupId!) : null;

  final String? locationId;

  int? get locationIdInt =>
      locationId != null ? int.tryParse(locationId!) : null;

  final bool groupAdmin;
  final bool locationAdmin;

  // final bool loginRequired;
  // final String? locked;
  final String fullname;

  final UnavailabilityMd unavailability = UnavailabilityMd();

  String get initials {
    try {
      return firstName[0].toUpperCase() + lastName[0].toUpperCase();
    } catch (e) {
      return "??";
    }
  }

  String get fulltitle => "$title $fullname";

  bool get isOpenShiftResource => id == -10;

  bool get isAllResource => id == -1;

  TimeOfDay? specialStartTime;
  TimeOfDay? specialFinishTime;

  double? specialPrice;

  bool get isManager => groupId != null;

  factory UserMd.all() {
    return UserMd(
        locationId: null,
        groupId: null,
        groupAdmin: false,
        locationAdmin: false,
        username: "All",
        lastName: "All",
        fullname: "All",
        firstName: "All",
        id: -1,
        title: "");
  }

  factory UserMd.init({
    int? id,
    String? username,
    String? fullname,
    String? firstName,
    String? lastName,
  }) {
    return UserMd(
        locationId: null,
        groupId: null,
        locationAdmin: false,
        groupAdmin: false,
        username: username ?? "",
        lastName: lastName ?? "",
        fullname: fullname ?? "",
        firstName: firstName ?? "",
        id: id ?? -1,
        title: "");
  }

  factory UserMd.openShiftResource() {
    return UserMd.init(
      id: -10,
      firstName: "Open",
      fullname: "Open Shift",
      lastName: "Shift",
      username: "Open Shift",
    );
  }

  //copy
  UserMd copyWith({
    int? id,
    String? username,
    String? title,
    String? firstName,
    String? lastName,
    String? groupId,
    String? locationId,
    bool? groupAdmin,
    bool? locationAdmin,
    String? fullname,
    double? specialPrice,
    TimeOfDay? specialStartTime,
    TimeOfDay? specialFinishTime,
  }) {
    return UserMd(
      id: id ?? this.id,
      username: username ?? this.username,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      groupId: groupId ?? this.groupId,
      locationId: locationId ?? this.locationId,
      groupAdmin: groupAdmin ?? this.groupAdmin,
      locationAdmin: locationAdmin ?? this.locationAdmin,
      fullname: fullname ?? this.fullname,
      specialPrice: specialPrice ?? this.specialPrice,
      specialStartTime: specialStartTime ?? this.specialStartTime,
      specialFinishTime: specialFinishTime ?? this.specialFinishTime,
    );
  }

  UserMd({
    required this.id,
    required this.groupId,
    required this.username,
    required this.groupAdmin,
    required this.locationAdmin,
    required this.title,
    required this.firstName,
    required this.locationId,
    required this.lastName,
    required this.fullname,
    this.specialStartTime,
    this.specialFinishTime,
    this.specialPrice,
  });

  //from json factory
  factory UserMd.fromJson(Map<String, dynamic> json) {
    try {
      return UserMd(
        locationId: json['locationId'],
        groupId: json['groupId'],
        groupAdmin: json['groupAdmin'],
        locationAdmin: json['locationAdmin'],
        id: json['id'],
        username: json['username'] ?? "",
        title: json['title'] ?? "",
        firstName: json['firstName'] ?? "",
        lastName: json['lastName'] ?? "",
        fullname: json['fullname'] ?? "",
      );
    } on TypeError catch (e) {
      logger("$e ${e.stackTrace}", hint: 'UserMd.fromJson');
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        id,
        groupId,
        username,
        groupAdmin,
        locationAdmin,
        title,
        firstName,
        lastName,
        fullname,
        locationId,
        specialPrice,
        specialStartTime,
        specialFinishTime,
      ];
}

final class LastTime {
  //             "lastTime": {
  //                 "date": "2022-03-21 00:35:03.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },

  final String date;

  DateTime get dateTime => DateTime.parse(date);
  final num timezoneType;
  final String timezone;

  LastTime({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  //from json factory
  factory LastTime.fromJson(Map<String, dynamic> json) {
    try {
      return LastTime(
        date: json['date'],
        timezoneType: json['timezone_type'] ?? 0,
        timezone: json['timezone'] ?? "",
      );
    } on TypeError catch (e) {
      logger(e, hint: 'LastTime.fromJson');
      rethrow;
    }
  }
}

final class UnavailabilityMd extends Equatable {
  String? reason;
  DateTime? date;
  bool isUnavailable;

  UnavailabilityMd({
    this.reason,
    this.date,
    this.isUnavailable = false,
  });

  @override
  List<Object?> get props => [reason, date, isUnavailable];
}
