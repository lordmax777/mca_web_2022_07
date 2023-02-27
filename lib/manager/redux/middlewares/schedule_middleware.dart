import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/models/auth.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../app.dart';
import '../../../theme/theme.dart';
import '../../hive.dart';
import '../../models/location_item_md.dart';
import '../../models/property_md.dart';
import '../../models/shift_md.dart';
import '../../models/users_list.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../../talker_controller.dart';
import '../sets/state_value.dart';
import '../states/auth_state.dart';

class ScheduleMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case SCDragEndAction:
        return _onDragEnd(store.state.scheduleState, action, next);
      case SCFetchShiftsAction:
        return _onFetchShifts(store.state, action, next);
      case SCAddFilterUser:
        return _onAddFilterUser(store.state, action, next);
      default:
        return next(action);
    }
  }

  void _onDragEnd(
      ScheduleState state, SCDragEndAction action, NextDispatcher next) {
    final appointmentDragEndDetails = action.details;
    final appointments = state.shifts;
    final interval = state.interval;

    final appointment = appointmentDragEndDetails.appointment as Appointment;
    if (appointment.startTime.minute % interval != 0) {
      final found = appointments.firstWhereOrNull((element) =>
          element.id ==
          (appointmentDragEndDetails.appointment as Appointment).id);
      if (found == null) return;
      found.startTime = appointment.startTime
          .subtract(Duration(minutes: appointment.startTime.minute % interval));
      found.endTime = appointment.endTime
          .subtract(Duration(minutes: appointment.endTime.minute % interval));
      next(UpdateScheduleState());
    }
  }

  void _onFetchShifts(
      AppState state, SCFetchShiftsAction action, NextDispatcher next) async {
    final locId = action.locationId ?? 0;
    final userId = action.userId ?? 0;
    final shiftId = action.shiftId ?? 0;
    final date = action.date;

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
        final AppointmentIdMd id = AppointmentIdMd(
          user: us,
          allocation: shift,
          property: pr,
          location: loc,
        );

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

      next(UpdateScheduleState(
          fetchedShifts: list,
          shifts: appointments,
          backupShifts: appointments));
    } else {
      next(UpdateScheduleState(fetchedShifts: [], shifts: []));
    }
  }

  void _onAddFilterUser(
      AppState state, SCAddFilterUser action, NextDispatcher next) async {
    final user = action.user;
    final filter = state.scheduleState.filteredUsers;
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
    final users = state.scheduleState.users;
    final shifts = state.scheduleState.shifts;
    if (filter.isNotEmpty) {
      users.clear();
      for (int i = 0; i < filter.length; i++) {
        users.add(CalendarResource(id: filter[i]));
        users.sort((a, b) =>
            (a.id as UserRes).firstName.compareTo((b.id as UserRes).firstName));
        shifts.removeWhere((element) =>
            (element.id as AppointmentIdMd).user.id != filter[i].id);
      }
    } else {
      users.clear();
      shifts.clear();
      users.addAll((appStore.state.usersState.usersList.data ?? [])
          .map((e) => CalendarResource(id: e)));
      shifts.addAll(state.scheduleState.backupShifts);
    }
    next(UpdateScheduleState(
        filteredUsers: filter, users: users, shifts: shifts));
  }
}
