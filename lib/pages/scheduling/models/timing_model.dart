import 'package:flutter/material.dart';

import '../../../manager/models/list_all_md.dart';

class TimingModel {
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool get isAllDay {
    if (startTime == null && endTime == null) {
      if (startTime == const TimeOfDay(hour: 0, minute: 0) &&
          endTime == const TimeOfDay(hour: 23, minute: 59)) {
        return true;
      }
    }
    return false;
  }

  ListWorkRepeats? repeat;

  Map<int, String> days = {};
}
