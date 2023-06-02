import 'dart:ui';

import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/manager/mca_loading.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../manager/rest/nocode_helpers.dart';

class AppointmentDataSource extends CalendarDataSource {
  @override
  Future<List<Appointment>> handleLoadMore(DateTime startDate, DateTime endDate,
      [bool? fetchAdditionalData]) async {
    Future<List<Appointment>> fetch() async {
      try {
        onRangeChanged?.call(startDate, endDate);
        final view = appStore.state.scheduleState.calendarView;
        final bool isMonth = view == CalendarView.month;
        final bool isWeek = view == CalendarView.timelineWeek;
        final List<Appointment> _meetings = <Appointment>[];
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

        List<Appointment> fetchedAppointments = await appStore.dispatch(
            SCFetchShiftsWeekAction(
                startDate: st,
                endDate: et,
                fetchAdditionalData: fetchAdditionalData ?? false));

        for (final Appointment appointment in fetchedAppointments) {
          final DateTime date = appointment.startTime;

          if (isWeek) {
            appointment.isAllDay = true;
          }
          if (appointment.isAllDay) {
            final stDate = DateTime(date.year, date.month, date.day, 00, 00);
            final DateTime etDate =
                DateTime(date.year, date.month, date.day, 01, 00);
            appointment.startTime = stDate;
            appointment.endTime = etDate;
          }
          if (!appointments.any((element) =>
              (element.id as AllocationModel).id ==
              (appointment.id as AllocationModel).id)) {
            if (appointments.indexOf(appointment) == 0) {
              appointment.isAllDay = true;
            }
            _meetings.add(appointment);
          }
        }
        setResourcesWithAppointmentOnly(
            getResourcesWithAppointment(fetchedAppointments));
        logger(
            "Loaded new appointments ${fetchedAppointments.length}"
                .toUpperCase(),
            hint: "DataSource._handleLoadMore".toUpperCase());
        _addNewAppointments(_meetings);
        return _meetings;
      } on ShiftFetchException catch (e) {
        notifyListeners(CalendarDataSourceAction.add, []);

        if (e.apiResponse.resCode != 404) {
          showError(ApiHelpers.getRawDataErrorMessages(e.apiResponse));
        }

        Logger.e("Error while fetching shifts", tag: 'ShiftsCalendar');
        return [];
      } on StateError catch (e) {
        notifyListeners(CalendarDataSourceAction.add, []);
        showError("Something went wrong $e");
        Logger.e("Something went wrong while fetching shifts ${e.stackTrace}",
            tag: 'ShiftsCalendar - StateError');
        return [];
      } catch (e) {
        notifyListeners(CalendarDataSourceAction.add, []);

        showError("Something went wrong $e");

        Logger.e("Something went wrong while fetching shifts $e",
            tag: 'ShiftsCalendar - catch');
        return [];
      }
    }

    return await McaLoading.futureLoading<List<Appointment>>(() async {
      final list = await fetch();
      return list;
    });
  }

  AppointmentDataSource(this.source,
      {this.onRangeChanged, required this.setResourcesWithAppointmentOnly});

  List<Appointment> source;

  void Function(DateTime, DateTime)? onRangeChanged;

  void Function(List<String> r) setResourcesWithAppointmentOnly;

  @override
  List<dynamic> get appointments => source;

  @override
  set resources(List<CalendarResource>? r) {
    super.resources = r;
  }

  void _addNewAppointments(List<Appointment> _appointments) {
    appointments.addAll(_appointments);
    notifyListeners(CalendarDataSourceAction.add, _appointments);
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
      return await handleLoadMore(startTime, endTime, fetchAdditionalData);
    }
    return [];
  }

  List<String> getResourcesWithAppointment(
      List<Appointment> loadedNewAppointments) {
    //find the resources which have no appointments
    final List<Appointment> apps = [...loadedNewAppointments];
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

class ShiftFetchException implements Exception {
  ShiftFetchException({required this.apiResponse});

  final ApiResponse apiResponse;

  @override
  String toString() => apiResponse.toString();
}

class ShiftUpdateException {
  final ApiResponse? apiResponse;
  final String message;

  ShiftUpdateException({this.apiResponse, required this.message});
}
