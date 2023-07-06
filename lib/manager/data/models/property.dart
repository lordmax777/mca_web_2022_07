import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';
import 'package:mca_dashboard/utils/utils.dart';

final class PropertyMd extends Equatable {
  //{
//   "id": 546,
//   "title": "test shift",
//   "locationId": 324,
//   "locationName": "Adriatic Apartments, Flat 13,E16 1BS",
//   "clientId": 59,
//   "clientName": "Keolys Property Ltd",
//   "warehouseId": 1,
//   "warehouseName": "Canary Wharf WA",
//   "checklistTemplateId": 8,
//   "checklistTemplateName": "Default Checklist",
//   "startTime": "01:00", can be null
//   "finishTime": "08:00", can be null
//   "startBreak": "03:00", can be null
//   "finishBreak": "03:30", can be null
//   "fpStartTime": "18:16", can be null
//   "fpFinishTime": "18:16", can be null
//   "fpStartBreak": "18:16", can be null
//   "fpFinishBreak": "18:16", can be null
//   "strictBreak": false,
//   "minPaidTime": 0,
//   "minWorkTime": 0,
//   "splitTime": false,
//   "checklist": true,
//   "linked": null,
//   "days": [1,1,1,1,1,1,1], //starts from monday
//   "active": true
// }

  WeekDaysMd? get week1 {
    if (days.isEmpty) return null;

    ///days can be either List or Map
    ///if List, then [0] is sunday, [1] is monday, [2] is tuesday, etc
    ///

    ///if Map, then key = 0 is value = 1, key = 1 is value = 1, etc,
    ///which means, if key is increasing and value is 1, then it is true for key day
    ///key 0 is monday, key 1 is tuesday, etc
    try {
      if (days is List) {
        bool sunday = false;
        bool monday = false;
        bool tuesday = false;
        bool wednesday = false;
        bool thursday = false;
        bool friday = false;
        bool saturday = false;
        for (int i = 0; i < days.length; i++) {
          if (i == 0 && days[i] == 1) {
            sunday = true;
          }
          if (i == 1 && days[i] == 1) {
            monday = true;
          }
          if (i == 2 && days[i] == 1) {
            tuesday = true;
          }
          if (i == 3 && days[i] == 1) {
            wednesday = true;
          }
          if (i == 4 && days[i] == 1) {
            thursday = true;
          }
          if (i == 5 && days[i] == 1) {
            friday = true;
          }
          if (i == 6 && days[i] == 1) {
            saturday = true;
          }
        }
        return WeekDaysMd(
          sunday: sunday,
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
        );
      } else {
        //working properly
        return WeekDaysMd(
          sunday: days["0"] == 1,
          monday: days["1"] == 1,
          tuesday: days["2"] == 1,
          wednesday: days["3"] == 1,
          thursday: days["4"] == 1,
          friday: days["5"] == 1,
          saturday: days["6"] == 1,
        );
      }
    } catch (e) {
      return null;
    }
  }

  WeekDaysMd? get week2 {
    if (days.isEmpty) return null;

    ///days can be either List or Map
    ///if List, then [7] is sunday, [8] is monday, [9] is tuesday, etc
    ///

    ///if Map, then key = 0 is value = 1, key = 1 is value = 1, etc,
    ///which means, if key is increasing and value is 1, then it is true for key day
    ///key 7 is monday, key 8 is tuesday, etc
    try {
      if (days is List) {
        bool sunday = false;
        bool monday = false;
        bool tuesday = false;
        bool wednesday = false;
        bool thursday = false;
        bool friday = false;
        bool saturday = false;
        for (int i = 0; i < days.length; i++) {
          if (i == 7 && days[i] == 1) {
            sunday = true;
          }
          if (i == 8 && days[i] == 1) {
            monday = true;
          }
          if (i == 9 && days[i] == 1) {
            tuesday = true;
          }
          if (i == 10 && days[i] == 1) {
            wednesday = true;
          }
          if (i == 11 && days[i] == 1) {
            thursday = true;
          }
          if (i == 12 && days[i] == 1) {
            friday = true;
          }
          if (i == 13 && days[i] == 1) {
            saturday = true;
          }
        }
        return WeekDaysMd(
          sunday: sunday,
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
        );
      } else {
        //working properly
        return WeekDaysMd(
          sunday: days["0"] == 1,
          monday: days["1"] == 1,
          tuesday: days["2"] == 1,
          wednesday: days["3"] == 1,
          thursday: days["4"] == 1,
          friday: days["5"] == 1,
          saturday: days["6"] == 1,
        );
      }
    } catch (e) {
      return null;
    }
  }

  final int id;
  final String title;
  final int? locationId;

  LocationMd? getLocationMd(List<LocationMd> locations) =>
      locations.firstWhereOrNull((element) => element.id == locationId);
  final String locationName;
  final int? clientId;

