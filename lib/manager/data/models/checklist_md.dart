import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

final class ChecklistFullMd extends Equatable {
  final List<ChecklistMd> checklists;
  final int pageSize;
  final int currentPage;
  final int maxPages;

  const ChecklistFullMd({
    required this.checklists,
    required this.pageSize,
    required this.currentPage,
    required this.maxPages,
  });

  //from json
  factory ChecklistFullMd.fromJson(Map<String, dynamic> json) {
    try {
      final tempChecklists = <ChecklistMd>[];
      if (json['checklists'] != null) {
        for (final item in json['checklists']) {
          tempChecklists.add(ChecklistMd.fromJson(item));
        }
      }
      return ChecklistFullMd(
        checklists: tempChecklists,
        pageSize: json['page_size'] as int,
        currentPage: json['current_page'] as int,
        maxPages: json['max_pages'] as int,
      );
    } on TypeError catch (e) {
      Logger.e(e.stackTrace, tag: 'ChecklistFullMd');
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        checklists,
        pageSize,
        currentPage,
        maxPages,
      ];

  //init
  const ChecklistFullMd.init()
      : checklists = const [],
        pageSize = 0,
        currentPage = 0,
        maxPages = 0;
}

final class ChecklistMd extends Equatable {
  //{
  //             "ids": [
  //                 11174
  //             ],
  //             "date": "2020-11-20 00:00:00",
  //             "start_time": "2020-11-20 12:15:43",
  //             "finish_time": "2020-11-20 12:15:43",
  //             "title": "Cleaning Checklist and Inventory List",
  //             "comments": [],
  //             "damages": {
  //                 "BATHROOM": {
  //                     "photos": [
  //                         72547,
  //                         72548
  //                     ]
  //                 },
  //                 "KITCHEN": {
  //                     "photos": [
  //                         72544,
  //                         72545,
  //                         72546
  //                     ]
  //                 }
  //             },
  //             "done": true,
  //             "shift_id": 364,
  //             "shift_title": "Apartment 23",
  //             "location_name": "Bingley Road E16 3JR",
  //             "users": {
  //                 "780": {
  //                     "id": 780,
  //                     "fullname": "Fabio Braida",
  //                     "status": false
  //                 }
  //             },
  //             "updated_on": "2020-11-20 21:50:02"
  //         }

  final List<int> ids;
  final String? date;

  DateTime? get dateDt {
    if (date == null) return null;
    return DateTime.parse(date!);
  }

  final String? startTime;

  DateTime? get startTimeDt {
    if (startTime == null) return null;
    return DateTime.parse(startTime!);
  }

  final String? finishTime;

  DateTime? get finishTimeDt {
    if (finishTime == null) return null;
    return DateTime.parse(finishTime!);
  }

  String? get fromToTime {
    //return a time format like 12:00 - 13:00
    //if startTime or updatedOn are null, skip and return what is not null
    if (startTime == null && updatedOn == null) return null;
    if (startTime == null) return updatedOn;
    if (updatedOn == null) return startTime;
    return '${startTime!.substring(11, 16)} - ${updatedOn!.substring(11, 16)}';
  }

  final String? title;
  final List<String> comments;
  final List<DamageMd> damages;
  final bool done;
  final int shiftId;
  final String? shiftTitle;
  final String? locationName;
  final List<SimpleUserMd> users;
  final String? updatedOn;

  DateTime? get updatedOnDt {
    if (updatedOn == null) return null;
    return DateTime.parse(updatedOn!);
  }

  String get fullTitle {
    //if shiftTitle == null, check if locationName is null too, if so return empty string
    //if shiftTitle and locationName are not null, return shiftTitle + locationName
    //if locationName is not null, return locationName
    //if shiftTitle is not null, return  shiftTitle

    if (shiftTitle == null) {
      if (locationName == null) return '';
      return locationName!;
    }
    if (locationName == null) return shiftTitle!;
    return '$locationName, $shiftTitle';
  }

  const ChecklistMd({
    required this.ids,
    required this.date,
    required this.startTime,
    required this.finishTime,
    required this.title,
    required this.comments,
    required this.damages,
    required this.done,
    required this.shiftId,
    required this.shiftTitle,
    required this.locationName,
    required this.users,
    required this.updatedOn,
  });

