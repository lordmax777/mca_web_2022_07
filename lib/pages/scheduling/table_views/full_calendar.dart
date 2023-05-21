import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../menus.dart';
import 'data_source.dart';
export 'data_source.dart';

class FullCalendar extends StatefulWidget {
  final bool isUserResource;
  const FullCalendar({Key? key, required this.isUserResource})
      : super(key: key);

  @override
  State<FullCalendar> createState() => _FullCalendarState();
}

class _FullCalendarState extends State<FullCalendar> {
  final CalendarConf conf = CalendarConstants.conf;

  DateTime? _startDate;
  DateTime? _endDate;

  void _setDateRange(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
  }

  bool get isUserResource => widget.isUserResource;

  final GlobalKey _globalKey = GlobalKey();

  final CalendarController _calendarController = CalendarController();
  CalendarView _view = CalendarView.timelineDay;

  bool get isDay => conf.isDay(_calendarController.view!);
  bool get isWeek => conf.isWeek(_calendarController.view!);
  bool get isMonth => conf.isMonth(_calendarController.view!);
  bool get isSchedule => conf.isSchedule(_calendarController.view!);

  late final AppointmentDataSource _events;

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FullCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isUserResource != widget.isUserResource) {
      _events.resources = conf.resources(widget.isUserResource);
    }
  }

  @override
  void initState() {
    _view = appStore.state.scheduleState.calendarView;
    _calendarController.view = _view;

    _events =
        AppointmentDataSource(<Appointment>[], onRangeChanged: _setDateRange);

    _events.resources = conf.resources(isUserResource);

    _calendarController.addPropertyChangedListener((e) {
      if (e == 'calendarView') {
        _events.clearAppointments();
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
        (viewChangedDetails) => _onViewChanged(),
        _events,
      ),
    );

    return Scaffold(
      body: Container(child: calendar),
    );
  }

  /// Handle the view changed and it used to update the UI on web platform
  /// whether the calendar view changed from month view or to month view.
  void _onViewChanged() {
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

  Appointment? prevApp;

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
      allowedViews: conf.allowedViews,
      onViewChanged: viewChangedCallback,
      viewNavigationMode: ViewNavigationMode.none,
      timeSlotViewSettings: conf.getTimeSlotSettings(_view, context),
      todayHighlightColor: ThemeColors.MAIN_COLOR,
      viewHeaderHeight: conf.getViewHeaderHeight(_view),
      onTap: _getOnTap,
      showCurrentTimeIndicator: false,
      firstDayOfWeek: 1,
      resourceViewHeaderBuilder: conf.resourceViewHeaderBuilder,
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
      // initialDisplayDate: DateTime(2023, 05, 04),
      // initialSelectedDate: DateTime(2023, 05, 04),
      monthViewSettings: conf.getMonthViewSettings(),
      allowDragAndDrop: kDebugMode,
      resourceViewSettings: conf.getResourceViewSettings(context),
    );
  }

  void _getOnTap(
      CalendarTapDetails calendarTapDetails, Offset? position) async {
    final ScheduleMenus menus = ScheduleMenus(context, position);
    switch (calendarTapDetails.targetElement) {
      case CalendarElement.calendarCell:
      case CalendarElement.appointment:
        final res = await menus.showFormActionsPopup(calendarTapDetails);
        if (res == null) return;
        if (_startDate != null && _endDate != null) {
          _events.clearAppointments();
          _events.handleLoadMore(_startDate!, _endDate!, true);
        }
        break;
      case CalendarElement.header:
        // TODO: Handle this case.
        break;
      case CalendarElement.viewHeader:
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
}
