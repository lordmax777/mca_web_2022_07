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
      ],
      users: [
        CalendarResource(
          displayName: "User 1",
          id: "1",
          color: Colors.red,
          image: NetworkImage(
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659651_960_720.png"),
        ),
        CalendarResource(
          displayName: "User 2",
          id: "2",
          image: NetworkImage(
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659651_960_720.png"),
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
