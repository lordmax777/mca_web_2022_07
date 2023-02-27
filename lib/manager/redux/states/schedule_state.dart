import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../model_exporter.dart';
import '../../models/location_item_md.dart';
import '../../models/shift_md.dart';

enum SidebarType { user, location }

extension SidebarTypeExt on SidebarType {
  String get name => toString().split('.').last;
}

@immutable
class ScheduleState {
  final int interval;
  final List<Appointment> shifts;
  final List<Appointment> backupShifts;
  final List<CalendarResource> users;
  final CalendarView calendarView;
  final List<ShiftMd> fetchedShifts;
  final SidebarType sidebarType;
  final List<UserRes> filteredUsers;
  final List<LocationItemMd> filteredLocations;
  ScheduleState({
    required this.interval,
    required this.sidebarType,
    required this.shifts,
    required this.backupShifts,
    required this.users,
    required this.calendarView,
    required this.fetchedShifts,
    required this.filteredUsers,
    required this.filteredLocations,
  });

  factory ScheduleState.initial() {
    return ScheduleState(
      calendarView: CalendarView.timelineDay,
      interval: 60,
      shifts: [],
      backupShifts: [],
      users: [],
      fetchedShifts: [],
      sidebarType: SidebarType.user,
      filteredLocations: [],
      filteredUsers: [],
    );
  }

  ScheduleState copyWith({
    CalendarView? calendarView,
    int? interval,
    List<Appointment>? shifts,
    List<CalendarResource>? users,
    List<ShiftMd>? fetchedShifts,
    SidebarType? sidebarType,
    List<UserRes>? filteredUsers,
    List<LocationItemMd>? filteredLocations,
    List<Appointment>? backupShifts,
  }) {
    return ScheduleState(
        calendarView: calendarView ?? this.calendarView,
        users: users ?? this.users,
        shifts: shifts ?? this.shifts,
        interval: interval ?? this.interval,
        fetchedShifts: fetchedShifts ?? this.fetchedShifts,
        sidebarType: sidebarType ?? this.sidebarType,
        filteredUsers: filteredUsers ?? this.filteredUsers,
        filteredLocations: filteredLocations ?? this.filteredLocations,
        backupShifts: backupShifts ?? this.backupShifts);
  }
}

class UpdateScheduleState {
  final CalendarView? calendarView;
  final int? interval;
  final List<Appointment>? shifts;
  final List<CalendarResource>? users;
  final List<ShiftMd>? fetchedShifts;
  final SidebarType? sidebarType;
  final List<UserRes>? filteredUsers;
  final List<LocationItemMd>? filteredLocations;
  final List<Appointment>? backupShifts;
  UpdateScheduleState({
    this.calendarView,
    this.interval,
    this.shifts,
    this.users,
    this.fetchedShifts,
    this.sidebarType,
    this.filteredLocations,
    this.filteredUsers,
    this.backupShifts,
  });
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

class SCAddFilterUser {
  final UserRes user;
  SCAddFilterUser(this.user);
}

class SCChangeCalendarView {
  final CalendarView view;
  SCChangeCalendarView(this.view);
}
