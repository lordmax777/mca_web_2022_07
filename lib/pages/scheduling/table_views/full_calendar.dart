import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/models/users_list.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../menus.dart';
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
    CalendarView.month,
    CalendarView.timelineMonth,
  ];

  final GlobalKey _globalKey = GlobalKey();

  final CalendarController _calendarController = CalendarController();
  CalendarView _view = CalendarView.timelineDay;

  bool get isDay => _calendarController.view == _allowedViews[0];
  bool get isWeek => _calendarController.view == _allowedViews[1];
  bool get isMonth => _calendarController.view == _allowedViews[2];
  bool get isMonth2 => _calendarController.view == _allowedViews[3];

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _calendarController.view = _view;
    final List<CalendarResource> _usresources = <CalendarResource>[
      CalendarResource(
        id: "US_open",
        displayName: "Open Shift",
        color: Colors.lime[500]!,
      )
    ];
    final List<CalendarResource> _resources = <CalendarResource>[];
    final users = appStore.state.usersState.users;
    final properties = appStore.state.generalState.allSortedProperties;

    for (var us in users) {
      _usresources.add(CalendarResource(
          id: "US_${us.id}",
          displayName: us.fullname,
          color: us.userRandomBgColor));
    }
    for (var pr in properties) {
      // _prresources
      //     .add(CalendarResource(id: "PR_${pr.id}", displayName: pr.title));
    }
    _events = AppointmentDataSource(<Appointment>[]);

    _events.resources = _usresources;
    // _calendarController.addPropertyChangedListener((p0) {
    //p0 = selectedDate
    //p0 = calendarView
    //p0 = displayDate
    // });
    super.initState();
  }

  late final AppointmentDataSource _events;

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

    _view = _calendarController.view!;
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      //TODO:
      // _events.appointments.clear();
      // _events.notifyListeners(
      //     CalendarDataSourceAction.reset, _events.appointments);
      setState(() {
        /// Update the web UI when the calendar view changed from month view
        /// or to month view.
      });
    });

    _view = _calendarController.view!;
    appStore.dispatch(SCChangeCalendarView(_view));
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
      showDatePickerButton: true,
      showNavigationArrow: true,
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViews,
      onViewChanged: viewChangedCallback,
      viewNavigationMode: ViewNavigationMode.none,
      timeSlotViewSettings: _getTimeSlotSettings,
      todayHighlightColor: ThemeColors.MAIN_COLOR,
      viewHeaderHeight: _getViewHeaderHeight,
      resourceViewSettings: ResourceViewSettings(
        visibleResourceCount: 4,
      ),
      onTap: (calendarTapDetails, position) async {
        final ScheduleMenus menus = ScheduleMenus(context, position);
        switch (calendarTapDetails.targetElement) {
          case CalendarElement.header:
            // TODO: Handle this case.
            break;
          case CalendarElement.viewHeader:
            // TODO: Handle this case.
            break;
          case CalendarElement.calendarCell:
            // TODO: Handle this case.
            break;
          case CalendarElement.appointment:
            // TODO: Handle this case.
            menus.showMoreAppointmentsPopup(calendarTapDetails);
            break;
          case CalendarElement.agenda:
            // TODO: Handle this case.
            break;
          case CalendarElement.allDayPanel:
            // TODO: Handle this case.
            break;
          case CalendarElement.moreAppointmentRegion:
            // TODO: Handle this case.
            menus.showMoreAppointmentsPopup(calendarTapDetails);
            break;
          case CalendarElement.resourceHeader:
            // TODO: Handle this case.
            break;
        }
      },
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
      // selectionDecoration: BoxDecoration(
      //     //TODO:
      //     ),
    );
  }

  double get _getViewHeaderHeight {
    if (isDay) {
      return 30;
    }
    if (isWeek) {
      return 0;
    }
    if (isMonth2) {
      return 30;
    }

    return 0;
  }

  TimeSlotViewSettings get _getTimeSlotSettings {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: ThemeText.fontFamilyM,
    );
    if (isDay) {
      return TimeSlotViewSettings(
        timeIntervalWidth: MediaQuery.of(context).size.width * .0363,
        timelineAppointmentHeight: CalendarConstants.shiftHeight,
        timeInterval: const Duration(minutes: 60),
        timeFormat: "HH:mm",
        timeTextStyle: textStyle,
      );
    }
    if (isWeek) {
      return TimeSlotViewSettings(
        timeIntervalWidth: MediaQuery.of(context).size.width * .124,
        timelineAppointmentHeight: CalendarConstants.shiftHeight,
        timeInterval: const Duration(days: 1),
        timeFormat: "EEE d MMM",
        timeTextStyle: textStyle,
      );
    }
    return const TimeSlotViewSettings();
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

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class AppointmentDataSource extends CalendarDataSource {
  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    try {
      final view = appStore.state.scheduleState.calendarView;
      final bool isMonth = view == CalendarView.month;
      final List<Appointment> _meetings = <Appointment>[];
      DateTime st = startDate;
      DateTime et = endDate;
      if (isMonth) {
        st = startDate.startOfMonth;
        et = startDate.endOfMonth;
      }
      List<Appointment> fetchedAppointments = await appStore
          .dispatch(SCFetchShiftsWeekAction(startDate: st, endDate: et));

      for (final Appointment appointment in fetchedAppointments) {
        final DateTime date = appointment.startTime;
        if (appointment.isAllDay) {
          final stDate = DateTime(date.year, date.month, date.day, 00, 00);
          final DateTime etDate =
              DateTime(date.year, date.month, date.day, 01, 00);
          appointment.startTime = stDate;
          appointment.endTime = etDate;
        }
        if (!appointments.any((element) => element.id == appointment.id)) {
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
    } catch (e) {
      notifyListeners(CalendarDataSourceAction.add, []);

      showError("Something went wrong ${e}");

      Logger.e("Something went wrong while fetching shifts $e",
          tag: 'ShiftsCalendar');
    }
  }

  void _addNewAppointments(List<Appointment> _appointments) {
    appointments.addAll(_appointments);
    notifyListeners(CalendarDataSourceAction.add, _appointments);
  }

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
