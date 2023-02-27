import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../model_exporter.dart';
import '../../models/location_item_md.dart';
import '../../models/shift_md.dart';

@immutable
class ScheduleState {
  final int interval;
  final List<Appointment> shifts;
  final List<CalendarResource> users;
  final CalendarView calendarView;
  final List<ShiftMd> fetchedShifts;
  ScheduleState({
    required this.interval,
    required this.shifts,
    required this.users,
    required this.calendarView,
    required this.fetchedShifts,
  });

  factory ScheduleState.initial() {
    return ScheduleState(
      calendarView: CalendarView.timelineDay,
      interval: 15,
      shifts: [],
      users: [],
      fetchedShifts: [],
    );
  }

  ScheduleState copyWith({
    CalendarView? calendarView,
    int? interval,
    List<Appointment>? shifts,
    List<CalendarResource>? users,
    List<ShiftMd>? fetchedShifts,
  }) {
    return ScheduleState(
      calendarView: calendarView ?? this.calendarView,
      users: users ?? this.users,
      shifts: shifts ?? this.shifts,
      interval: interval ?? this.interval,
      fetchedShifts: fetchedShifts ?? this.fetchedShifts,
    );
  }
}

class AppointmentIdMd {
  final PropertiesMd property;
  final UserRes user;
  final ShiftMd allocation;
  final LocationItemMd location;

  AppointmentIdMd({
    required this.property,
    required this.user,
    required this.location,
    required this.allocation,
  });
}

class UpdateScheduleState {
  final CalendarView? calendarView;
  final int? interval;
  final List<Appointment>? shifts;
  final List<CalendarResource>? users;
  final List<ShiftMd>? fetchedShifts;
  UpdateScheduleState({
    this.calendarView,
    this.interval,
    this.shifts,
    this.users,
    this.fetchedShifts,
  });
}

class SCDragEndAction {
  AppointmentDragEndDetails details;
  SCDragEndAction(this.details);
}

class SCFetchShiftsAction {
  //Location id. If not specified user 0
  final int? locationId;
  //User id. If not specified user 0
  final int? userId;
  //Shift id. If not specified user 0
  final int? shiftId;
  //Date in Y-m-d format
  final DateTime date;

  SCFetchShiftsAction({
    this.locationId,
    this.userId,
    this.shiftId,
    required this.date,
  });
}
