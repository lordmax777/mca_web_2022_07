import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';

final class AccountAvailabilityMd extends Equatable {
  //　{
  // flutter: D/  :  │ 　　"start_date":"2023-07-29",
  // flutter: D/  :  │ 　　"finish_date":"2023-07-31",
  // flutter: D/  :  │ 　　"full_day":true,
  // flutter: D/  :  │ 　　"start_time":null,
  // flutter: D/  :  │ 　　"finish_time":null,
  // flutter: D/  :  │ 　　"comment":"test",
  // flutter: D/  :  │ 　　"createdOn":"2023-07-21 20:07:41",
  // flutter: D/  :  │ 　　"createdBy":870
  // flutter: D/  :  │ 　}

  final String startDate;
  DateTime? get startDateDt => DateTime.tryParse(startDate);

  final String? endDate;
  DateTime? get endDateDt => DateTime.tryParse(endDate ?? '');

  final String? startTime;
  TimeOfDay? get startTimeTod => startTime?.toTimeOfDay;

  final String? endTime;
  TimeOfDay? get endTimeTod => endTime?.toTimeOfDay;

  final bool isFullDay;

  final String? comment;

  final String? createdOn;
  DateTime? get createdOnDt => DateTime.tryParse(createdOn ?? '');

  final int createdBy;
  UserMd? getCreatedBy(List<UserMd> users) =>
      users.firstWhereOrNull((e) => e.id == createdBy);

  const AccountAvailabilityMd({
    required this.createdBy,
    required this.startDate,
    required this.isFullDay,
    this.endDate,
    this.createdOn,
    this.startTime,
    this.endTime,
    this.comment,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        startTime,
        endTime,
        comment,
        createdBy,
        createdOn,
        isFullDay,
      ];

  //fromJson
  factory AccountAvailabilityMd.fromJson(Map<String, dynamic> json) =>
      AccountAvailabilityMd(
        startDate: json['start_date'] as String,
        endDate: json['finish_date'] as String?,
        startTime: json['start_time'] as String?,
        endTime: json['end_time'] as String?,
        comment: json['comment'] as String?,
        createdBy: json['createdBy'] as int,
        createdOn: json['createdOn'] as String?,
        isFullDay: json['full_day'] as bool,
      );
}

// List<AccountAvailabilityMd> mockedUserAccountAvailabilityList = [
//   //populate 4, based on the model
//   const AccountAvailabilityMd(
//     id: 1,
//     startDate: '2021-01-01',
//     endDate: '2021-01-01',
//     startTime: '08:00',
//     endTime: '17:00',
//     comment: 'comment',
//   ),
//   const AccountAvailabilityMd(
//     id: 2,
//     startDate: '2021-01-01',
//     endDate: '2021-01-01',
//     startTime: '08:00',
//     endTime: '17:00',
//     comment: 'comment',
//   ),
//   const AccountAvailabilityMd(
//     id: 3,
//     startDate: '2021-01-01',
//     endDate: '2021-01-01',
//     startTime: '08:00',
//     endTime: '17:00',
//     comment: 'comment',
//   ),
//   const AccountAvailabilityMd(
//     id: 4,
//     startDate: '2021-01-01',
//     endDate: '2021-01-01',
//     startTime: '08:00',
//     endTime: '17:00',
//     comment: 'comment',
//   ),
// ];
