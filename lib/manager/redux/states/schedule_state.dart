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
  final LocationAddress? location;

  ResourceIdMd({this.user, this.location});

  // implement copyWith
  ResourceIdMd copyWith({
    UserRes? user,
    LocationAddress? location,
  }) {
    return ResourceIdMd(
      user: user ?? this.user,
      location: location ?? this.location,
    );
  }
}

@immutable
class ScheduleState {
  final StateValue<Map<CalendarView, List<Appointment>>> shifts;
  List<Appointment> get getDayShifts => shifts.data?[CalendarView.day] ?? [];
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

  bool get isUserView => sidebarType == SidebarType.user;

  const ScheduleState({
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
      calendarView: kDebugMode ? CalendarView.week : CalendarView.day,
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
  final StateValue<Map<CalendarView, List<Appointment>>>? shifts;
  final List<UserRes>? userResources;
  final SidebarType? sidebarType;
  final List<UserRes>? filteredUsers;
  final List<PropertiesMd>? filteredLocations;
  final List<Appointment>? backupShifts;
  final List<Appointment>? backupShiftsWeek;
  final List<Appointment>? backupShiftsMonth;
  final List<PropertiesMd>? locationResources;

  UpdateScheduleState({
    this.calendarView,
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

class SCFetchShiftsMonthAction {
  //Location id. If not specified user 0
  final int? locationId;
  //User id. If not specified user 0
  final int? userId;
  //Shift id. If not specified user 0
  final int? shiftId;
  //Date in Y-m-d format
  final DateTime startDate;

  SCFetchShiftsMonthAction({
    this.locationId,
    this.userId,
    this.shiftId,
    required this.startDate,
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

// TEST
// Single Same 0
// Multiple Same 0
//
// Single Different 0
// Multiple Different 0

class SCCopyAllocationAction {
  final AppointmentIdMd allocation;
  final DateTime targetDate;
  final dynamic fetchAction;
  final int? targetUserId;
  final int? targetLocationId;
  final int? targetShiftId;

  const SCCopyAllocationAction({
    required this.allocation,
    required this.targetDate,
    required this.fetchAction,
    this.targetLocationId,
    this.targetShiftId,
    this.targetUserId,
  });
}

class SCCopyAllAllocationAction {
  final AppointmentIdMd allocation;
  final DateTime targetDate;
  final dynamic fetchAction;
  final int? targetUserId;
  final int? targetLocationId;
  final int? targetShiftId;
  final int? locationId;

  const SCCopyAllAllocationAction({
    required this.allocation,
    required this.targetDate,
    this.locationId,
    required this.fetchAction,
    this.targetLocationId,
    this.targetShiftId,
    this.targetUserId,
  });
}

class SCRemoveAllocationAction<T> {
  final AppointmentIdMd allocation;
  final dynamic fetchAction;

  const SCRemoveAllocationAction({
    required this.allocation,
    required this.fetchAction,
  });
}

class SCOnCreateNewTap {
  final CalendarTapDetails calendarTapDetails;

  SCOnCreateNewTap(this.calendarTapDetails);
}

class SCOnCopyAllocationTap {
  final CalendarTapDetails calendarTapDetails;
  Map<String, dynamic> selectedAppointment;
  final BuildContext context;
  final SCFetchShiftsWeekAction fetchShiftsWeekAction;

  SCOnCopyAllocationTap(this.calendarTapDetails, this.selectedAppointment,
      this.context, this.fetchShiftsWeekAction);
}
