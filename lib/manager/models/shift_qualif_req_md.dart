import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import '../../utils/log_tester.dart';
import '../redux/sets/state_value.dart';

class ShiftQualifReqMd {
  int qualificationId;
  String qualificationName;
  int numberOfStaff;
  int levelId;
  String levelName;
  dynamic alternative;
  ShiftQualifReqMd({
    this.alternative,
    required this.levelId,
    required this.levelName,
    required this.numberOfStaff,
    required this.qualificationId,
    required this.qualificationName,
  });

  factory ShiftQualifReqMd.fromJson(Map<String, dynamic> json) {
    return ShiftQualifReqMd(
      levelId: json['levelId'] as int,
      levelName: json['level'] as String,
      numberOfStaff: json['numberOfStaff'] as int,
      qualificationId: json['qualificationId'] as int,
      qualificationName: json['qualification'] as String,
      alternative: json['alternative'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['levelId'] = levelId;
    data['level'] = levelName;
    data['numberOfStaff'] = numberOfStaff;
    data['qualificationId'] = qualificationId;
    data['qualification'] = qualificationName;
    data['alternative'] = alternative;
    return data;
  }
}
