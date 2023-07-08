import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/utils/global_functions.dart';
import 'package:mca_dashboard/utils/utils.dart';

import '../models.dart';

final class ApprovalMd extends Equatable {
  final List<ApprovalModelMd> releaseables;
  final List<ApprovalModelMd> acknowledgeables;
  final List<RequestMd> requests;
  final List<ProblemMd> problems;
  final List<PendingUserQualifMd> pendingUserQualifications;
  final List<ClosedRequest> closedRequests;
  const ApprovalMd({
    required this.releaseables,
    required this.acknowledgeables,
    required this.requests,
    required this.problems,
    required this.pendingUserQualifications,
    required this.closedRequests,
  });

  @override
  List<Object?> get props => [
        releaseables,
        acknowledgeables,
        requests,
        problems,
        pendingUserQualifications,
        closedRequests,
      ];

  //from json
  factory ApprovalMd.fromJson(Map<String, dynamic> json) => ApprovalMd(
        releaseables: json['releasable'] != null
            ? (json['releasable'] as List)
                .map((e) => ApprovalModelMd.fromJson(e))
                .toList()
            : [],
        acknowledgeables: json['acknowledgeable'] != null
            ? (json['acknowledgeable'] as List)
                .map((e) => ApprovalModelMd.fromJson(e))
                .toList()
            : [],
        requests: json['requests'] != null
            ? (json['requests'] as List)
                .map((e) => RequestMd.fromJson(e))
                .toList()
            : [],
        problems: json['problems'] != null
            ? (json['problems'] as List)
                .map((e) => ProblemMd.fromJson(e))
                .toList()
            : [],
        pendingUserQualifications: json['pending_user_qualifications'] != null
            ? (json['pending_user_qualifications'] as List)
                .map((e) => PendingUserQualifMd.fromJson(e))
                .toList()
            : [],
        closedRequests: json['closed_requests'] != null
            ? (json['closed_requests'] as List)
                .map((e) => ClosedRequest.fromJson(e))
                .toList()
            : [],
      );
}

final class ApprovalModelMd extends Equatable {
  final int id;
  final String? date;
  DateTime? dateDt() {
    if (date == null) return null;
    return DateTime.tryParse(date!);
  }

  final bool active;
  final String? releaseCreatedOn;
  DateTime? releaseCreatedOnDt() {
    if (releaseCreatedOn == null) return null;
    return DateTime.tryParse(releaseCreatedOn!);
  }

  final String? releaseCreatedBy;
  UserMd? releaseCreatedByMd(List<UserMd> users) {
    if (releaseCreatedBy == null) return null;
    return users.firstWhereOrNull(
        (element) => element.id == int.tryParse(releaseCreatedBy!));
  }

  final String? releaseRequestComment;
  final String? releasePublishedOn;
  DateTime? releasePublishedOnDt() {
    if (releasePublishedOn == null) return null;
    return DateTime.tryParse(releasePublishedOn!);
  }

  final String? releasePublishedBy;
  UserMd? releasePublishedByMd(List<UserMd> users) {
    if (releasePublishedBy == null) return null;
    return users.firstWhereOrNull(
        (element) => element.id == int.tryParse(releasePublishedBy!));
  }

  final String? releasePublishComment;
  final String? locationId;
  LocationMd? locationMd(List<LocationMd> locations) {
    if (locationId == null) return null;
    return locations
        .firstWhereOrNull((element) => element.id == int.tryParse(locationId!));
  }

  final String? locationName;
  final String? title;
  final String? startTime;
  DateTime? startTimeDt() {
    if (startTime == null) return null;
    return DateTime.tryParse(startTime!);
  }

  final String? finishTime;
  DateTime? finishTimeDt() {
    if (finishTime == null) return null;
    return DateTime.tryParse(finishTime!);
  }

  final String? startBreak;
  DateTime? startBreakDt() {
    if (startBreak == null) return null;
    return DateTime.tryParse(startBreak!);
  }

  final String? finishBreak;
  DateTime? finishBreakDt() {
    if (finishBreak == null) return null;
    return DateTime.tryParse(finishBreak!);
  }

  final String? fpStartTime;
  DateTime? fpStartTimeDt() {
    if (fpStartTime == null) return null;
    return DateTime.tryParse(fpStartTime!);
  }

  final String? fpFinishTime;
  DateTime? fpFinishTimeDt() {
    if (fpFinishTime == null) return null;
    return DateTime.tryParse(fpFinishTime!);
  }

