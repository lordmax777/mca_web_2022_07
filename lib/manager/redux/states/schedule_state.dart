import 'package:flutter/foundation.dart';
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

class ResourceIdMd {
  final UserRes? user;
  final LocationItemMd? location;

  ResourceIdMd({this.user, this.location});

  // implement copyWith
  ResourceIdMd copyWith({
    UserRes? user,
    LocationItemMd? location,
  }) {
    return ResourceIdMd(
      user: user ?? this.user,
      location: location ?? this.location,
    );
  }
}

@immutable
class ScheduleState {
  final int interval;
  final int largestAppointmentCountDay;
  final int largestAppointmentCountWeek;

  final StateValue<Map<CalendarView, List<Appointment>>> shifts;
  List<Appointment> get getShifts => shifts.data?[CalendarView.day] ?? [];
  List<Appointment> get getWeekShifts => shifts.data?[CalendarView.week] ?? [];
  List<Appointment> get getMonthShifts =>
      shifts.data?[CalendarView.month] ?? [];

  final List<Appointment> backupShifts;
  final List<Appointment> backupShiftsWeek;
  final List<Appointment> backupShiftsMonth;
  final List<UserRes> userResources;
  final List<PropertiesMd> locationResources;
  final CalendarView calendarView;
  final SidebarType sidebarType;
  SidebarType get getSidebarType => sidebarType;
  final List<UserRes> filteredUsers;
  List<UserRes> get getFilteredUsers => filteredUsers;
  final List<PropertiesMd> filteredLocations;
  List<PropertiesMd> get getFilteredLocations => filteredLocations;

  const ScheduleState({
    required this.interval,
    required this.sidebarType,
    required this.shifts,
    required this.backupShifts,
    required this.backupShiftsWeek,
    required this.backupShiftsMonth,
    required this.userResources,
    required this.locationResources,
    required this.calendarView,
    required this.filteredUsers,
    required this.filteredLocations,
    required this.largestAppointmentCountDay,
    required this.largestAppointmentCountWeek,
  });

  factory ScheduleState.initial() {
    return ScheduleState(
      calendarView: kDebugMode ? CalendarView.week : CalendarView.day,
      interval: 60,
      largestAppointmentCountDay: 1,
      largestAppointmentCountWeek: 1,
      shifts: StateValue<Map<CalendarView, List<Appointment>>>(
          data: {}, error: ErrorModel()),
      backupShifts: [],
      backupShiftsWeek: [],
      backupShiftsMonth: [],
      userResources: [],
      locationResources: [],
      sidebarType: SidebarType.user,
      filteredLocations: [],
      filteredUsers: [],
    );
  }

  ScheduleState copyWith({
    CalendarView? calendarView,
    int? interval,
    int? largestAppointmentCountDay,
    int? largestAppointmentCountWeek,
    StateValue<Map<CalendarView, List<Appointment>>>? shifts,
    List<UserRes>? userResources,
    List<PropertiesMd>? locationResources,
    SidebarType? sidebarType,
    List<UserRes>? filteredUsers,
    List<PropertiesMd>? filteredLocations,
    List<Appointment>? backupShifts,
    List<Appointment>? backupShiftsWeek,
    List<Appointment>? backupShiftsMonth,
  }) {
    return ScheduleState(
      calendarView: calendarView ?? this.calendarView,
      userResources: userResources ?? this.userResources,
      shifts: shifts ?? this.shifts,
      interval: interval ?? this.interval,
      sidebarType: sidebarType ?? this.sidebarType,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      filteredLocations: filteredLocations ?? this.filteredLocations,
      backupShifts: backupShifts ?? this.backupShifts,
      backupShiftsWeek: backupShiftsWeek ?? this.backupShiftsWeek,
      locationResources: locationResources ?? this.locationResources,
      backupShiftsMonth: backupShiftsMonth ?? this.backupShiftsMonth,
      largestAppointmentCountDay:
          largestAppointmentCountDay ?? this.largestAppointmentCountDay,
      largestAppointmentCountWeek:
          largestAppointmentCountWeek ?? this.largestAppointmentCountWeek,
    );
  }
}

class UpdateScheduleState {
  final CalendarView? calendarView;
  final int? interval;
  final StateValue<Map<CalendarView, List<Appointment>>>? shifts;
  final List<UserRes>? userResources;
  final SidebarType? sidebarType;
  final List<UserRes>? filteredUsers;
  final List<PropertiesMd>? filteredLocations;
  final List<Appointment>? backupShifts;
  final List<Appointment>? backupShiftsWeek;
  final List<Appointment>? backupShiftsMonth;
  final List<PropertiesMd>? locationResources;
  final int? largestAppointmentCountDay;
  final int? largestAppointmentCountWeek;

  UpdateScheduleState({
    this.calendarView,
    this.interval,
    this.shifts,
    this.userResources,
    this.sidebarType,
    this.filteredLocations,
    this.filteredUsers,
    this.backupShifts,
    this.backupShiftsWeek,
    this.locationResources,
    this.backupShiftsMonth,
    this.largestAppointmentCountWeek,
    this.largestAppointmentCountDay,
  });
}

class AppointmentIdMd {
  final PropertiesMd property;
  final UserRes user;
  final ShiftMd allocation;

  AppointmentIdMd({
    required this.property,
    required this.user,
    required this.allocation,
  });

  AppointmentIdMd copyWith({
    PropertiesMd? property,
    UserRes? user,
    ShiftMd? allocation,
    PropertiesMd? location,
  }) {
    return AppointmentIdMd(
      property: property ?? this.property,
      user: user ?? this.user,
      allocation: allocation ?? this.allocation,
    );
  }
}

class AppointmentIdMd1 {
  final DateTime startTime;
  final DateTime endTime;
  final PropertiesMd property;
  final UserRes user;
  final ShiftMd allocation;

  AppointmentIdMd1({
    required this.startTime,
    required this.endTime,
    required this.property,
    required this.user,
    required this.allocation,
  });

  AppointmentIdMd1 copyWith({
    PropertiesMd? property,
    UserRes? user,
    ShiftMd? allocation,
    PropertiesMd? location,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return AppointmentIdMd1(
      property: property ?? this.property,
      user: user ?? this.user,
      allocation: allocation ?? this.allocation,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppointmentIdMd1 &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.property == property &&
        other.user == user &&
        other.allocation == allocation;
  }

  @override
  int get hashCode {
    return startTime.hashCode ^
        endTime.hashCode ^
        property.hashCode ^
        user.hashCode ^
        allocation.hashCode;
  }
}

class SCDragEndAction {
  final AppointmentDragEndDetails details;
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

class SCAddFilter {
  final UserRes? user;
  final PropertiesMd? location;
  SCAddFilter({
    this.user,
    this.location,
  });
}

class SCChangeCalendarView {
  final CalendarView view;
  SCChangeCalendarView(this.view);
}

class SCChangeSidebarType {}

class SCFetchShiftMonthAction {
  //Location id. If not specified user 0
  final int? locationId;
  //User id. If not specified user 0
  final int? userId;
  //Shift id. If not specified user 0
  final int? shiftId;
  //Date in Y-m-d format
  final DateTime startDate;
  final DateTime endDate;

  SCFetchShiftMonthAction({
    this.locationId,
    this.userId,
    this.shiftId,
    required this.startDate,
    required this.endDate,
  });
}
