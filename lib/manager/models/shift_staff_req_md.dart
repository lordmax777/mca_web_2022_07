import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import '../../utils/log_tester.dart';
import '../redux/sets/state_value.dart';

class ShiftStaffReqMd {
  int groupId;
  int min;
  int max;
  String group;
  ShiftStaffReqMd({
    required this.min,
    required this.max,
    required this.group,
    required this.groupId,
  });

  factory ShiftStaffReqMd.fromJson(Map<String, dynamic> json) {
    return ShiftStaffReqMd(
      min: json['min'] as int,
      max: json['max'] as int,
      group: json['group'] as String,
      groupId: json['groupId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    data['group'] = group;
    data['groupId'] = groupId;
    return data;
  }
}