  final String? fpStartBreak;
  DateTime? fpStartBreakDt() {
    if (fpStartBreak == null) return null;
    return DateTime.tryParse(fpStartBreak!);
  }

  final String? fpFinishBreak;
  DateTime? fpFinishBreakDt() {
    if (fpFinishBreak == null) return null;
    return DateTime.tryParse(fpFinishBreak!);
  }

  final String? specialStartTime;
  DateTime? specialStartTimeDt() {
    if (specialStartTime == null) return null;
    return DateTime.tryParse(specialStartTime!);
  }

  final String? specialFinishTime;
  DateTime? specialFinishTimeDt() {
    if (specialFinishTime == null) return null;
    return DateTime.tryParse(specialFinishTime!);
  }

  final bool strictBreak;
  final num minWorkTime;
  final num? minPaidTime;
  final bool splitTime;
  final String? createdOn;
  DateTime? createdOnDt() {
    if (createdOn == null) return null;
    return DateTime.tryParse(createdOn!);
  }

  final String? releaseAcceptCreatedOn;
  DateTime? releaseAcceptCreatedOnDt() {
    if (releaseAcceptCreatedOn == null) return null;
    return DateTime.tryParse(releaseAcceptCreatedOn!);
  }

  final String? releaseAcceptCreatedBy;
  UserMd? releaseAcceptCreatedByMd(List<UserMd> users) {
    if (releaseAcceptCreatedBy == null) return null;
    return users.firstWhereOrNull(
        (element) => element.id == int.tryParse(releaseAcceptCreatedBy!));
  }

  final String? releaseAcceptComment;
  final String? username;
  final String? userTitle;
  final String? userFirstName;
  final String? userLastName;

  const ApprovalModelMd({
    required this.id,
    required this.date,
    required this.active,
    required this.releaseCreatedOn,
    required this.releaseCreatedBy,
    required this.releaseRequestComment,
    required this.releasePublishedOn,
    required this.releasePublishedBy,
    required this.releasePublishComment,
    required this.locationId,
    required this.locationName,
    required this.title,
    required this.startTime,
    required this.finishTime,
    required this.startBreak,
    required this.finishBreak,
    required this.fpStartTime,
    required this.fpFinishTime,
    required this.fpStartBreak,
    required this.fpFinishBreak,
    required this.specialStartTime,
    required this.specialFinishTime,
    required this.strictBreak,
    required this.minWorkTime,
    required this.minPaidTime,
    required this.splitTime,
    required this.createdOn,
    required this.releaseAcceptCreatedOn,
    required this.releaseAcceptCreatedBy,
    required this.releaseAcceptComment,
    required this.username,
    required this.userTitle,
    required this.userFirstName,
    required this.userLastName,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        active,
        releaseCreatedOn,
        releaseCreatedBy,
        releaseRequestComment,
        releasePublishedOn,
        releasePublishedBy,
        releasePublishComment,
        locationId,
        locationName,
        title,
        startTime,
        finishTime,
        startBreak,
        finishBreak,
        fpStartTime,
        fpFinishTime,
        fpStartBreak,
        fpFinishBreak,
        specialStartTime,
        specialFinishTime,
        strictBreak,
        minWorkTime,
        minPaidTime,
        splitTime,
        createdOn,
        releaseAcceptCreatedOn,
        releaseAcceptCreatedBy,
        releaseAcceptComment,
        username,
        userTitle,
        userFirstName,
        userLastName,
      ];

  //from json
  factory ApprovalModelMd.fromJson(Map<String, dynamic> json) {
    try {
      return ApprovalModelMd(
        id: json['id'],
        date: json['date']?['date'] as String?,
        active: json['active'] as bool,
        releaseCreatedOn: json['releaseCreatedOn']?['date'] as String?,
        releaseCreatedBy: json['releaseCreatedBy'] as String?,
        releaseRequestComment: json['releaseRequestComment'] as String?,
        releasePublishedOn: json['releasePublishedOn']?['date'] as String?,
        releasePublishedBy: json['releasePublishedBy'] as String?,
        releasePublishComment: json['releasePublishComment'] as String?,
        locationId: json['locationId'] as String?,
        locationName: json['locationName'] as String?,
        title: json['title'] as String?,
        startTime: json['startTime']?['date'] as String?,
        finishTime: json['finishTime']?['date'] as String?,
        startBreak: json['startBreak']?['date'] as String?,
        finishBreak: json['finishBreak']?['date'] as String?,
        fpStartTime: json['fpStartTime']?['date'] as String?,
        fpFinishTime: json['fpFinishTime']?['date'] as String?,
        fpStartBreak: json['fpStartBreak']?['date'] as String?,
        fpFinishBreak: json['fpFinishBreak']?['date'] as String?,
        specialStartTime: json['specialStartTime']?['date'] as String?,
        specialFinishTime: json['specialFinishTime']?['date'] as String?,
        strictBreak: json['strictBreak'] as bool,
        minWorkTime: json['minWorkTime'] as num,
        minPaidTime: json['minPaidTime'] as num?,
        splitTime: json['splitTime'] as bool,
        createdOn: json['createdOn']?['date'] as String?,
        releaseAcceptCreatedOn:
            json['releaseAcceptCreatedOn']?['date'] as String?,
        releaseAcceptCreatedBy: json['releaseAcceptCreatedBy'] as String?,
        releaseAcceptComment: json['releaseAcceptComment'] as String?,
        username: json['username'] as String?,
        userTitle: json['userTitle'] as String?,
        userFirstName: json['userFirstName'] as String?,
        userLastName: json['userLastName'] as String?,
      );
    } on TypeError catch (e) {
      logger(
          'ApprovalModelMd.fromJson: ${e.stackTrace.toString()} ${e.toString()}');
      rethrow;
    }
  }
}

final class RequestMd extends Equatable {
  //  {
  //             "id": 358,
  //             "typeId": "8",
  //             "start": {
  //                 "date": "2022-05-14 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "finish": {
  //                 "date": "2022-05-14 08:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "comment": "",
  //             "createdBy": "805",
  //             "createdOn": {
  //                 "date": "2022-05-13 22:02:11.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "title": "Mr",
  //             "firstName": "Dipen",
  //             "lastName": "One",
  //             "locationId": null,
  //             "groupId": "44"
  //         }

