import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../theme/theme.dart';
import '../../models/location_item_md.dart';
import '../../models/property_md.dart';
import '../../models/shift_md.dart';
import '../../models/users_list.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';

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
      case SCAddFilter:
        return _onAddFilter(store.state, action, next);
      case SCChangeCalendarView:
        return _onChangeCalendarView(store.state, action, next);
      case SCChangeSidebarType:
        return _onChangeSidebarType(store.state, action, next);
      default:
        return next(action);
    }
  }

  void _onDragEnd(
      ScheduleState state, SCDragEndAction action, NextDispatcher next) {
    final isUserView = state.sidebarType == SidebarType.user;
    final appointmentDragEndDetails = action.details;
    List<Appointment> appointments = state.getShifts;
    final interval = state.interval;
    dynamic toUser = (action.details.targetResource?.id);
    if (isUserView) {
      toUser = toUser as UserRes;
    } else {
      toUser = toUser as LocationItemMd;
    }

    final appointment = appointmentDragEndDetails.appointment as Appointment;
    if (appointment.startTime.minute % interval != 0) {
      if (CalendarView.week == state.calendarView) {
        appointments = state.getWeekShifts;
      }
      Appointment? found = appointments
          .firstWhereOrNull((element) => element.id == appointment.id);
      if (found == null) return;
      if (state.calendarView == CalendarView.day) {
        found.startTime = appointment.startTime.subtract(
            Duration(minutes: appointment.startTime.minute % interval));
        found.endTime = appointment.endTime
            .subtract(Duration(minutes: appointment.endTime.minute % interval));
      } else if (CalendarView.week == state.calendarView) {
        //Always start at 00:00 and end at 01:00
        found.startTime = DateTime(appointment.startTime.year,
            appointment.startTime.month, appointment.startTime.day, 0, 0);
        found.endTime = DateTime(appointment.endTime.year,
            appointment.endTime.month, appointment.endTime.day, 1, 0);
      }
      found.resourceIds = [toUser];
      if (isUserView) {
        found.id = (found.id as AppointmentIdMd).copyWith(user: toUser);
      } else {
        found.id = (found.id as AppointmentIdMd).copyWith(location: toUser);
      }
      next(UpdateScheduleState());
    }
  }

  void _onFetchShifts(
      AppState state, SCFetchShiftsAction action, NextDispatcher next) async {
    final locId = action.locationId ?? 0;
    final userId = action.userId ?? 0;
    final shiftId = action.shiftId ?? 0;
    final date = action.date;
    final stateVal = state.scheduleState.shifts;

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
      final locs = <LocationItemMd>[
        ...(state.generalState.locationItems.data ?? [])
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
          location: loc,
        );
        appointments.add(Appointment(
          startTime: st,
          endTime: et ?? DateTime.now(),
          isAllDay: et == null,
          color: Colors.white,
          subject: pr.title ?? "-",
          id: id,
          resourceIds: [us],
        ));
      }
      // for (int i = 0; i < appointments.length; i++) {
      //   final prev = appointments[i];
      //   for (int j = 0; j < appointments.length; j++) {
      //     final next = appointments[j];
      //     if (prev.resourceIds!.contains(next.resourceIds)) {
      //       prev.resourceIds = [...prev.resourceIds!, ...next.resourceIds!];
      //     }
      //   }
      // }
      stateVal.error.isLoading = false;
      stateVal.data?[CalendarView.day] = appointments;
      stateVal.error.action = action;
      stateVal.error.isError = false;

      next(UpdateScheduleState(
        shifts: stateVal,
        backupShifts: appointments,
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
    stateVal.data?[CalendarView.week] = [];

    stateVal.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateVal));
    final appointmentsWeek = <Appointment>[];

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final date = startDate.add(Duration(days: i));
      final ApiResponse res = await restClient()
          .getShifts(
              locId, userId, shiftId, DateFormat('yyyy-MM-dd').format(date))
          .nocodeErrorHandler();
      if (res.success) {
        final list = <ShiftMd>[];
        final properties = <PropertiesMd>[
          ...(state.generalState.properties.data ?? <PropertiesMd>[])
        ];
        final users = <UserRes>[...(state.usersState.usersList.data ?? [])];
        final locs = <LocationItemMd>[
          ...(state.generalState.locationItems.data ?? [])
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
          final AppointmentIdMd id = AppointmentIdMd(
            user: us,
            allocation: shift,
            property: pr,
            location: loc,
          );

          final stWeek = DateTime(date.year, date.month, date.day, 00, 00);
          DateTime? etWeek = DateTime(date.year, date.month, date.day, 01, 00);

          appointmentsWeek.add(Appointment(
            startTime: stWeek,
            endTime: etWeek,
            color: Colors.white,
            subject: pr.title ?? "-",
            id: id,
            resourceIds: [us, loc],
          ));
        }
      }
    }
    stateVal.error.isLoading = false;
    stateVal.data?[CalendarView.week] = [
      ...(stateVal.data?[CalendarView.week] ?? []),
      ...appointmentsWeek
    ];
    stateVal.error.action = action;
    stateVal.error.isError = false;
    next(UpdateScheduleState(
        shifts: stateVal, backupShiftsWeek: appointmentsWeek));
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
          users.add(CalendarResource(id: filter[i]));
          users.sort((a, b) => (a.id as UserRes)
              .firstName
              .compareTo((b.id as UserRes).firstName));
        }
      } else {
        users.clear();

        users.addAll((appStore.state.usersState.usersList.data ?? [])
            .map((e) => CalendarResource(id: e)));
      }
      next(UpdateScheduleState(filteredUsers: filter, userResources: users));
    } else if (loc != null) {
      if (loc.name == "All") {
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
          locs.add(CalendarResource(id: filterLocs[i]));
          locs.sort((a, b) => (a.id as LocationItemMd)
              .name!
              .compareTo((b.id as LocationItemMd).name!));
        }
      } else {
        locs.clear();

        locs.addAll((appStore.state.generalState.locationItems.data ?? [])
            .map((e) => CalendarResource(id: e)));
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
    next(UpdateScheduleState(
      calendarView: view,
      sidebarType: sidebarType,
      interval: interval,
    ));
  }

  void _onChangeSidebarType(
      AppState state, SCChangeSidebarType action, NextDispatcher next) async {
    SidebarType sidebarType = state.scheduleState.sidebarType;
    if (sidebarType == SidebarType.user) {
      sidebarType = SidebarType.location;
      appStore.dispatch(SCAddFilter(location: LocationItemMd.all()));
    } else {
      sidebarType = SidebarType.user;
      appStore.dispatch(SCAddFilter(user: UserRes.all()));
    }
    next(UpdateScheduleState(
      sidebarType: sidebarType,
    ));
  }
}
