import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/mca_loading.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:mix/mix.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../manager/models/property_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../menus.dart';
import '../models/allocation_model.dart';
import '../models/job_model.dart';
import 'data_source.dart';
export 'data_source.dart';

class FullCalendar extends StatefulWidget {
  final bool isUserResource;
  final ValueChanged<CalendarView> onShowResources;
  final List<int> selectedResources;
  final List<UserRes> users;
  final List<PropertiesMd> properties;
  const FullCalendar(
      {Key? key,
      required this.isUserResource,
      required this.onShowResources,
      required this.users,
      required this.properties,
      required this.selectedResources})
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
  ValueChanged<CalendarView> get onShowResources => widget.onShowResources;
  List<int> get selectedResources => widget.selectedResources;

  List<UserRes> get users => widget.users;
  List<PropertiesMd> get properties => widget.properties;
  List<CalendarResource> get resources =>
      conf.resources(isUserResource, users, properties);
  List<CalendarResource> get resourcesWithoutAll =>
      conf.resources(isUserResource, users, properties)..removeAt(1);

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
      _events.resources = resources;
    }
    _handleResourceChange();
  }

  void _handleResourceChange() {
    //Show all resources
    if (selectedResources.isEmpty) {
      //reset resource
      _events.resources = resourcesWithoutAll;
      return;
    }
    //Filter resources
    final filteredUsers = <UserRes>[];
    final filteredProperties = <PropertiesMd>[];
    for (int i in selectedResources) {
      if (isUserResource) {
        final user = users[i];
        filteredUsers.add(user);
      } else {
        final property = properties[i];
        filteredProperties.add(property);
      }
    }
    _events.resources = conf.resources(
        isUserResource,
        filteredUsers.isEmpty ? users : filteredUsers,
        filteredProperties.isEmpty ? properties : filteredProperties);
  }

  @override
  void initState() {
    _view = appStore.state.scheduleState.calendarView;
    _calendarController.view = _view;

    _events =
        AppointmentDataSource(<Appointment>[], onRangeChanged: _setDateRange);

    _events.resources = resourcesWithoutAll;

    _calendarController.addPropertyChangedListener((e) {
      if (e == 'calendarView') {
        _events.clearAppointments();
        onShowResources(_calendarController.view!);
      }
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onShowResources(_calendarController.view!);
    });
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
      body: calendar,
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
      appointmentBuilder: isMonth || isSchedule
          ? null
          : (context, calendarAppointmentDetails) {
              final appointment = calendarAppointmentDetails.appointments
                  .toList()
                  .first as Appointment?;
              final ap = appointment?.id as AllocationModel?;
              if (ap == null) {
                return const SizedBox();
              }
              return Tooltip(
                message: appointment?.subject,
                child: Container(
                  width: calendarAppointmentDetails.bounds.width,
                  height: calendarAppointmentDetails.bounds.height,
                  color: appointment?.color,
                  child: Text(
                    appointment?.subject ?? '',
                    style: ThemeText.md.copyWith(
                        color: appointment!.color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        fontFamily: ThemeText.fontFamilyM),
                  ),
                ),
              );
            },
      resourceViewHeaderBuilder: (ctx, details) =>
          conf.resourceViewHeaderBuilder(ctx, details, users, properties),
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
      allowDragAndDrop: false,
      resourceViewSettings: conf.getResourceViewSettings(context),
    );
  }

  void _getOnTap(
      CalendarTapDetails calendarTapDetails, Offset? position) async {
    final ScheduleMenus menus = ScheduleMenus(context, position);
    switch (calendarTapDetails.targetElement) {
      case CalendarElement.calendarCell:
        final success =
            await menus.showFormActionsPopup(null, calendarTapDetails.date);
        if (!success) return;
        await _events.handleLoadMore(_startDate!, _endDate!, true);
        break;
      case CalendarElement.appointment:
        final appointment = calendarTapDetails.appointments != null
            ? (calendarTapDetails.appointments!.isNotEmpty
                ? calendarTapDetails.appointments!.first as Appointment
                : null)
            : null;
        final createSuccess = await menus.showFormActionsPopup(
          appointment,
          calendarTapDetails.date,
          onJobDeleteSuccess: () async {
            _events.removeAppointment(appointment);
            McaLoading.showSuccess("Job deleted successfully");
          },
          onJobCreateSuccess: (JobModel? createdJob) async {
            final loadedNewApps =
                await _events.handleLoadMore(_startDate!, _endDate!, true);
            return loadedNewApps;
          },
        );
        if (!createSuccess) return;
        if (_startDate == null || _endDate == null) return;
        if (createSuccess == true) {
          final apps = [..._events.appointments];
          for (Appointment app in apps) {
            if ((app.id as AllocationModel).shift.id ==
                (appointment?.id as AllocationModel?)?.shift.id) {
              _events.removeAppointment(app);
            }
          }
          await _events.handleLoadMore(_startDate!, _endDate!, true);
        }
        break;
      case CalendarElement.moreAppointmentRegion:
        menus.showMoreAppointmentsPopup(calendarTapDetails);
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
      case CalendarElement.resourceHeader:
        // TODO: Handle this case.
        break;
    }
  }
}