  final int id;
  final String? typeId;
  RequestTypeMd? typeMd(List<RequestTypeMd> types) {
    if (typeId == null) return null;
    return types
        .firstWhereOrNull((element) => element.id == int.tryParse(typeId!));
  }

  final String? start;
  DateTime? get startDt {
    if (start == null) return null;
    return DateTime.tryParse(start!);
  }

  final String? finish;
  DateTime? get finishDt {
    if (finish == null) return null;
    return DateTime.tryParse(finish!);
  }

  String? get fromToDate {
    // start.ddMMyyyyHHmm - finish.ddMMyyyyHHmm
    //if start.ddMMyyyy == finish.ddMMyyyy, show only start.ddMMyyyyHHmm - finish.HHmm
    if (startDt == null || finishDt == null) return null;
    String? fromToDate;
    if (startDt!.day == finishDt!.day &&
        startDt!.month == finishDt!.month &&
        startDt!.year == finishDt!.year) {
      fromToDate =
          '${startDt!.day.toString().padLeft(2, '0')}/${startDt!.month.toString().padLeft(2, '0')}/${startDt!.year.toString().padLeft(4, '0')} ${startDt!.hour.toString().padLeft(2, '0')}:${startDt!.minute.toString().padLeft(2, '0')} - ${finishDt!.hour.toString().padLeft(2, '0')}:${finishDt!.minute.toString().padLeft(2, '0')}';
    } else {
      fromToDate =
          '${startDt!.day.toString().padLeft(2, '0')}/${startDt!.month.toString().padLeft(2, '0')}/${startDt!.year.toString().padLeft(4, '0')} ${startDt!.hour.toString().padLeft(2, '0')}:${startDt!.minute.toString().padLeft(2, '0')} - ${finishDt!.day.toString().padLeft(2, '0')}/${finishDt!.month.toString().padLeft(2, '0')}/${finishDt!.year.toString().padLeft(4, '0')} ${finishDt!.hour.toString().padLeft(2, '0')}:${finishDt!.minute.toString().padLeft(2, '0')}';
    }
    return fromToDate;
  }

  final String? comment;
  final String? createdBy;
  UserMd? userMd(List<UserMd> users) {
    if (createdBy == null) return null;
    return users
        .firstWhereOrNull((element) => element.id == int.tryParse(createdBy!));
  }

