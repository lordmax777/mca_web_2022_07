import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/models/users_list.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';
import '../models/job_model.dart';
import '../scheduling_page.dart';

class FullCalendar extends StatefulWidget {
  final DateTime day;

  const FullCalendar({Key? key, required this.day}) : super(key: key);

  @override
  State<FullCalendar> createState() => _FullCalendarState();
}

class _FullCalendarState extends State<FullCalendar> {
  final List<CalendarView> _allowedViews = [
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineMonth,
  ];

  final GlobalKey _globalKey = GlobalKey();

  final CalendarController _calendarController = CalendarController();
  CalendarView _view = CalendarView.timelineDay;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _calendarController.view = _view;
    _addAppointmentDetails();
    super.initState();
  }

  final AppointmentDataSource _events = AppointmentDataSource(<Appointment>[]);

  /// Creates the required appointment details as a list.
  void _addAppointmentDetails() {
    final List<String> subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');
    subjectCollection.add('Development Meeting');
    subjectCollection.add('Scrum');
    subjectCollection.add('Project Completion');
    subjectCollection.add('Release updates');
    subjectCollection.add('Performance Check');

    final List<Color> colorCollection = <Color>[];
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF0A8043));

    final Random random = Random();
    _dataCollection = <DateTime, List<Appointment>>{};
    final DateTime today = DateTime.now();
    final DateTime rangeStartDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: -1000));
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1000));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(Duration(days: 1 + random.nextInt(2)))) {
      final DateTime date = i;
      final int count = 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate =
            DateTime(date.year, date.month, date.day, 8 + random.nextInt(8));
        final int duration = random.nextInt(3);
        final Appointment meeting = Appointment(
          subject: subjectCollection[random.nextInt(7)],
          startTime: startDate,
          endTime: startDate.add(Duration(hours: duration == 0 ? 1 : duration)),
          color: colorCollection[random.nextInt(9)],
        );

        if (_dataCollection.containsKey(date)) {
          final List<Appointment> meetings = _dataCollection[date]!;
          meetings.add(meeting);
          _dataCollection[date] = meetings;
        } else {
          _dataCollection[date] = <Appointment>[meeting];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(
        data: ThemeData.light(),

        /// The key set here to maintain the state,
        ///  when we change the parent of the widget
        key: _globalKey,
        child: _getLoadMoreCalendar(_calendarController, _onViewChanged,
            _events, _scheduleViewBuilder));

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: _calendarController.view == CalendarView.month &&
                  screenHeight < 800
              ? Scrollbar(
                  thumbVisibility: true,
                  controller: _controller,
                  child: ListView(
                    controller: _controller,
                    children: <Widget>[
                      SizedBox(
                        height: 600,
                        child: calendar,
                      )
                    ],
                  ))
              : Container(child: calendar),
        )
      ]),
    );
  }

  /// Handle the view changed and it used to update the UI on web platform
  /// whether the calendar view changed from month view or to month view.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    if (_view == _calendarController.view) {
      return;
    }

    if ((_calendarController.view == CalendarView.month ||
        _view == CalendarView.month)) {
      _view = _calendarController.view!;
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        setState(() {
          /// Update the web UI when the calendar view changed from month view
          /// or to month view.
        });
      });
    }

    _view = _calendarController.view!;
  }

  /// Returns the builder for schedule view.
  Widget _scheduleViewBuilder(
      BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
    final String monthName = _getMonthDate(details.date.month);
    return Stack(
      children: <Widget>[
        Image(
            image: ExactAssetImage('images/' + monthName + '.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        Positioned(
          left: 55,
          right: 0,
          top: 20,
          bottom: 0,
          child: Text(
            monthName + ' ' + details.date.year.toString(),
            style: const TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getLoadMoreCalendar(
      [CalendarController? calendarController,
      ViewChangedCallback? viewChangedCallback,
      CalendarDataSource? calendarDataSource,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
        controller: calendarController,
        dataSource: calendarDataSource,
        allowedViews: _allowedViews,
        onViewChanged: viewChangedCallback,
        scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
        showNavigationArrow: true,
        blackoutDatesTextStyle: const TextStyle(color: Colors.red),
        loadMoreWidgetBuilder:
            (BuildContext context, LoadMoreCallback loadMoreAppointments) {
          return FutureBuilder<void>(
            future: loadMoreAppointments(),
            builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
              return Container(
                  height: _calendarController.view == CalendarView.schedule
                      ? 50
                      : double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const CustomLoadingWidget());
            },
          );
        },
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }
}

/// Returns the month name based on the month value passed from date.
String _getMonthDate(int month) {
  if (month == 01) {
    return 'January';
  } else if (month == 02) {
    return 'February';
  } else if (month == 03) {
    return 'March';
  } else if (month == 04) {
    return 'April';
  } else if (month == 05) {
    return 'May';
  } else if (month == 06) {
    return 'June';
  } else if (month == 07) {
    return 'July';
  } else if (month == 08) {
    return 'August';
  } else if (month == 09) {
    return 'September';
  } else if (month == 10) {
    return 'October';
  } else if (month == 11) {
    return 'November';
  } else {
    return 'December';
  }
}

Map<DateTime, List<Appointment>> _dataCollection =
    <DateTime, List<Appointment>>{};

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].endTime;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].subject;
  }

  @override
  Color getColor(int index) {
    return source[index].color;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    notifyListeners(CalendarDataSourceAction.reset, []);
    List<Appointment> fetchedAppointments = await appStore.dispatch(
        SCFetchShiftsWeekAction(startDate: startDate, endDate: endDate));
    _dataCollection = <DateTime, List<Appointment>>{};
    logger('handleLoadMore ${fetchedAppointments.length}');

    for (final Appointment appointment in fetchedAppointments) {
      final DateTime date = appointment.startTime;
      final List<Appointment>? meetings = _dataCollection[date];
      if (meetings == null) {
        _dataCollection[date] = <Appointment>[appointment];
      } else {
        meetings.add(appointment);
      }
    }
    final List<Appointment> meetings = <Appointment>[];
    DateTime date = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime appEndDate =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    while (date.isBefore(appEndDate)) {
      final List<Appointment>? data = _dataCollection[date];
      if (data == null) {
        date = date.add(const Duration(days: 1));
        continue;
      }

      for (final Appointment meeting in data) {
        if (appointments.contains(meeting)) {
          continue;
        }

        meetings.add(meeting);
      }
      date = date.add(const Duration(days: 1));
    }

    appointments.clear();
    appointments.addAll(meetings);
    notifyListeners(CalendarDataSourceAction.add, meetings);
  }
}
