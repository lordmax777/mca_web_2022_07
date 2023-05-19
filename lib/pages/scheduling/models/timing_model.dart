import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../manager/models/list_all_md.dart';

class TimingModel {
  TimingModel() {
    repeat = appStore.state.generalState.workRepeats.firstOrNull;
  }

  DateTime? date;
  DateTime? altStartDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool get isAllDay {
    if (startTime != null && endTime != null) {
      if (startTime!.hour == 0 &&
          startTime!.minute == 0 &&
          endTime!.hour == 23 &&
          endTime!.minute == 59) {
        return true;
      }
    }
    return false;
  }

  set isAllDay(bool value) {
    if (value) {
      startTime = const TimeOfDay(hour: 0, minute: 0);
      endTime = const TimeOfDay(hour: 23, minute: 59);
    } else {
      startTime = null;
      endTime = null;
    }
  }

  ListWorkRepeats? repeat;

  Map<int, String> days = {};
  void setDays(List<int> d) {
    days.clear();
    for (final int i in d) {
      days[i] = Constants.daysOfTheWeek[i]!;
    }
  }

  TimingModel copy() {
    final TimingModel copy = TimingModel();
    copy.date = date;
    copy.startTime = startTime;
    copy.endTime = endTime;
    copy.repeat = repeat;
    copy.days = days;
    copy.altStartDate = altStartDate;
    return copy;
  }

  @override
  String toString() {
    return 'TimingModel{date: $date, startTime: $startTime, endTime: $endTime, repeat: ${repeat?.toJson()}, days: $days}';
  }
}
