import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mca_dashboard/presentation/pages/pages.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_helper.dart';
import 'package:retrofit/retrofit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../../manager/manager.dart';

class AppointmentDataSource extends CalendarDataSource {
  final DependencyManager _dependencyManager = DependencyManager();

  late DateTime _startDate;
  late DateTime _endDate;

  @override
  Future<List<Appointment>> handleLoadMore(
      DateTime startDate, DateTime endDate) async {
    _startDate = startDate;
    _endDate = endDate;
    Future<List<Appointment>> fetch() async {
      try {
        final view = ScheduleState().calendarView.value;
        final bool isMonth = view == CalendarView.month;
        final bool isWeek = view == CalendarView.timelineWeek;

        List<Appointment> meetings = [];

        DateTime st = startDate;
        DateTime et = endDate;

        if (isMonth) {
          if (st.day != 1) {
            // st must be next month of startDate
            st = DateTime(st.year, st.month + 1, 1, 00, 00);
          }
          // st must be equal to start of month
          // et must be equal to end of month
          st = st.startOfMonth;
          et = st.endOfMonth;
        }

        final fetchedAppointments = await dispatch<List<Appointment>>(
            GetAppointmentAction(startDate: st, endDate: et));

        if (fetchedAppointments.isLeft) {
          lastFetchedAppointments
            ..clear()
            ..addAll(fetchedAppointments.left);

          Future<List<Appointment>> useIsolate() async {
            try {
              final res = await compute<List, List<Appointment>>(
                  heavyLoad, [fetchedAppointments.left, appointments, isWeek]);
              return res;
            } catch (e) {
              Logger.e(e.toString(), tag: "useIsolate");
              return [];
            }
          }

          meetings = await useIsolate();
          _addNewAppointments(meetings);
          handleShowEmptySlots(ScheduleState().showEmptySlots.value);
        } else {
          lastFetchedAppointments.clear();
          print(fetchedAppointments.right.toString());
          if (fetchedAppointments.right.code != 404) {
            _dependencyManager.navigation
                .showFail(fetchedAppointments.right.message);
          }
          notifyListeners(CalendarDataSourceAction.add, []);
        }
        return meetings;
      } on TypeError catch (e) {
        lastFetchedAppointments.clear();
        notifyListeners(CalendarDataSourceAction.add, []);

        _dependencyManager.navigation.showFail("Something went wrong $e");

        Logger.e("Something went wrong while fetching shifts ${e.stackTrace}",
            tag: 'ShiftsCalendar - catch 1');
        return [];
      } on RangeError catch (e) {
        lastFetchedAppointments.clear();
        notifyListeners(CalendarDataSourceAction.add, []);
        Logger.e("Something went wrong while fetching shifts ${e.stackTrace}",
            tag: 'ShiftsCalendar - catch 3');
        return [];
      } on ConcurrentModificationError catch (e) {
        lastFetchedAppointments.clear();
        notifyListeners(CalendarDataSourceAction.add, []);
        Logger.e("Something went wrong while fetching shifts ${e.stackTrace}",
            tag: 'ShiftsCalendar - catch 4');
        return [];
      } catch (e) {
        lastFetchedAppointments.clear();
        notifyListeners(CalendarDataSourceAction.add, []);

        _dependencyManager.navigation.showFail("Something went wrong $e");

        Logger.e("Something went wrong while fetching shifts ${e.runtimeType}",
            tag: 'ShiftsCalendar - catch 2');
        print(e.runtimeType);
        return [];
      }
    }
    // notifyListeners(CalendarDataSourceAction.add, []);
    //
    // _dependencyManager.navigation.showFail("Something went wrong $e");
    //
    // Logger.e("Something went wrong while fetching shifts ${e.runtimeType}",
    //     tag: 'ShiftsCalendar - catch');
    // return [];

    return await _dependencyManager.navigation
        .futureLoading<List<Appointment>>(() async {
      final list = await fetch();
      return list;
    });
  }

  Future<void> clearAndReloadMore() async {
    clearAppointments();
    await handleLoadMore(_startDate, _endDate);
  }

  Future<void> loadMore() async {
    await handleLoadMore(_startDate, _endDate);
  }

  AppointmentDataSource(this.source, this.handleShowEmptySlots);

  final List<Appointment> source;
  final ValueChanged<bool> handleShowEmptySlots;
  final List<Appointment> lastFetchedAppointments = [];

  @override
  List<dynamic> get appointments => source;

  @override
  set resources(List<CalendarResource>? r) {
    super.resources = r;
  }

  void _addNewAppointments(List<Appointment> apps) {
    appointments.addAll(apps);
    notifyListeners(CalendarDataSourceAction.add, apps);
  }

  void addAppointment(Appointment? appointment) {
    if (appointment == null) return;
    appointments.add(appointment);
    notifyListeners(CalendarDataSourceAction.add, [appointment]);
  }

  void removeAppointment(Appointment? appointment) {
    if (appointment == null) return;
    appointments.remove(appointment);
    notifyListeners(CalendarDataSourceAction.remove, [appointment]);
  }

  void clearAppointments() {
    appointments.clear();
    notifyListeners(CalendarDataSourceAction.reset, appointments);
  }

  Future<List<Appointment>> clearAppointmentAndReloadMore(
      DateTime? startTime, DateTime? endTime,
      [bool? fetchAdditionalData]) async {
    if (startTime != null && endTime != null) {
      clearAppointments();
      return await handleLoadMore(startTime, endTime);
    }
    return [];
  }

  List<String> getResourcesWithAppointment() {
    //find the resources which have no appointments
    final List<Appointment> apps = [...lastFetchedAppointments];
    final List<String> availableResourceIds = <String>[];
    for (final Appointment app in apps) {
      final rs =
          (app.resourceIds ?? []).map<String>((e) => e.toString()).toList();
      for (final String resourceId in rs) {
        if (!availableResourceIds.contains(resourceId)) {
          if (resourceId.isNotEmpty) {
            availableResourceIds.add(resourceId);
          }
        }
      }
    }
    return availableResourceIds;
  }
}

List<Appointment> heavyLoad(List<dynamic> args) {
  final List<Appointment> meetings = [];
  for (final Appointment appointment in args[0]) {
    final DateTime date = appointment.startTime;

    if (args[2]) {
      appointment.isAllDay = true;
    }
    if (appointment.isAllDay) {
      final stDate = DateTime(date.year, date.month, date.day, 00, 00);
      final DateTime etDate = DateTime(date.year, date.month, date.day, 01, 00);
      appointment.startTime = stDate;
      appointment.endTime = etDate;
    }
    if (!args[1].any((element) => element.id == appointment.id)) {
      if (args[1].indexOf(appointment) == 0) {
        appointment.isAllDay = true;
      }
      meetings.add(appointment);
    }
  }

  return meetings;
}

class ShiftFetchException implements Exception {
  ShiftFetchException({required this.apiResponse});

  final HttpResponse apiResponse;

  @override
  String toString() => apiResponse.toString();
}

class ShiftUpdateException {
  final HttpResponse? apiResponse;
  final String message;

  ShiftUpdateException({this.apiResponse, required this.message});
}