  final String? createdOn;
  DateTime? get createdOnDt {
    if (createdOn == null) return null;
    return DateTime.tryParse(createdOn!);
  }

  final String? title;
  final String? firstName;
  final String? lastName;
  String? get fullname {
    String? name;
    //fullname without title
    if (firstName != null && lastName != null) {
      name = '$firstName $lastName';
    } else if (firstName != null) {
      name = firstName;
    } else if (lastName != null) {
      name = lastName;
    }

    return name;
  }

  final String? locationId;
  LocationMd? locationMd(List<LocationMd> locations) {
    if (locationId == null) return null;
    return locations
        .firstWhereOrNull((element) => element.id == int.tryParse(locationId!));
  }

  final String? groupId;
  GroupMd? groupMd(List<GroupMd> groups) {
    if (groupId == null) return null;
    return groups
        .firstWhereOrNull((element) => element.id == int.tryParse(groupId!));
  }

  const RequestMd({
    required this.id,
    required this.typeId,
    required this.start,
    required this.finish,
    required this.comment,
    required this.createdBy,
    required this.createdOn,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.locationId,
    required this.groupId,
  });

  @override
  List<Object?> get props {
    return [
      id,
      typeId,
      start,
      finish,
      comment,
      createdBy,
      createdOn,
      title,
      firstName,
      lastName,
      locationId,
      groupId,
    ];
  }

  //from json
  factory RequestMd.fromJson(Map<String, dynamic> json) {
    try {
      return RequestMd(
        id: json['id'] as int,
        typeId: json['typeId'] as String?,
        start: json['start']?['date'] as String?,
        finish: json['finish']?['date'] as String?,
        comment: json['comment'] as String?,
        createdBy: json['createdBy'] as String?,
        createdOn: json['createdOn']?['date'] as String?,
        title: json['title'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        locationId: json['locationId'] as String?,
        groupId: json['groupId'] as String?,
      );
    } on TypeError catch (e) {
      logger('RequestMd.fromJson: ${e.stackTrace.toString()} ${e.toString()}');
      rethrow;
    }
  }
}

final class ProblemMd extends Equatable {
  //{
  //             "type": "no_visa",
  //             "description": "No visa status entered (1): Mr imre test"
  //         }
  final String? type;
  final String? description;
  const ProblemMd({
    required this.type,
    required this.description,
  });

  @override
  List<Object?> get props {
    return [
      type,
      description,
    ];
  }

  //from json
  factory ProblemMd.fromJson(Map<String, dynamic> json) {
    try {
      return ProblemMd(
        type: json['type'] as String?,
        description: json['description'] as String?,
      );
    } on TypeError catch (e) {
      logger('ProblemMd.fromJson: ${e.stackTrace.toString()} ${e.toString()}');
      rethrow;
    }
  }
}

final class PendingUserQualifMd extends Equatable {
  //  {
  //             "id": 76,
  //             "qualificationId": 16,
  //             "userId": 793,
  //             "title": "Cleaning NVQ",
  //             "level": "L1",
  //             "qualComment": "",
  //             "comments": "",
  //             "achievementDate": {
  //                 "date": "2022-10-11 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "expiryDate": {
  //                 "date": "2022-12-22 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "certificateNumber": "kl",
  //             "createdBy": 786,
  //             "imageType": null,
  //             "createdOn": {
  //                 "date": "2022-10-26 11:24:01.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "fullname": "Dipen Two",
  //              "thumbnail: null,
  //         }

  final int id;
  final int qualificationId;
  QualificationMd? qualificationMd(List<QualificationMd> qualifications) {
    return qualifications
        .firstWhereOrNull((element) => element.id == qualificationId);
  }

  final int userId;
  UserMd? userMd(List<UserMd> users) {
    return users.firstWhereOrNull((element) => element.id == userId);
  }

  final String? title;
  final String? level;
  final String? qualComment;
  final String? comments;
  final String? achievementDate;
  DateTime? get achievementDateDt {
    if (achievementDate == null) return null;
    return DateTime.tryParse(achievementDate!);
  }

  final String? expiryDate;
  DateTime? get expiryDateDt {
    if (expiryDate == null) return null;
    return DateTime.tryParse(expiryDate!);
  }

  final String? certificateNumber;
  final int createdBy;
  UserMd? createdByMd(List<UserMd> users) {
    return users.firstWhereOrNull((element) => element.id == createdBy);
  }

