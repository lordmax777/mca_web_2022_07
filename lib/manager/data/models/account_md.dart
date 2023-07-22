import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';

final class AccountAvailabilityMd extends Equatable {
  final int id;
  final String startDate;
  DateTime? get startDateDt => DateTime.tryParse(startDate);

  final String? endDate;
  DateTime? get endDateDt => DateTime.tryParse(endDate ?? '');

  final String? startTime;
  TimeOfDay? get startTimeTod => startTime?.toTimeOfDay;

  final String? endTime;
  TimeOfDay? get endTimeTod => endTime?.toTimeOfDay;

  final String? comment;

  const AccountAvailabilityMd({
    required this.id,
    required this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.comment,
  });

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        startTime,
        endTime,
        comment,
      ];

  //fromJson
  factory AccountAvailabilityMd.fromJson(Map<String, dynamic> json) =>
      AccountAvailabilityMd(
        id: json['id'] as int,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String?,
        startTime: json['startTime'] as String?,
        endTime: json['endTime'] as String?,
        comment: json['comment'] as String?,
      );
}

List<AccountAvailabilityMd> mockedUserAccountAvailabilityList = [
  //populate 4, based on the model
  const AccountAvailabilityMd(
    id: 1,
    startDate: '2021-01-01',
    endDate: '2021-01-01',
    startTime: '08:00',
    endTime: '17:00',
    comment: 'comment',
  ),
  const AccountAvailabilityMd(
    id: 2,
    startDate: '2021-01-01',
    endDate: '2021-01-01',
    startTime: '08:00',
    endTime: '17:00',
    comment: 'comment',
  ),
  const AccountAvailabilityMd(
    id: 3,
    startDate: '2021-01-01',
    endDate: '2021-01-01',
    startTime: '08:00',
    endTime: '17:00',
    comment: 'comment',
  ),
  const AccountAvailabilityMd(
    id: 4,
    startDate: '2021-01-01',
    endDate: '2021-01-01',
    startTime: '08:00',
    endTime: '17:00',
    comment: 'comment',
  ),
];