  ClientMd? getClientMd(List<ClientMd> clients) =>
      clients.firstWhereOrNull((element) => element.id == clientId);
  final String? clientName;
  final int? warehouseId;

// WarehouseMd? getWarehouseMd(List<WarehouseMd> warehouses) => warehouses.firstWhereOrNull((element) => element.id == warehouseId);
  final String? warehouseName;
  final int? checklistTemplateId;

  // ChecklistTemplateMd? getChecklistTemplateMd(
  //         List<ChecklistTemplateMd> checklistTemplates) =>
  //     checklistTemplates.firstWhereOrNull(
  //         (element) => element.id == checklistTemplateId);
  final String checklistTemplateName;
  final String? startTime;

  TimeOfDay? get startTimeOfDay {
    if (startTime == null) return null;
    return startTime!.toTimeOfDay;
  }

  final String? finishTime;

  TimeOfDay? get finishTimeOfDay {
    if (finishTime == null) return null;
    return finishTime!.toTimeOfDay;
  }

  final String? startBreak;

  TimeOfDay? get startBreakOfDay {
    if (startBreak == null) return null;
    return startBreak!.toTimeOfDay;
  }

  final String? finishBreak;

  TimeOfDay? get finishBreakOfDay {
    if (finishBreak == null) return null;
    return finishBreak!.toTimeOfDay;
  }

  final String? fpStartTime;

  TimeOfDay? get fpStartTimeOfDay {
    if (fpStartTime == null) return null;
    return fpStartTime!.toTimeOfDay;
  }

  final String? fpFinishTime;

  TimeOfDay? get fpFinishTimeDay {
    if (fpFinishTime == null) return null;
    return fpFinishTime!.toTimeOfDay;
  }

  final String? fpStartBreak;

  TimeOfDay? get fpStartBreakDay {
    if (fpStartBreak == null) return null;
    return fpStartBreak!.toTimeOfDay;
  }

  final String? fpFinishBreak;

  TimeOfDay? get fpFinishBreakDay {
    if (fpFinishBreak == null) return null;
    return fpFinishBreak!.toTimeOfDay;
  }

  final bool strictBreak;
  final num? minPaidTime;
  final num? minWorkTime;
  final bool splitTime;
  final bool checklist;

  // final List<int> days;
  //Need a day parser to be implemented
  final bool active;

  String get initials {
    try {
      return title.substring(0, 2).toUpperCase();
    } catch (e) {
      return "??";
    }
  }

  bool get isAll => id == -1;

  String get fulltitle => isAll
      ? "All"
      : "$title - $locationName${clientName == null ? "" : "- $clientName"}";

  final dynamic days;

  const PropertyMd({
    required this.id,
    required this.title,
    required this.locationId,
    required this.locationName,
    required this.clientId,
    required this.clientName,
    required this.warehouseId,
    required this.warehouseName,
    required this.checklistTemplateId,
    required this.checklistTemplateName,
    required this.startTime,
    required this.finishTime,
    required this.startBreak,
    required this.finishBreak,
    required this.fpStartTime,
    required this.fpFinishTime,
    required this.fpStartBreak,
    required this.fpFinishBreak,
    required this.strictBreak,
    required this.minPaidTime,
    required this.minWorkTime,
    required this.splitTime,
    required this.checklist,
    required this.days,
    required this.active,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        locationId,
        locationName,
        clientId,
        clientName,
        warehouseId,
        warehouseName,
        checklistTemplateId,
        checklistTemplateName,
        startTime,
        finishTime,
        startBreak,
        finishBreak,
        fpStartTime,
        fpFinishTime,
        fpStartBreak,
        fpFinishBreak,
        strictBreak,
        minPaidTime,
        minWorkTime,
        splitTime,
        checklist,
        days,
        active,
      ];

  factory PropertyMd.fromJson(Map<String, dynamic> json) => PropertyMd(
        id: json['id'],
        title: json['title'] ?? "",
        locationId: json['locationId'],
        locationName: json['locationName'] ?? "",
        clientId: json['clientId'],
        clientName: json['clientName'] ?? "",
        warehouseId: json['warehouseId'],
        warehouseName: json['warehouseName'] ?? "",
        checklistTemplateId: json['checklistTemplateId'],
        checklistTemplateName: json['checklistTemplateName'] ?? "",
        startTime: json['startTime'] ?? "",
        finishTime: json['finishTime'] ?? "",
        startBreak: json['startBreak'] ?? "",
        finishBreak: json['finishBreak'],
        fpStartTime: json['fpStartTime'] ?? "",
        fpFinishTime: json['fpFinishTime'] ?? "",
        fpStartBreak: json['fpStartBreak'] ?? "",
        fpFinishBreak: json['fpFinishBreak'] ?? "",
        strictBreak: json['strictBreak'] ?? "",
        minPaidTime: json['minPaidTime'] ?? 0,
        minWorkTime: json['minWorkTime'] ?? 0,
        splitTime: json['splitTime'] ?? "",
        checklist: json['checklist'] ?? "",
        days: json['days'] ?? "",
        active: json['active'] ?? "",
      );
}
