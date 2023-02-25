import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../model_exporter.dart';

@immutable
class ScheduleState {
  final int interval;
  final List<Appointment> shifts;
  final List<CalendarResource> users;
  final CalendarView calendarView;
  ScheduleState({
    required this.interval,
    required this.shifts,
    required this.users,
    required this.calendarView,
  });

  factory ScheduleState.initial() {
    return ScheduleState(
      calendarView: CalendarView.timelineDay,
      interval: 30,
      shifts: [
        Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          subject: "Test",
          color: Colors.blueAccent,
          resourceIds: ["1"],
        ),
        Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          subject: "Test2",
          color: Colors.green,
          resourceIds: ["1"],
        ),
        Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          subject: "Test3",
          color: Colors.green,
          resourceIds: ["1"],
        ),
      ],
      users: [
        CalendarResource(
          displayName: "User 1",
          id: "1",
          color: Colors.red,
        ),
        CalendarResource(
          displayName: "User 2",
          id: "2",
        ),
        CalendarResource(
          displayName: "User 3",
          id: "3",
        ),
        CalendarResource(
          displayName: "User 4",
          id: "4",
        ),
        CalendarResource(
          displayName: "User 5",
          id: "5",
        ),
        CalendarResource(
          displayName: "User 6",
          id: "6",
        ),
        CalendarResource(
          displayName: "User 7",
          id: "7",
        ),
        CalendarResource(
          displayName: "User 8",
          id: "8",
        ),
        CalendarResource(
          displayName: "User 9",
          id: "9",
        ),
        CalendarResource(
          displayName: "User 10",
          id: "10",
        ),
        CalendarResource(
          displayName: "User 11",
          id: "11",
        ),
        CalendarResource(
          displayName: "User 12",
          id: "12",
        ),
        CalendarResource(
          displayName: "User 13",
          id: "13",
        ),
        CalendarResource(
          displayName: "User 14",
          id: "14",
        ),
        CalendarResource(
          displayName: "User 15",
          id: "15",
        ),
        CalendarResource(
          displayName: "User 16",
          id: "16",
        ),
        CalendarResource(
          displayName: "User 17",
          id: "17",
        ),
        CalendarResource(
          displayName: "User 18",
          id: "18",
        ),
        CalendarResource(
          displayName: "User 19",
          id: "19",
        ),
        CalendarResource(
          displayName: "User 20",
          id: "20",
        ),
      ],
    );
  }

  ScheduleState copyWith({
    CalendarView? calendarView,
    int? interval,
    List<Appointment>? shifts,
    List<CalendarResource>? users,
  }) {
    return ScheduleState(
      calendarView: calendarView ?? this.calendarView,
      users: users ?? this.users,
      shifts: shifts ?? this.shifts,
      interval: interval ?? this.interval,
    );
  }
}

class UpdateScheduleState {
  final CalendarView? calendarView;
  final int? interval;
  final List<Appointment>? shifts;
  final List<CalendarResource>? users;
  UpdateScheduleState({
    this.calendarView,
    this.interval,
    this.shifts,
    this.users,
  });
}

class SCDragEndAction {
  AppointmentDragEndDetails details;
  SCDragEndAction(this.details);
}
