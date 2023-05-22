import 'dart:ui';

import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../utils/helpers.dart';

class AppointmentDataSource extends CalendarDataSource {
  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate,
      [bool? fetchAdditionalData]) async {
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
        if (!appointments.any((element) => element.id == appointment.id)) {
          if (appointments.indexOf(appointment) == 0) {
            appointment.isAllDay = true;
          }
          _meetings.add(appointment);
        }
      }
      _addNewAppointments(_meetings);
    } on ShiftFetchException catch (e) {
      notifyListeners(CalendarDataSourceAction.add, []);

      if (e.apiResponse.resCode != 404) {
        showError(ApiHelpers.getRawDataErrorMessages(e.apiResponse));
      }

      Logger.e("Error while fetching shifts", tag: 'ShiftsCalendar');
    } on StateError catch (e) {
      notifyListeners(CalendarDataSourceAction.add, []);
      showError("Something went wrong $e");
      Logger.e("Something went wrong while fetching shifts ${e.stackTrace}",
          tag: 'ShiftsCalendar - StateError');
    } catch (e) {
      notifyListeners(CalendarDataSourceAction.add, []);

      showError("Something went wrong $e");

      Logger.e("Something went wrong while fetching shifts $e",
          tag: 'ShiftsCalendar - catch');
    }
  }

  void _addNewAppointments(List<Appointment> _appointments) {
    appointments.addAll(_appointments);
    notifyListeners(CalendarDataSourceAction.add, _appointments);
  }

  void clearAppointments() {
    appointments.clear();
    notifyListeners(CalendarDataSourceAction.reset, appointments);
  }

  AppointmentDataSource(this.source, {this.onRangeChanged});

  List<Appointment> source;

  void Function(DateTime, DateTime)? onRangeChanged;

  @override
  List<dynamic> get appointments => source;

  @override
  set resources(List<CalendarResource>? _resources) {
    super.resources = _resources;
  }
}

class ShiftFetchException implements Exception {
  ShiftFetchException({required this.apiResponse});

  final ApiResponse apiResponse;

  @override
  String toString() => apiResponse.toString();
}