  final String? imageType;
  final String? createdOn;
  DateTime? get createdOnDt {
    if (createdOn == null) return null;
    return DateTime.tryParse(createdOn!);
  }

  final String? fullname;
  final String? thumbnail;
  Uint8List? get thumbnailBytes {
    if (thumbnail == null) return null;
    return base64.decode(thumbnail!);
  }

  const PendingUserQualifMd({
    required this.id,
    required this.qualificationId,
    required this.userId,
    required this.title,
    required this.level,
    required this.qualComment,
    required this.comments,
    required this.achievementDate,
    required this.expiryDate,
    required this.certificateNumber,
    required this.createdBy,
    required this.imageType,
    required this.createdOn,
    required this.fullname,
    required this.thumbnail,
  });

  @override
  List<Object?> get props {
    return [
      id,
      qualificationId,
      userId,
      title,
      level,
      qualComment,
      comments,
      achievementDate,
      expiryDate,
      certificateNumber,
      createdBy,
      imageType,
      createdOn,
      fullname,
      thumbnail,
    ];
  }

  //from json
  factory PendingUserQualifMd.fromJson(Map<String, dynamic> json) {
    try {
      return PendingUserQualifMd(
        id: json['id'] as int,
        qualificationId: json['qualificationId'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String?,
        level: json['level'] as String?,
        qualComment: json['qualComment'] as String?,
        comments: json['comments'] as String?,
        achievementDate: json['achievementDate']?['date'] as String?,
        expiryDate: json['expiryDate']?['date'] as String?,
        certificateNumber: json['certificateNumber'] as String?,
        createdBy: json['createdBy'] as int,
        imageType: json['imageType'] as String?,
        createdOn: json['createdOn']?['date'] as String?,
        fullname: json['fullname'] as String?,
        thumbnail: json['thumbnail'] as String?,
      );
    } on TypeError catch (e) {
      logger(
          'PendingUserQualifMd.fromJson: ${e.stackTrace.toString()} ${e.toString()}');
      rethrow;
    }
  }
}

final class ClosedRequest extends Equatable {
  //{
  //             "id": 336,
  //             "userId": 870,
  //             "typeId": 1,
  //             "start": {
  //                 "date": "2022-03-17 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "finish": {
  //                 "date": "2022-03-31 23:59:59.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "comment": "Family holiday",
  //             "createdBy": 806,
  //             "createdByName": "Dipen Three",
  //             "createdOn": {
  //                 "date": "2022-03-16 14:11:46.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "accepted": 1,
  //             "acceptedBy": 806,
  //             "acceptedOn": {
  //                 "date": "2022-03-16 14:25:25.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "acceptedComment": "Family holiday",
  //             "requestname": "Holiday",
  //             "requestcomment": "full day paid holiday",
  //             "fullday": 1,
  //             "paid": true,
  //             "initial": "H",
  //             "entitlement": -1,
  //             "username": "96189831",
  //             "title": "Mr",
  //             "firstName": "Dipen",
  //             "lastName": "Flutter",
  //             "times": "17/03/2022-31/03/2022"
  //         }

  final int id;
  final int userId;
  UserMd? userMd(List<UserMd> users) {
    return users.firstWhereOrNull((element) => element.id == userId);
  }

  final int typeId;
  RequestTypeMd? typeMd(List<RequestTypeMd> requestTypes) {
    return requestTypes.firstWhereOrNull((element) => element.id == typeId);
  }

  final String? start;
  DateTime? get startDt {
    if (start == null) return null;
    return DateTime.tryParse(start!);
  }

  final String? finish;
  DateTime? get finishDt {
    if (finish == null) return null;
    return DateTime.tryParse(finish!);
  }

