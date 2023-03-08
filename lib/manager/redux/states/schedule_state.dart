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
  final StateValue<Map<CalendarView, List<Appointment>>> shifts;
  List<Appointment> get getShifts => shifts.data?[CalendarView.day] ?? [];
  List<Appointment> get getWeekShifts => shifts.data?[CalendarView.week] ?? [];
  List<Appointment> get getMonthShifts =>
      shifts.data?[CalendarView.month] ?? [];

  int countSameShiftStartDate(Appointment ap, {bool isWeek = true}) {
    final AppointmentIdMd id = ap.id as AppointmentIdMd;

    int count = 0;
    DateTime? largestStartDate;
    DateTime? largestEndDate;
    for (final shift in (isWeek ? getWeekShifts : getShifts)) {
      //Find the largest date and compare all if they are included in the largest date

      if (!isWeek) {
        if (largestStartDate == null) {
          largestStartDate = shift.startTime;
          largestEndDate = shift.endTime;
        } else {
          if (largestStartDate.isAfter(shift.startTime)) {
            largestStartDate = shift.startTime;
            largestEndDate = shift.endTime;
          }
        }
      }

      if (isWeek) {
        final isUserView = getSidebarType == SidebarType.user;
        if (isUserView) {
          if (id.user.id == (shift.id as AppointmentIdMd).user.id &&
              ap.startTime == shift.startTime) {
            count++;
          }
        } else {
          if (id.location.id == (shift.id as AppointmentIdMd).location.id &&
              ap.startTime == shift.startTime) {
            count++;
          }
        }
      }
    }

    //compare all if they are included in the largest date and increase count
    if (!isWeek) {
      count = 1;
      for (final shift in getShifts) {
        if (id.user.id == (shift.id as AppointmentIdMd).user.id &&
            shift.startTime.isAfter(largestStartDate!) &&
            shift.endTime.isBefore(largestEndDate!)) {
          count += 1;
        }
      }
    }
    if (!isWeek) {
      if (getFilteredUsers.isNotEmpty && getFilteredUsers.length < 4) {
        count = 1;
      }
    } else {
      if (getFilteredLocations.isNotEmpty && getFilteredLocations.length < 6) {
        count = 1;
      }
    }
    return count;
  }

  final List<Appointment> backupShifts;
  final List<Appointment> backupShiftsWeek;
  final List<Appointment> backupShiftsMonth;
  final List<CalendarResource> userResources;
  final List<CalendarResource> locationResources;
  final CalendarView calendarView;
  final SidebarType sidebarType;
  SidebarType get getSidebarType => sidebarType;
  final List<UserRes> filteredUsers;
  List<UserRes> get getFilteredUsers => filteredUsers;
  final List<LocationItemMd> filteredLocations;
  List<LocationItemMd> get getFilteredLocations => filteredLocations;

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
  });

  factory ScheduleState.initial() {
    return ScheduleState(
      calendarView: CalendarView.day,
      interval: 60,
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
    StateValue<Map<CalendarView, List<Appointment>>>? shifts,
    List<CalendarResource>? userResources,
    List<CalendarResource>? locationResources,
    SidebarType? sidebarType,
    List<UserRes>? filteredUsers,
    List<LocationItemMd>? filteredLocations,
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
    );
  }
}

class UpdateScheduleState {
  final CalendarView? calendarView;
  final int? interval;
  final StateValue<Map<CalendarView, List<Appointment>>>? shifts;
  final List<CalendarResource>? userResources;
  final SidebarType? sidebarType;
  final List<UserRes>? filteredUsers;
  final List<LocationItemMd>? filteredLocations;
  final List<Appointment>? backupShifts;
  final List<Appointment>? backupShiftsWeek;
  final List<Appointment>? backupShiftsMonth;
  final List<CalendarResource>? locationResources;

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
  final LocationItemMd? location;
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
