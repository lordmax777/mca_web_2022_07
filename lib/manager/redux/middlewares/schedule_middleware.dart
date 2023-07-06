import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../pages/scheduling/models/allocation_model.dart';
import '../../../pages/scheduling/table_views/full_calendar.dart';
import '../../../theme/theme.dart';
import '../../models/list_all_md.dart';
import '../../models/property_md.dart';
import '../../models/users_list.dart';
import '../../rest/rest_client.dart';
import '../states/general_state.dart';
import 'dart:math';

class ScheduleMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      // case SCDragEndAction:
      //   return _onDragEnd(store.state.scheduleState, action, next);
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
      case SCRemoveAllocationAction:
        return _onRemoveAllocation(store.state, action, next);
      case SCCopyAllAllocationAction:
        return _onCopyAllAllocation(store.state, action, next);
      case SCShiftGuestAction:
        return _onGuestAction(store.state, action, next);
      case SCOnCopyAllocationTap:
        return _onCopyAllocationTap(store.state, action, next);
      default:
        return next(action);
    }
  }

  Future<List<Appointment>> _onFetchShifts(
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

    final appointments = <Appointment>[];
    if (res.success) {
      StateValue<List<PropertiesMd>> newProperties =
          await appStore.dispatch(GetPropertiesAction());
      StateValue<ListAllMd> allList =
          await appStore.dispatch(GetAllParamListAction());
      final list = <AllocationModel>[];
      for (var item in res.data['allocations']) {
        final AllocationModel shift = AllocationModel.fromJson(item,
            shifts: allList.data!.shifts, users: state.usersState.users);
        list.add(shift);
        final pr = shift.shift.propertyFromNewState(newProperties.data!);
        final us = shift.user;

        final stDate = DateTime(date.year, date.month, date.day,
            pr.startTimeAsTimeOfDay.hour, pr.startTimeAsTimeOfDay.minute);

        DateTime et = DateTime(date.year, date.month, date.day,
            pr.finishTimeAsTimeOfDay.hour, pr.finishTimeAsTimeOfDay.minute);

        appointments.add(Appointment(
          startTime: stDate,
          endTime: et,
          isAllDay: false,
          color: us?.userRandomBgColor ?? Colors.lime[300]!,
          subject: pr.title,
          id: shift,
          resourceIds: [
            us ?? UserRes.openShiftResource(),
          ],
        ));
      }

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

    return appointments;
  }

  Future<List<Appointment>> _onFetchShiftsWeek(AppState state,
      SCFetchShiftsWeekAction action, NextDispatcher next) async {
    final locId = action.locationId ?? 0;
    final userId = action.userId ?? 0;
    final shiftId = action.shiftId ?? 0;
    final date = action.startDate;
    final endDate = action.endDate;
    final stateVal = state.scheduleState.shifts;

    stateVal.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateVal));

    final ApiResponse res = await restClient()
        .getShifts(
          locId,
          userId,
          shiftId,
          DateFormat('yyyy-MM-dd').format(date),
          until: DateFormat('yyyy-MM-dd').format(endDate),
        )
        .nocodeErrorHandler();

    final appointments = <Appointment>[];

    if (res.success) {
      StateValue<List<PropertiesMd>> newProperties = action.fetchAdditionalData
          ? await appStore.dispatch(GetPropertiesAction())
          : state.generalState.properties;
      StateValue<ListAllMd> allList = action.fetchAdditionalData
          ? await appStore.dispatch(GetAllParamListAction())
          : state.generalState.paramList;
      final list = <AllocationModel>[];
      for (var item in res.data['allocations']) {
        final AllocationModel shift = AllocationModel.fromJson(item,
            shifts: allList.data!.shifts, users: state.usersState.users);
        list.add(shift);
        final pr = shift.shift.propertyFromNewState(newProperties.data!);
        final us = shift.user;
        final DateTime date = DateTime.parse(item.date);
        final formatter = DateFormat('HH:mm');

        // final stDate = DateTime(date.year, date.month, date.day, 00, 00);
        // DateTime et = DateTime(date.year, date.month, date.day, 01, 00);
        final stDate = DateTime(date.year, date.month, date.day,
            pr.startTimeAsTimeOfDay.hour, pr.startTimeAsTimeOfDay.minute);
        DateTime et = DateTime(date.year, date.month, date.day,
            pr.finishTimeAsTimeOfDay.hour, pr.finishTimeAsTimeOfDay.minute);

        bool isAllDay = false;
        if (pr.startTimeAsTimeOfDay.hour == 0 &&
            pr.startTimeAsTimeOfDay.minute == 0 &&
            pr.finishTimeAsTimeOfDay.hour == 23 &&
            pr.finishTimeAsTimeOfDay.minute == 59) {
          isAllDay = true;
        }

        bool isOpenShift = false;
        if (us == null) {
          isOpenShift = true;
        }
        StringBuffer subject = StringBuffer();

        if (isOpenShift) {
          subject.write('(Open Shift) ');
        }
        if (isAllDay) {
          subject.write("All Day / ");
        } else {
          subject.write("${formatter.format(stDate)} - ");
          subject.write("${formatter.format(et)} / ");
        }
        subject.write("${pr.title} - ");
        subject.write(pr.locationName);
        if (kDebugMode) {
          subject.write(" /// ");
          subject.write(" Shift - ");
          subject.write(pr.id);
          subject.write(" Location - ");
          subject.write(pr.locationId);
          // subject.write(" User - ");
          // subject.write(us?.id);
        }
        appointments.add(Appointment(
          startTime: stDate,
          endTime: et,
          isAllDay: isAllDay,
          color: shift.shift.randomBgColor,
          subject: subject.toString(),
          id: shift,
          resourceIds: [
            isOpenShift ? "OPEN" : "",
            if (us != null) "US_${us.id}",
            "PR_${pr.id}",
            // pr,
          ],
        ));
      }

      stateVal.error.isLoading = false;
      stateVal.data?[CalendarView.week] = appointments;
      stateVal.error.action = action;
      stateVal.error.isError = false;

      next(UpdateScheduleState(
        shifts: stateVal,
        backupShiftsWeek: appointments,
      ));
    } else {
      throw ShiftFetchException(apiResponse: res);
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

    return appointments;
  }

  void _onFetchShiftsMonth(AppState state, SCFetchShiftsMonthAction action,
      NextDispatcher next) async {
    final locId = action.locationId ?? 0;
    final userId = action.userId ?? 0;
    final shiftId = action.shiftId ?? 0;
    final date = action.startDate;
    final endDate = DateTime(date.year, date.month + 1, 0);
    final stateVal = state.scheduleState.shifts;

    stateVal.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateVal));

    final ApiResponse res = await restClient()
        .getShifts(
          locId,
          userId,
          shiftId,
          DateFormat('yyyy-MM-dd').format(date),
          until: DateFormat('yyyy-MM-dd').format(endDate),
        )
        .nocodeErrorHandler();

    if (res.success) {
      StateValue<List<PropertiesMd>> newProperties =
          await appStore.dispatch(GetPropertiesAction());
      StateValue<ListAllMd> allList =
          await appStore.dispatch(GetAllParamListAction());
      final list = <AllocationModel>[];
      final appointments = <Appointment>[];
      for (var item in res.data['allocations']) {
        final AllocationModel shift = AllocationModel.fromJson(item,
            shifts: allList.data!.shifts, users: state.usersState.users);
        list.add(shift);
        final pr = shift.shift.propertyFromNewState(newProperties.data!);
        final us = shift.user;
        final DateTime date = DateTime.parse(shift.date);

        final stDate = DateTime(date.year, date.month, date.day, 00, 00);
        DateTime et = DateTime(date.year, date.month, date.day, 01, 00);

        appointments.add(Appointment(
          startTime: stDate,
          endTime: et,
          isAllDay: false,
          color: us?.userRandomBgColor ?? Colors.lime[300]!,
          subject: pr.title,
          id: shift,
          resourceIds: [
            us ?? UserRes.openShiftResource(),
            pr,
          ],
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
    if (view == CalendarView.day) {
      sidebarType = SidebarType.user;
    }
    appStore.dispatch(SCAddFilter(location: PropertiesMd.all()));
    appStore.dispatch(SCAddFilter(user: UserRes.all()));
    next(UpdateScheduleState(
      calendarView: view,
      sidebarType: sidebarType,
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
    String date = action.allocation.date;
    final stateValue = state.scheduleState.shifts;
    stateValue.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateValue));
    //To copy all shifts, use action.isAll and shiftId must be 0
    //To copy single shift, use !action.isAll and shiftId must be the id of the shift
    final ApiResponse res = await restClient()
        .postShifts(
          0,
          allocation.user?.id ?? 0,
          allocation.shift.id,
          date,
          AllocationActions.copy.name,
          date_until: date,
          target_shift: action.targetShiftId,
          target_user: action.targetUserId,
          target_date: target(),
        )
        .nocodeErrorHandler();
    stateValue.error.isLoading = false;
    next(UpdateScheduleState(shifts: stateValue));
    if (!res.success) {
      showError(HtmlHelper.replaceBr(res.data), titleMsg: "Error");
    } else {
      await appStore.dispatch(action.fetchAction);
      showError("Shift copied successfully", titleMsg: "Success");
    }
  }

  void _onCopyAllAllocation(AppState state, SCCopyAllAllocationAction action,
      NextDispatcher next) async {
    final bool isUserView = state.scheduleState.isUserView;
    final allocation = action.allocation;
    String target() => DateFormat('yyyy-MM-dd').format(action.targetDate);
    String date = action.allocation.date;

    final stateValue = state.scheduleState.shifts;
    stateValue.error.isLoading = true;
    next(UpdateScheduleState(shifts: stateValue));
    //To copy all shifts, use action.isAll and shiftId must be 0
    //To copy single shift, use !action.isAll and shiftId must be the id of the shift
    final ApiResponse res = await restClient()
        .postShifts(
          0,
          isUserView ? (allocation.user?.id ?? 0) : 0,
          !isUserView ? allocation.shift.id : 0,
          date,
          AllocationActions.copy.name,
          date_until: date,
          target_shift: action.targetShiftId,
          target_user: action.targetUserId,
          target_date: target(),
        )
        .nocodeErrorHandler();
    stateValue.error.isLoading = false;
    next(UpdateScheduleState(shifts: stateValue));
    if (!res.success) {
      showError(HtmlHelper.replaceBr(res.data), titleMsg: "Error");
    } else {
      await appStore.dispatch(action.fetchAction);
      showError("Shifts copied successfully", titleMsg: "Success");
    }
  }

  Future<ApiResponse?> _onRemoveAllocation(AppState state,
      SCRemoveAllocationAction action, NextDispatcher next) async {
    final allocation = action.allocation;
    String date = action.allocation.date;
    final ApiResponse res = await restClient()
        .postShifts(
          allocation.shift.location_id,
          allocation.user?.id ?? 0,
          allocation.shift.id,
          date,
          AllocationActions.remove.name,
        )
        .nocodeErrorHandler();
    return res;
  }

  Future<Map<String, dynamic>> _onGuestAction(
      AppState state, SCShiftGuestAction action, NextDispatcher next) async {
    try {
      final ApiResponse res = await restClient()
          .postShifts(
            action.locationId,
            0,
            action.shiftId,
            action.date.formatDateForApi,
            action.action.name,
          )
          .nocodeErrorHandler();
      if (res.success) {
        //return
        // {
        //     "minimum": 1,
        //     "maximum": 1,
        //     "current": {
        //         "20230517": 0
        //     }
        // }
        return res.data;
      } else {
        throw ShiftUpdateException(apiResponse: res, message: "");
      }
    } catch (e) {
      throw ShiftUpdateException(message: "Something went wrong!");
    }
  }

  void _onCopyAllocationTap(
      AppState state, SCOnCopyAllocationTap action, NextDispatcher next) async {
    final calendarTapDetails = action.calendarTapDetails;

    var resource = (calendarTapDetails.resource?.id);

    int? userId;
    int? shiftId;

    if (resource is UserRes) {
      userId = resource.id;
    } else if (resource is PropertiesMd) {
      shiftId = resource.id;
    }

    if (shiftId == null && userId == null) {
      return;
    }

    final DateTime date = calendarTapDetails.date!;
    bool isAll = false;
    final selectedAppointment = action.selectedAppointment;
    if (selectedAppointment.isEmpty) {
      return;
    }
    AllocationModel? ap = selectedAppointment['copy'];
    if (ap == null) {
      ap = selectedAppointment['copyAll'];
      isAll = true;
    }
    if (ap == null) {
      return;
    }
    if (date.isBefore(ap.dateAsDateTime)) {
      showError("Cannot copy to a date before the current date");
      return;
    }

    bool? canCopy = false;
    canCopy = await showDialog<bool>(
      context: action.context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Copy"),
          content: Text(
              "Are you sure you want to copy to ${DateFormat('dd MMM yyyy').format(date)}?"),
          actions: [
            TextButton(
              onPressed: () {
                return Get.back(result: false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                return Get.back(result: true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    canCopy ??= false;
    if (canCopy) {
      logger("$isAll", hint: "isAll");
      if (isAll) {
        appStore.dispatch(SCCopyAllAllocationAction(
          fetchAction: action.fetchShiftsWeekAction,
          allocation: ap,
          targetUserId: userId,
          targetShiftId: shiftId,
          targetDate: date,
        ));
      } else {
        appStore.dispatch(SCCopyAllocationAction(
          fetchAction: action.fetchShiftsWeekAction,
          allocation: ap,
          targetUserId: userId,
          targetShiftId: shiftId,
          targetDate: date,
        ));
      }
    }
  }
}
