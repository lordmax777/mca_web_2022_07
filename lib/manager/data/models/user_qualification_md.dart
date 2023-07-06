import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mca_dashboard/manager/data/data.dart';

final class UserQualificationMd extends Equatable {
  //{"id": 16,
  //             "title": "Cleaning NVQ",
  //             "expire": true,
  //             "levels": true,
  //             "uqId": 74,
  //             "comments": "no comment on certificate",
  //   "imageType": "png",
  //             "achievementDate": {
  //                 "date": "2021-12-01 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "Europe/London"
  //             },
  //             "certificateNumber": "HY6576576",
  //             "expiryDate": {
  //                 "date": "2026-12-01 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "Europe/London"
  //             },
  //             "levelId": "2",
  //             "approvedOn": null,
  //             "level": "L1",
  //              "certificate":"dfdsfdsfskjchwiudh"
  //         }

  final int id;
  final String title;
  QualificationMd? qualificationMd(List<QualificationMd> list) =>
      list.firstWhereOrNull((element) => element.title == title);
  final bool expire;
  final bool levels;
  final int? uqId;
  final String comments;
  final String imageType;
  final String achievementDate;
  DateTime? get achievementDateDt => DateTime.tryParse(achievementDate);
  final String certificateNumber;
  final String expiryDate;
  DateTime? get expiryDateDt => DateTime.tryParse(expiryDate);
  final String levelId;
  QualificationLevelMd? levelMd(List<QualificationLevelMd> list) =>
      list.firstWhereOrNull((element) => element.id == int.tryParse(levelId));
  final String? approvedOn;
  final String level;
  final String certificate;
  Uint8List get certificateBytes => base64Decode(certificate);

  const UserQualificationMd({
    required this.id,
    required this.title,
    required this.expire,
    required this.levels,
    required this.uqId,
    required this.comments,
    required this.imageType,
    required this.achievementDate,
    required this.certificateNumber,
    required this.expiryDate,
    required this.levelId,
    required this.approvedOn,
    required this.level,
    required this.certificate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        expire,
        levels,
        uqId,
        comments,
        imageType,
        achievementDate,
        certificateNumber,
        expiryDate,
        levelId,
        approvedOn,
        level,
        certificate,
      ];

  //from json
  factory UserQualificationMd.fromJson(Map<String, dynamic> json) =>
      UserQualificationMd(
        id: json['id'] as int,
        title: json['title'] ?? "",
        expire: json['expire'] ?? false,
        levels: json['levels'] ?? false,
        uqId: json['uqId'],
        comments: json['comments'] ?? "",
        imageType: json['imageType'] ?? "",
        achievementDate: json['achievementDate']?['date'] ?? "",
        certificateNumber: json['certificateNumber'] ?? "",
        expiryDate: json['expiryDate']?['date'] ?? "",
        levelId: json['levelId'] ?? "",
        approvedOn: json['approvedOn'] ?? "",
        level: json['level'] ?? "",
        certificate: json['certificate'] ?? "",
      );
}
