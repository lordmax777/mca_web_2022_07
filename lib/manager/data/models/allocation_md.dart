import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';

final class AllocationMd extends Equatable {
  //{
  //             "id": 45525,
  //             "date": "2023-03-01",
  //             "locationId": 67,
  //             "locationName": "Alan Offices N1 2LJ",
  //             "userId": null,
  //             "shiftId": 115,
  //             "shiftName": "Office 2",
  //             "serviceShiftId": null,
  //             "serviceShiftName": null,
  //             "clientId": 13,
  //             "clientName": "Tony Alan",
  //             "warehouseId": null,
  //             "warehouseName": null,
  //             "published": false,
  //             "special_start_time": null,
  //             "special_finish_time": null,
  //             "special_rate": null,
  //             "user_order": null,
  //             "guests": 0
  //         }

  final int id;
  final String date;

  DateTime get dateAsDateTime => DateTime.parse(date);

  final int locationId;

  LocationMd? locationMd(List<LocationMd> locations) =>
      locations.firstWhereOrNull((element) => element.id == locationId);
  final String locationName;

  final int? userId;

  UserMd? userMd(List<UserMd> users) =>
      users.firstWhereOrNull((element) => element.id == userId);

  final int shiftId;

  PropertyMd? shiftMd(List<PropertyMd> shifts) =>
      shifts.firstWhereOrNull((element) => element.id == shiftId);
  final String shiftName;

  final int? serviceShiftId;

  PropertyMd? serviceShiftMd(List<PropertyMd> serviceShifts) =>
      serviceShifts.firstWhereOrNull((element) => element.id == serviceShiftId);
  final String? serviceShiftName;

  final int? clientId;

  ClientMd? clientMd(List<ClientMd> clients) =>
      clients.firstWhereOrNull((element) => element.id == clientId);
  final String? clientName;

  final int? warehouseId;

  WarehouseMd? warehouseMd(List<WarehouseMd> warehouses) =>
      warehouses.firstWhereOrNull((element) => element.id == warehouseId);
  final String? warehouseName;

  final bool published;

  final String? specialStartTime;
  DateTime? get specialStartTimeAsDateTime =>
      specialStartTime == null ? null : DateTime.parse(specialStartTime!);

  final String? specialFinishTime;
  DateTime? get specialFinishTimeAsDateTime =>
      specialFinishTime == null ? null : DateTime.parse(specialFinishTime!);

  final num? specialRate;
  final int? userOrder;
  final int guests;

  late final Color bgColor;
  late final Color fgColor;

  AllocationMd({
    required this.id,
    required this.date,
    required this.locationId,
    required this.locationName,
    required this.userId,
    required this.shiftId,
    required this.shiftName,
    required this.serviceShiftId,
    required this.serviceShiftName,
    required this.clientId,
    required this.clientName,
    required this.warehouseId,
    required this.warehouseName,
    required this.published,
    required this.specialStartTime,
    required this.specialFinishTime,
    required this.specialRate,
    required this.userOrder,
    required this.guests,
  }) {
    bgColor = published ? Colors.green : Colors.red;
    fgColor = published ? Colors.white : Colors.black;
  }

  factory AllocationMd.fromJson(Map<String, dynamic> json) => AllocationMd(
        id: json['id'] as int,
        date: json['date'] ?? "",
        locationId: json['locationId'] ?? 0,
        locationName: json['locationName'] ?? "",
        userId: json['userId'] as int?,
        shiftId: json['shiftId'] as int,
        shiftName: json['shiftName'] ?? "",
        serviceShiftId: json['serviceShiftId'] as int?,
        serviceShiftName: json['serviceShiftName'] as String?,
        clientId: json['clientId'] as int?,
        clientName: json['clientName'] as String?,
        warehouseId: json['warehouseId'] as int?,
        warehouseName: json['warehouseName'] as String?,
        published: json['published'] as bool,
        specialStartTime: json['special_start_time'] as String?,
        specialFinishTime: json['special_finish_time'] as String?,
        specialRate: json['special_rate'] as num?,
        userOrder: json['user_order'] as int?,
        guests: json['guests'] ?? 0,
      );

  @override
  List<Object?> get props => [
        id,
        date,
        locationId,
        locationName,
        userId,
        shiftId,
        shiftName,
        serviceShiftId,
        serviceShiftName,
        clientId,
        clientName,
        warehouseId,
        warehouseName,
        published,
        specialStartTime,
        specialFinishTime,
        specialRate,
        userOrder,
        guests
      ];
}
