import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:mix/mix.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../theme/theme.dart';
import '../../models/property_md.dart';
import '../../models/shift_md.dart';
import '../../models/users_list.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';

int _findLargestAppointmentCountDayInIsolate(Map<String, dynamic> args) {
  print("Isolate START");
  final List<ShiftMd> list = args['list'] as List<ShiftMd>;
  int largestAppointmentCountDay = args['largestAppointmentCountDay'] as int;
  for (var e in list) {
    int max = 0;
    for (var a in list) {
      if (e.userId == a.userId) {
        max++;
      }
    }
    largestAppointmentCountDay = max;
  }

  return largestAppointmentCountDay;
}

class ScheduleMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case SCDragEndAction:
        return _onDragEnd(store.state.scheduleState, action, next);
      case SCFetchShiftsAction:
        return _onFetchShifts(store.state, action, next);
      case SCFetchShiftsWeekAction:
        return _onFetchShiftsWeek(store.state, action, next);
      case SCFetchShiftsMonthAction:
        return _onFetchShiftsMonth(store.state, action, next);
      case SCAddFilter:
        return _onAddFilter(store.state, action, next);
      case SCChangeCalendarView:
        return _onChangeCalendarView(store.state, action, next);
      case SCChangeSidebarType:
        return _onChangeSidebarType(store.state, action, next);
      case SCCopyAllocationAction:
        return _onCopyAllocation(store.state, action, next);
      default:
        return next(action);
    }
  }

  void _onDragEnd(
      ScheduleState state, SCDragEndAction action, NextDispatcher next) async {
    final isUserView = state.sidebarType == SidebarType.user;
    final appointmentDragEndDetails = action.details;
    final stateVal = state.shifts;
    List<Appointment> appointments = state.getShifts;
    final interval = state.interval;
    dynamic toUser = (action.details.targetResource?.id);

    final appointment = appointmentDragEndDetails.appointment as Appointment;
    // if (appointment.startTime.minute % interval != 0) {
    if (CalendarView.week == state.calendarView) {
      appointments = state.getWeekShifts;
    } else if (CalendarView.month == state.calendarView) {
      appointments = state.getMonthShifts;
    }
    Appointment? found = appointments
        .firstWhereOrNull((element) => element.id == appointment.id);
    if (found == null) return;
    final itemId = found.id as AppointmentIdMd;
    final oldAppointment = Appointment(
      startTime: found.startTime,
      endTime: found.endTime,
      id: found.id,
      color: found.color,
      resourceIds: found.resourceIds,
      notes: found.notes,
      subject: found.subject,
      location: found.location,
      isAllDay: found.isAllDay,
      recurrenceRule: found.recurrenceRule,
      recurrenceExceptionDates: found.recurrenceExceptionDates,
      recurrenceId: found.recurrenceId,
      startTimeZone: found.startTimeZone,
      endTimeZone: found.endTimeZone,
    );

    ///TODO: @DEPRECATED()
    if (state.calendarView == CalendarView.day) {
      // found.startTime = appointment.startTime
      //     .subtract(Duration(minutes: appointment.startTime.minute % interval));
      // found.endTime = appointment.endTime
      //     .subtract(Duration(minutes: appointment.endTime.minute % interval));
    } else if (state.calendarView == CalendarView.week) {
      //Always start at 00:00 and end at 01:00
      final DateTime oldDate = DateTime.parse(itemId.allocation.date);
      oldAppointment.startTime =
          DateTime(oldDate.year, oldDate.month, oldDate.day, 0, 0);
      oldAppointment.endTime =
          DateTime(oldDate.year, oldDate.month, oldDate.day, 1, 0);
      found.startTime = DateTime(appointment.startTime.year,
          appointment.startTime.month, appointment.startTime.day, 0, 0);
      found.endTime = DateTime(appointment.endTime.year,
          appointment.endTime.month, appointment.endTime.day, 1, 0);
      appointments.removeWhere((element) => element.id == found.id);
      stateVal.data?[CalendarView.week] = [
        ...appointments,
        found,
        oldAppointment
      ];
    }
    found.resourceIds = [toUser];
    oldAppointment.resourceIds = [toUser];
    if (isUserView) {
      found.id = (found.id as AppointmentIdMd).copyWith(user: toUser);
      oldAppointment.id =
          (oldAppointment.id as AppointmentIdMd).copyWith(user: toUser);
    } else {
      found.id = (found.id as AppointmentIdMd).copyWith(location: toUser);
      oldAppointment.id =
          (oldAppointment.id as AppointmentIdMd).copyWith(location: toUser);
    }
    next(UpdateScheduleState(shifts: stateVal));
    // final ApiResponse res = await restClient()
    //     .postShifts(
    //         itemId.location.id!,
    //         itemId.user.id,
    //         itemId.allocation.shiftId,
    //         DateFormat('yyyy-MM-dd').format(found.startTime),
    //         "add")
    //     .nocodeErrorHandler();
    // if (res.success) {
    //   if (state.calendarView == CalendarView.day) {
    //     found.startTime = appointment.startTime.subtract(
    //         Duration(minutes: appointment.startTime.minute % interval));
    //     found.endTime = appointment.endTime
    //         .subtract(Duration(minutes: appointment.endTime.minute % interval));
    //   } else if (CalendarView.week == state.calendarView) {
    //     //Always start at 00:00 and end at 01:00
    //     // final dateTime = DateTime.parse(itemId.allocation.date);
    //     found.startTime = DateTime(appointment.startTime.year,
    //         appointment.startTime.month, appointment.startTime.day, 0, 0);
    //     found.endTime = DateTime(appointment.endTime.year,
    //         appointment.endTime.month, appointment.endTime.day, 1, 0);
    //     stateVal.data?[CalendarView.week] = [...appointments, found];
    //   }
    //   found.resourceIds = [toUser];
    //   if (isUserView) {
    //     found.id = (found.id as AppointmentIdMd).copyWith(user: toUser);
    //   } else {
    //     found.id = (found.id as AppointmentIdMd).copyWith(location: toUser);
    //   }
    //   next(UpdateScheduleState(shifts: stateVal));
    // } else {
    //   found.startTime = appointment.startTime;
    //   found.endTime = appointment.endTime;
    // }
    // }
  }

  void _onFetchShifts(
      AppState state, SCFetchShiftsAction action, NextDispatcher next) async {
    final locId = action.locationId ?? 0;
    final userId = action.userId ?? 0;
    final shiftId = action.shiftId ?? 0;
    final date = action.date;
    final stateVal = state.scheduleState.shifts;
    int largestAppointmentCountDay = 0;

    stateVal.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateVal));

    final ApiResponse res = await restClient()
        .getShifts(
            locId, userId, shiftId, DateFormat('yyyy-MM-dd').format(date))
        .nocodeErrorHandler();

    if (res.success) {
      final list = <ShiftMd>[];
      final appointments = <Appointment>[];
      final properties = <PropertiesMd>[
        ...(state.generalState.properties.data ?? <PropertiesMd>[])
      ];
      final users = <UserRes>[...(state.usersState.usersList.data ?? [])];
      final locs = <PropertiesMd>[
        ...(state.generalState.properties.data ?? [])
      ];
      for (var item in res.data['allocations']) {
        final ShiftMd shift = ShiftMd.fromJson(item);
        list.add(shift);
        final pr = properties
            .firstWhereOrNull((element) => element.id == shift.shiftId);
        if (pr == null) continue;
        final us =
            users.firstWhereOrNull((element) => element.id == shift.userId);
        if (us == null) continue;
        final loc =
            locs.firstWhereOrNull((element) => element.id == pr.locationId);
        if (loc == null) continue;

        final startTime = TimeOfDay(
            hour: int.parse(pr.startTime!.substring(0, 2)),
            minute: int.parse(pr.startTime!.substring(3, 5)));

        final st = DateTime(
            date.year, date.month, date.day, startTime.hour, startTime.minute);
        DateTime? et;
        if (pr.finishTime != null) {
          final endTime = TimeOfDay(
              hour: int.parse(pr.finishTime!.substring(0, 2)),
              minute: int.parse(pr.finishTime!.substring(3, 5)));
          et = DateTime(
              date.year, date.month, date.day, endTime.hour, endTime.minute);
        }
        final AppointmentIdMd id = AppointmentIdMd(
          user: us,
          allocation: shift,
          property: pr,
        );
        appointments.add(Appointment(
          startTime: st,
          endTime: et ?? DateTime.now(),
          isAllDay: et == null,
          color: us.userRandomBgColor,
          subject: pr.title ?? "-",
          id: id,
          resourceIds: [us],
        ));
      }

      // compute(_findLargestAppointmentCountDayInIsolate, {
      //   "list": list,
      //   "largestAppointmentCountDay": largestAppointmentCountDay,
      // }).then((value) {
      //   largestAppointmentCountDay = value;
      //   // next(UpdateScheduleState(
      //   //   largestAppointmentCountDay: largestAppointmentCountDay,
      //   // ));
      //   print("Isolate FINISH");
      // });

      // Finds the occurrence of resourceIds and
      // sets the largestAppointmentCountDay
      for (var e in list) {
        int max = 0;
        for (var a in list) {
          if (e.userId == a.userId) {
            max++;
          }
        }
        if (max > largestAppointmentCountDay) {
          largestAppointmentCountDay = max;
        }
      }

      logger("Largest Appointment Count Day: $largestAppointmentCountDay");

      stateVal.error.isLoading = false;
      stateVal.data?[CalendarView.day] = appointments;
      stateVal.error.action = action;
      stateVal.error.isError = false;

      next(UpdateScheduleState(
        shifts: stateVal,
        backupShifts: appointments,
        largestAppointmentCountDay: largestAppointmentCountDay,
      ));
    } else {
      stateVal.error.isLoading = false;
      stateVal.data?[CalendarView.day] = [];
      stateVal.error.action = action;
      stateVal.error.isError = false;
      if (res.resCode != 404) {
        stateVal.error.isError = true;
        stateVal.error.errorCode = res.resCode;
        stateVal.error.errorMessage = res.resMessage;
        stateVal.error.rawError = res.rawError;
        stateVal.error.retries = stateVal.error.retries + 1;
      }
      next(UpdateScheduleState(shifts: stateVal, backupShifts: []));
    }
  }

  void _onFetchShiftsWeek(AppState state, SCFetchShiftsWeekAction action,
      NextDispatcher next) async {
    final locId = action.locationId ?? 0;
    final userId = action.userId ?? 0;
    final shiftId = action.shiftId ?? 0;
    final startDate = action.startDate;
    final endDate = action.endDate;
    final stateVal = state.scheduleState.shifts;
    int largestAppointmentCountWeek = 0;

    stateVal.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateVal));

    final ApiResponse res = await restClient()
        .getShifts(
            locId, userId, shiftId, DateFormat('yyyy-MM-dd').format(startDate),
            until: DateFormat('yyyy-MM-dd').format(endDate))
        .nocodeErrorHandler();

    if (res.success) {
      final list = <ShiftMd>[];
      final appointments = <Appointment>[];
      final properties = <PropertiesMd>[
        ...(state.generalState.properties.data ?? <PropertiesMd>[])
      ];
      final users = <UserRes>[...(state.usersState.usersList.data ?? [])];
      for (var item in res.data['allocations']) {
        final ShiftMd shift = ShiftMd.fromJson(item);
        list.add(shift);
        final pr = properties
            .firstWhereOrNull((element) => element.id == shift.shiftId);
        if (pr == null) continue;
        final us =
            users.firstWhereOrNull((element) => element.id == shift.userId);
        if (us == null) continue;

        final DateTime date = DateTime.parse(shift.date);
        final st = DateTime(date.year, date.month, date.day, 00, 00);
        final et = DateTime(date.year, date.month, date.day, 01, 00);

        final AppointmentIdMd id = AppointmentIdMd(
          user: us,
          allocation: shift,
          property: pr,
        );

        appointments.add(Appointment(
          startTime: st,
          endTime: et,
          color: id.user.userRandomBgColor,
          subject: pr.title ?? "-",
          id: id,
          resourceIds: [us, pr],
        ));
      }

      bool isSameDate(DateTime a, DateTime b) {
        return a.year == b.year && a.month == b.month && a.day == b.day;
      }

      // Finds the occurrence of resourceIds and
      // sets the largestAppointmentCountWeek
      for (var e in list) {
        int max = 0;
        for (var a in appointments) {
          if (isSameDate(DateTime.parse(e.date), a.startTime)) {
            if (e.userId == (a.id! as AppointmentIdMd).user.id) {
              max++;
            }
          }
        }
        if (max > largestAppointmentCountWeek) {
          largestAppointmentCountWeek = max;
        }
      }

      logger("Largest Appointment Count Week: $largestAppointmentCountWeek");

      stateVal.error.isLoading = false;
      stateVal.data?[CalendarView.week] = appointments;
      stateVal.error.action = action;
      stateVal.error.isError = false;

      next(UpdateScheduleState(
        shifts: stateVal,
        largestAppointmentCountWeek: largestAppointmentCountWeek,
        backupShiftsWeek: appointments,
      ));
    } else {
      stateVal.error.isLoading = false;
      stateVal.data?[CalendarView.week] = [];
      stateVal.error.action = action;
      stateVal.error.isError = false;
      if (res.resCode != 404) {
        stateVal.error.isError = true;
        stateVal.error.errorCode = res.resCode;
        stateVal.error.errorMessage = res.resMessage;
        stateVal.error.rawError = res.rawError;
        stateVal.error.retries = stateVal.error.retries + 1;
      }
      next(UpdateScheduleState(shifts: stateVal, backupShiftsWeek: []));
    }
  }

  void _onFetchShiftsMonth(AppState state, SCFetchShiftsMonthAction action,
      NextDispatcher next) async {
    final locId = action.locationId ?? 0;
    final userId = action.userId ?? 0;
    final shiftId = action.shiftId ?? 0;
    final startDate = action.startDate;
    //Find the last day of the month
    final endDate = DateTime(startDate.year, startDate.month + 1, 0);
    final stateVal = state.scheduleState.shifts;

    stateVal.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateVal));

    final ApiResponse res = await restClient()
        .getShifts(
            locId, userId, shiftId, DateFormat('yyyy-MM-dd').format(startDate),
            until: DateFormat('yyyy-MM-dd').format(endDate))
        .nocodeErrorHandler();

    if (res.success) {
      final list = <ShiftMd>[];
      final appointments = <Appointment>[];
      final properties = <PropertiesMd>[
        ...(state.generalState.properties.data ?? <PropertiesMd>[])
      ];
      final users = <UserRes>[...(state.usersState.usersList.data ?? [])];
      for (var item in res.data['allocations']) {
        final ShiftMd shift = ShiftMd.fromJson(item);
        list.add(shift);
        final pr = properties
            .firstWhereOrNull((element) => element.id == shift.shiftId);
        if (pr == null) continue;
        final us =
            users.firstWhereOrNull((element) => element.id == shift.userId);
        if (us == null) continue;

        final DateTime date = DateTime.parse(shift.date);
        final st = DateTime(date.year, date.month, date.day, 00, 00);
        final et = DateTime(date.year, date.month, date.day, 01, 00);

        final AppointmentIdMd id = AppointmentIdMd(
          user: us,
          allocation: shift,
          property: pr,
        );

        appointments.add(Appointment(
          startTime: st,
          endTime: et,
          color: id.user.userRandomBgColor,
          subject: pr.title ?? "-",
          id: id,
          resourceIds: [us, pr],
        ));
      }

      stateVal.error.isLoading = false;
      stateVal.data?[CalendarView.month] = appointments;
      stateVal.error.action = action;
      stateVal.error.isError = false;

      next(UpdateScheduleState(
        shifts: stateVal,
        backupShiftsMonth: appointments,
      ));
    } else {
      stateVal.error.isLoading = false;
      stateVal.data?[CalendarView.month] = [];
      stateVal.error.action = action;
      stateVal.error.isError = false;
      if (res.resCode != 404) {
        stateVal.error.isError = true;
        stateVal.error.errorCode = res.resCode;
        stateVal.error.errorMessage = res.resMessage;
        stateVal.error.rawError = res.rawError;
        stateVal.error.retries = stateVal.error.retries + 1;
      }
      next(UpdateScheduleState(shifts: stateVal, backupShiftsMonth: []));
    }
  }

  void _onAddFilter(
      AppState state, SCAddFilter action, NextDispatcher next) async {
    final user = action.user;
    final loc = action.location;
    final filter = state.scheduleState.filteredUsers;
    final filterLocs = state.scheduleState.filteredLocations;
    if (user != null) {
      if (user.username == "All") {
        filter.clear();
      } else {
        if (filter.contains(user)) {
          filter.remove(user);
        } else {
          filter.add(user);
        }
      }
      //Handle user filtering
      final users = state.scheduleState.userResources;
      if (filter.isNotEmpty) {
        users.clear();
        for (int i = 0; i < filter.length; i++) {
          users.add(filter[i]);
          users.sort((a, b) => (a).firstName.compareTo(b.firstName));
        }
      } else {
        users.clear();
        users.addAll((appStore.state.usersState.usersList.data ?? []));
      }
      next(UpdateScheduleState(filteredUsers: filter, userResources: users));
    } else if (loc != null) {
      if (loc.title == "All") {
        filterLocs.clear();
      } else {
        if (filterLocs.contains(loc)) {
          filterLocs.remove(loc);
        } else {
          filterLocs.add(loc);
        }
      }
      //Handle loc filtering
      final locs = state.scheduleState.locationResources;
      if (filterLocs.isNotEmpty) {
        locs.clear();
        for (int i = 0; i < filterLocs.length; i++) {
          locs.add(filterLocs[i]);
          locs.sort((a, b) => a.title!.compareTo(b.title!));
        }
      } else {
        locs.clear();

        locs.addAll(
            (appStore.state.generalState.properties.data ?? []).map((e) => e));
      }
      next(UpdateScheduleState(filteredUsers: filter, locationResources: locs));
    }
  }

  void _onChangeCalendarView(
      AppState state, SCChangeCalendarView action, NextDispatcher next) async {
    final view = action.view;
    SidebarType sidebarType = state.scheduleState.sidebarType;
    int interval = state.scheduleState.interval;
    if (view == CalendarView.day) {
      sidebarType = SidebarType.user;
      interval = 60;
    }
    if (view == CalendarView.week) {
      interval = 60;
    }
    appStore.dispatch(SCAddFilter(location: PropertiesMd.all()));
    appStore.dispatch(SCAddFilter(user: UserRes.all()));
    next(UpdateScheduleState(
      calendarView: view,
      sidebarType: sidebarType,
      interval: interval,
      filteredUsers: [],
      filteredLocations: [],
    ));
  }

  void _onChangeSidebarType(
      AppState state, SCChangeSidebarType action, NextDispatcher next) async {
    SidebarType sidebarType = state.scheduleState.sidebarType;
    if (sidebarType == SidebarType.user) {
      sidebarType = SidebarType.location;
      appStore.dispatch(SCAddFilter(location: PropertiesMd.all()));
    } else {
      sidebarType = SidebarType.user;
      appStore.dispatch(SCAddFilter(user: UserRes.all()));
    }
    next(UpdateScheduleState(
      sidebarType: sidebarType,
    ));
  }

  void _onCopyAllocation(AppState state, SCCopyAllocationAction action,
      NextDispatcher next) async {
    final allocation = action.allocation;
    String target() => DateFormat('yyyy-MM-dd').format(action.targetDate);
    String date() => DateFormat('yyyy-MM-dd')
        .format(action.allocation.allocation.dateTimeDate!);
    final stateValue = state.scheduleState.shifts;
    stateValue.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateValue));
    //To copy all shifts, use action.isAll and shiftId must be 0
    //To copy single shift, use !action.isAll and shiftId must be the id of the shift
    final ApiResponse res = await restClient()
        .postShifts(
          allocation.property.locationId ?? 0,
          action.allocation.user.id,
          action.isAll ? 0 : (allocation.allocation.id ?? 0),
          date(),
          "copy",
          date_until: action.isAll ? null : date(),
          target_location: action.targetLocationId,
          target_user: action.targetUserId,
          target_date: target(),
        )
        .nocodeErrorHandler();
    stateValue.error.isLoading = false;
    next(UpdateScheduleState(shifts: stateValue));
    if (!res.success) {
    } else {
      await appStore.dispatch(action.fetchAction);
      showError("Shift copied successfully", titleMsg: "Success");
    }
  }
}