  String? get fromToDate {
    // start.ddMMyyyyHHmm - finish.ddMMyyyyHHmm
    //if start.ddMMyyyy == finish.ddMMyyyy, show only start.ddMMyyyyHHmm - finish.HHmm
    if (startDt == null || finishDt == null) return null;
    String? fromToDate;
    if (fullday == 0) {
      return startDt!.ddMMyyyyHHmm;
    }
    if (startDt!.day == finishDt!.day &&
        startDt!.month == finishDt!.month &&
        startDt!.year == finishDt!.year) {
      fromToDate =
          '${startDt!.day.toString().padLeft(2, '0')}/${startDt!.month.toString().padLeft(2, '0')}/${startDt!.year.toString().padLeft(4, '0')} ${startDt!.hour.toString().padLeft(2, '0')}:${startDt!.minute.toString().padLeft(2, '0')} - ${finishDt!.hour.toString().padLeft(2, '0')}:${finishDt!.minute.toString().padLeft(2, '0')}';
    } else {
      fromToDate =
          '${startDt!.day.toString().padLeft(2, '0')}/${startDt!.month.toString().padLeft(2, '0')}/${startDt!.year.toString().padLeft(4, '0')} ${startDt!.hour.toString().padLeft(2, '0')}:${startDt!.minute.toString().padLeft(2, '0')} - ${finishDt!.day.toString().padLeft(2, '0')}/${finishDt!.month.toString().padLeft(2, '0')}/${finishDt!.year.toString().padLeft(4, '0')} ${finishDt!.hour.toString().padLeft(2, '0')}:${finishDt!.minute.toString().padLeft(2, '0')}';
    }
    return fromToDate;
  }

  final String? comment;
  final int createdBy;
  UserMd? createdByMd(List<UserMd> users) {
    return users.firstWhereOrNull((element) => element.id == createdBy);
  }

  final String? createdByName;
  final String? createdOn;
  DateTime? get createdOnDt {
    if (createdOn == null) return null;
    return DateTime.tryParse(createdOn!);
  }

  final int accepted;
  final int acceptedBy;
  UserMd? acceptedByMd(List<UserMd> users) {
    return users.firstWhereOrNull((element) => element.id == acceptedBy);
  }

  final String? acceptedOn;
  DateTime? get acceptedOnDt {
    if (acceptedOn == null) return null;
    return DateTime.tryParse(acceptedOn!);
  }

  final String? acceptedComment;
  final String? requestname;
  final String? requestcomment;
  final int fullday;
  final bool paid;
  final String? initial;
  final int entitlement;
  final String? username;
  final String? title;
  final String? firstName;
  final String? lastName;
  String? get fullname {
    String? name;
    //fullname without title
    if (firstName != null && lastName != null) {
      name = '$firstName $lastName';
    } else if (firstName != null) {
      name = firstName;
    } else if (lastName != null) {
      name = lastName;
    }

    return name;
  }

  final String? times;

  const ClosedRequest({
    required this.id,
    required this.userId,
    required this.typeId,
    required this.start,
    required this.finish,
    required this.comment,
    required this.createdBy,
    required this.createdByName,
    required this.createdOn,
    required this.accepted,
    required this.acceptedBy,
    required this.acceptedOn,
    required this.acceptedComment,
    required this.requestname,
    required this.requestcomment,
    required this.fullday,
    required this.paid,
    required this.initial,
    required this.entitlement,
    required this.username,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.times,
  });

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      typeId,
      start,
      finish,
      comment,
      createdBy,
      createdByName,
      createdOn,
      accepted,
      acceptedBy,
      acceptedOn,
      acceptedComment,
      requestname,
      requestcomment,
      fullday,
      paid,
      initial,
      entitlement,
      username,
      title,
      firstName,
      lastName,
      times,
    ];
  }

  //from json
  factory ClosedRequest.fromJson(Map<String, dynamic> json) {
    try {
      return ClosedRequest(
        id: json['id'] as int,
        userId: json['userId'] as int,
        typeId: json['typeId'] as int,
        start: json['start']?['date'] as String?,
        finish: json['finish']?['date'] as String?,
        comment: json['comment'] as String?,
        createdBy: json['createdBy'] as int,
        createdByName: json['createdByName'] as String?,
        createdOn: json['createdOn']?['date'] as String?,
        accepted: json['accepted'] as int,
        acceptedBy: json['acceptedBy'] as int,
        acceptedOn: json['acceptedOn']?['date'] as String?,
        acceptedComment: json['acceptedComment'] as String?,
        requestname: json['requestname'] as String?,
        requestcomment: json['requestcomment'] as String?,
        fullday: json['fullday'] as int,
        paid: json['paid'] as bool,
        initial: json['initial'] as String?,
        entitlement: json['entitlement'] as int,
        username: json['username'] as String?,
        title: json['title'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        times: json['times'] as String?,
      );
    } on TypeError catch (e) {
      logger(
          'ClosedRequest.fromJson: ${e.stackTrace.toString()} ${e.toString()}');
      rethrow;
    }
  }
}
