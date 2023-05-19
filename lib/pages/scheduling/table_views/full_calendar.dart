import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../menus.dart';
import '../scheduling_page.dart';

class FullCalendar extends StatefulWidget {
  const FullCalendar({Key? key}) : super(key: key);

  @override
  State<FullCalendar> createState() => _FullCalendarState();
}

class _FullCalendarState extends State<FullCalendar> {
  final List<CalendarView> _allowedViews = [
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.month,
    CalendarView.schedule,
  ];

  final GlobalKey _globalKey = GlobalKey();

  final CalendarController _calendarController = CalendarController();
  CalendarView _view = CalendarView.timelineDay;

  bool get isDay => _calendarController.view == _allowedViews[0];
  bool get isWeek => _calendarController.view == _allowedViews[1];
  bool get isMonth => _calendarController.view == _allowedViews[2];
  bool get isSchedule => _calendarController.view == _allowedViews[3];

  late final AppointmentDataSource _events;

  final TextStyle _textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: ThemeText.fontFamilyM,
  );

  @override
  void initState() {
    _view = appStore.state.scheduleState.calendarView;
    _calendarController.view = _view;

    final List<CalendarResource> _resources = <CalendarResource>[
      CalendarResource(
        id: "OPEN",
        displayName: "Open Shift",
        color: CalendarConstants.openShiftAppointmentColor,
      )
    ];
    final users = appStore.state.usersState.users;
    final properties = appStore.state.generalState.allSortedProperties;

    for (var us in users) {
      _resources.add(CalendarResource(
          id: "US_${us.id}",
          displayName: us.fullname,
          color: us.userRandomBgColor));
    }

    _events = AppointmentDataSource(<Appointment>[]);

    _events.resources = _resources;

    _calendarController.addPropertyChangedListener((e) {
      if (e == 'calendarView') {
        _events.appointments.clear();
        _events.notifyListeners(
            CalendarDataSourceAction.reset, _events.appointments);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(
      data: ThemeData.light(),

      /// The key set here to maintain the state,
      ///  when we change the parent of the widget
      key: _globalKey,
      child: _getLoadMoreCalendar(
        _calendarController,
        _onViewChanged,
        _events,
      ),
    );

    return Scaffold(
      body: Container(child: calendar),
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
      setState(() {
        /// Update the web UI when the calendar view changed from month view
        /// or to month view.
      });
    });

    _view = _calendarController.view!;
    appStore.dispatch(SCChangeCalendarView(_view));
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getLoadMoreCalendar(
      [CalendarController? calendarController,
      ViewChangedCallback? viewChangedCallback,
      CalendarDataSource? calendarDataSource]) {
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
      onTap: _getOnTap,
      showCurrentTimeIndicator: false,
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
      initialDisplayDate: DateTime(2023, 05, 04),
      initialSelectedDate: DateTime(2023, 05, 04),
      monthViewSettings: _getMonthViewSettings,
      allowDragAndDrop: kDebugMode,
      resourceViewSettings: _getResourceViewSettings,
    );
  }

  void _getOnTap(calendarTapDetails, position) async {
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
        break;
      case CalendarElement.agenda:
        // TODO: Handle this case.
        break;
      case CalendarElement.allDayPanel:
        // TODO: Handle this case.
        break;
      case CalendarElement.moreAppointmentRegion:
        menus.showMoreAppointmentsPopup(calendarTapDetails);
        break;
      case CalendarElement.resourceHeader:
        // TODO: Handle this case.
        break;
    }
  }

  ResourceViewSettings get _getResourceViewSettings {
    return ResourceViewSettings(
      size: CalendarConstants.resourceWidth,
      visibleResourceCount: CalendarConstants.resourceCount(context),
      displayNameTextStyle: _textStyle,
    );
  }

  MonthViewSettings get _getMonthViewSettings {
    return MonthViewSettings(
      appointmentDisplayCount: ScheduleMenus.moreAppointmentCount,
      monthCellStyle: MonthCellStyle(
        textStyle: _textStyle,
        leadingDatesTextStyle: _textStyle.copyWith(
          color: Colors.black26,
          fontSize: 14,
        ),
        trailingDatesTextStyle: _textStyle.copyWith(
          color: Colors.black26,
          fontSize: 14,
        ),
      ),
      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
    );
  }

  double get _getViewHeaderHeight {
    if (isMonth) {
      return 30;
    }
    if (isWeek) {
      return 0;
    }

    return 30;
  }

  TimeSlotViewSettings get _getTimeSlotSettings {
    if (isDay) {
      return TimeSlotViewSettings(
        timeIntervalWidth: CalendarConstants.shiftWidth(context),
        timelineAppointmentHeight: CalendarConstants.shiftHeight,
        timeInterval: const Duration(minutes: 60),
        timeFormat: "HH:mm",
        timeTextStyle: _textStyle,
      );
    }
    if (isWeek) {
      return TimeSlotViewSettings(
        timeIntervalWidth: (MediaQuery.of(context).size.width -
                CalendarConstants.resourceWidth) *
            .14,
        timeTextStyle: _textStyle,
        timeFormat: "MMM d, EEEE",
        startHour: 0,
        endHour: 1,
      );
    }
    return const TimeSlotViewSettings();
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

      List<Appointment> fetchedAppointments = await appStore
          .dispatch(SCFetchShiftsWeekAction(startDate: st, endDate: et));

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
