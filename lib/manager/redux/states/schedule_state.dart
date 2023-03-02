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
  final StateValue<Map<CalendarView, List<Appointment>>> shifts;
  List<Appointment> get getShifts => shifts.data?[CalendarView.day] ?? [];
  List<Appointment> get getWeekShifts => shifts.data?[CalendarView.week] ?? [];
  final List<Appointment> backupShifts;
  final List<Appointment> backupShiftsWeek;
  final List<CalendarResource> users;
  final CalendarView calendarView;
  final SidebarType sidebarType;
  final List<UserRes> filteredUsers;
  final List<LocationItemMd> filteredLocations;
  ScheduleState({
    required this.interval,
    required this.sidebarType,
    required this.shifts,
    required this.backupShifts,
    required this.backupShiftsWeek,
    required this.users,
    required this.calendarView,
    required this.filteredUsers,
    required this.filteredLocations,
  });

  factory ScheduleState.initial() {
    return ScheduleState(
      calendarView: CalendarView.day,
      interval: 60,
      shifts: StateValue<Map<CalendarView, List<Appointment>>>(
          data: {}, error: ErrorModel()),
      backupShifts: [],
      backupShiftsWeek: [],
      users: [],
      sidebarType: SidebarType.user,
      filteredLocations: [],
      filteredUsers: [],
    );
  }

  ScheduleState copyWith({
    CalendarView? calendarView,
    int? interval,
    StateValue<Map<CalendarView, List<Appointment>>>? shifts,
    List<CalendarResource>? users,
    SidebarType? sidebarType,
    List<UserRes>? filteredUsers,
    List<LocationItemMd>? filteredLocations,
    List<Appointment>? backupShifts,
    List<Appointment>? backupShiftsWeek,
  }) {
    return ScheduleState(
      calendarView: calendarView ?? this.calendarView,
      users: users ?? this.users,
      shifts: shifts ?? this.shifts,
      interval: interval ?? this.interval,
      sidebarType: sidebarType ?? this.sidebarType,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      filteredLocations: filteredLocations ?? this.filteredLocations,
      backupShifts: backupShifts ?? this.backupShifts,
      backupShiftsWeek: backupShiftsWeek ?? this.backupShiftsWeek,
    );
  }
}

class UpdateScheduleState {
  final CalendarView? calendarView;
  final int? interval;
  final StateValue<Map<CalendarView, List<Appointment>>>? shifts;
  final List<CalendarResource>? users;
  final SidebarType? sidebarType;
  final List<UserRes>? filteredUsers;
  final List<LocationItemMd>? filteredLocations;
  final List<Appointment>? backupShifts;
  final List<Appointment>? backupShiftsWeek;

  UpdateScheduleState({
    this.calendarView,
    this.interval,
    this.shifts,
    this.users,
    this.sidebarType,
    this.filteredLocations,
    this.filteredUsers,
    this.backupShifts,
    this.backupShiftsWeek,
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

  // @override
  // int get hashCode =>
  //     property.hashCode ^
  //     user.hashCode ^
  //     allocation.hashCode ^
  //     location.hashCode;
  //
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is AppointmentIdMd &&
  //         runtimeType == other.runtimeType &&
  //         property == other.property &&
  //         user == other.user &&
  //         allocation == other.allocation &&
  //         location == other.location;

  //copyWith
  AppointmentIdMd copyWith({
    PropertiesMd? property,
    UserRes? user,
    ShiftMd? allocation,
    LocationItemMd? location,
    int? userCount,
  }) {
    return AppointmentIdMd(
      property: property ?? this.property,
      user: user ?? this.user,
      allocation: allocation ?? this.allocation,
      location: location ?? this.location,
    );
  }
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

class SCFetchShiftsWeekAction {
  //Location id. If not specified user 0
  final int? locationId;
  //User id. If not specified user 0
  final int? userId;
  //Shift id. If not specified user 0
  final int? shiftId;
  //Date in Y-m-d format
  final DateTime startDate;
  final DateTime endDate;

  SCFetchShiftsWeekAction({
    this.locationId,
    this.userId,
    this.shiftId,
    required this.startDate,
    required this.endDate,
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