  //from json
  factory ChecklistMd.fromJson(Map<String, dynamic> json) {
    try {
      final tempUsers = <SimpleUserMd>[];
      if (json['users'] != null) {
        if (json['users'] is List) {
          for (final item in json['users']) {
            tempUsers.add(SimpleUserMd.fromJson(item));
          }
        } else {
          for (final key in json['users'].keys) {
            final user = json['users'][key];
            tempUsers.add(SimpleUserMd(
              id: user['id'] as int,
              fullname: user['fullname'] as String?,
              status: user['status'] as bool,
            ));
          }
        }
      }
      final tempDamages = <DamageMd>[];
      if (json['damages'] != null) {
        if (json['damages'] is List) {
          for (final item in json['damages']) {
            tempDamages.add(DamageMd.fromJson(item));
          }
        } else {
          for (final key in json['damages'].keys) {
            final damage = json['damages'][key];
            tempDamages.add(DamageMd(
              name: key as String,
              photos: damage['photos'] != null
                  ? (damage['photos'] as List).map((e) => e as int).toList()
                  : [],
            ));
          }
        }
      }
      return ChecklistMd(
        ids: json['ids'] != null
            ? (json['ids'] as List).map((e) => e as int).toList()
            : [],
        date: json['date'] as String?,
        startTime: json['start_time'] as String?,
        finishTime: json['finish_time'] as String?,
        title: json['title'] as String?,
        comments: json['comments'] != null
            ? (json['comments'] as List).map((e) => e as String).toList()
            : [],
        damages: tempDamages,
        done: json['done'] as bool,
        shiftId: json['shift_id'] as int,
        shiftTitle: json['shift_title'] as String?,
        locationName: json['location_name'] as String?,
        users: tempUsers,
        updatedOn: json['updated_on'] as String?,
      );
    } on TypeError catch (e) {
      Logger.e('ChecklistMd.fromJson ${e.stackTrace}');
      rethrow;
    } on NoSuchMethodError catch (e) {
      Logger.e('ChecklistMd.fromJson ${e.stackTrace}');
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        ids,
        date,
        startTime,
        finishTime,
        title,
        comments,
        damages,
        done,
        shiftId,
        shiftTitle,
        locationName,
        users,
        updatedOn,
      ];
}

final class DamageMd extends Equatable {
  final String name;
  final List<int> photos;

  const DamageMd({
    required this.name,
    required this.photos,
  });

  //from json
  factory DamageMd.fromJson(Map<String, dynamic> json) {
    try {
      return DamageMd(
        name: json['name'] as String,
        photos: json['photos'] != null
            ? (json['photos'] as List).map((e) => e as int).toList()
            : [],
      );
    } on TypeError catch (e) {
      print('DamageMd.fromJson ${e.stackTrace}');
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        name,
        photos,
      ];
}

final class SimpleUserMd extends Equatable {
  final int id;
  final String? fullname;
  final bool status;

  const SimpleUserMd({
    required this.id,
    required this.fullname,
    required this.status,
  });

  //from json
  factory SimpleUserMd.fromJson(Map<String, dynamic> json) {
    try {
      return SimpleUserMd(
        id: json['id'] as int,
        fullname: json['fullname'] as String?,
        status: json['status'] as bool,
      );
    } on TypeError catch (e) {
      print('SimpleUserMd.fromJson ${e.stackTrace}');
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        id,
        fullname,
        status,
      ];
}

final class ChecklistDamageImageMd extends Equatable {
  //"room": "KITCHEN",
  //             "id": 72546,
  //             "photo": "string"
  //      "type": "image/jpeg",
  //             "width": 400,
  //             "height": 190

  final String room;
  final int id;
  final String photo;
  Uint8List get photoBytes {
    return base64.decode(photo);
  }

  final String type;
  final int width;
  final int height;

  const ChecklistDamageImageMd({
    required this.room,
    required this.id,
    required this.photo,
    required this.type,
    required this.width,
    required this.height,
  });

  //from json
  factory ChecklistDamageImageMd.fromJson(Map<String, dynamic> json) {
    try {
      return ChecklistDamageImageMd(
        room: json['room'] as String,
        id: json['id'] as int,
        photo: json['photo'] as String,
        type: json['type'] as String,
        width: json['width'] as int,
        height: json['height'] as int,
      );
    } on TypeError catch (e) {
      print('ChecklistDamageImageMd.fromJson ${e.stackTrace}');
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        room,
        id,
        photo,
        photoBytes,
        type,
        width,
        height,
      ];
}
