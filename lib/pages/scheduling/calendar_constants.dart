import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../manager/model_exporter.dart';
import '../../manager/redux/sets/app_state.dart';
import 'menus.dart';

abstract class CalendarConstants {
  static double fullHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - 80;

  static double tableHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - 160;

  static const double resourceWidth = 120;

  static const double shiftHeight = 50;

  static double shiftWidth(BuildContext context) =>
      (MediaQuery.of(context).size.width - resourceWidth) * .0409;

  static int resourceCount(BuildContext context) =>
      (tableHeight(context) / (shiftHeight * 3)).ceil();

  static Color openShiftAppointmentColor = Colors.blueGrey;

  static CalendarResource openCalendarResource = CalendarResource(
    id: "OPEN",
    displayName: "Open Shift",
    color: CalendarConstants.openShiftAppointmentColor,
  );

  static CalendarConf conf = CalendarConf();
}

class CalendarConf {
  //Functions
  String getUserResourceId(int id) => "US_$id";
  String getPrResourceId(int id) => "PR_$id";
  bool isDay(CalendarView view) => view == allowedViews[0];
  bool isWeek(CalendarView view) => view == allowedViews[1];
  bool isMonth(CalendarView view) => view == allowedViews[2];
  bool isSchedule(CalendarView view) => view == allowedViews[3];
  List<CalendarResource> resources(bool isUserResource) {
    return [
      CalendarConstants.openCalendarResource,
      if (isUserResource)
        ..._users.map((us) => CalendarResource(
            id: "US_${us.id}",
            displayName: "${us.fullname} (${us.id})",
            color: us.userRandomBgColor))
      else
        ..._properties.map((pr) => CalendarResource(
            id: "PR_${pr.id}",
            displayName: "${pr.title} (${pr.id})",
            color: Colors.blueAccent))
    ];
  }

  final TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: ThemeText.fontFamilyM,
  );

  final List<CalendarView> allowedViews = [
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.month,
    CalendarView.schedule,
  ];

  //Getters
  List<UserRes> get _users => appStore.state.usersState.users;
  List<PropertiesMd> get _properties =>
      appStore.state.generalState.allSortedProperties;

  List<CalendarResource> userResources = [
    CalendarConstants.openCalendarResource,
  ];
  List<CalendarResource> prResources = [
    CalendarConstants.openCalendarResource,
  ];

  //Calendar Settings
  TimeSlotViewSettings getTimeSlotSettings(
      CalendarView view, BuildContext context) {
    if (isDay(view)) {
      return TimeSlotViewSettings(
        timeIntervalWidth: CalendarConstants.shiftWidth(context),
        timelineAppointmentHeight: CalendarConstants.shiftHeight,
        timeInterval: const Duration(minutes: 60),
        timeFormat: "HH:mm",
        timeTextStyle: textStyle,
      );
    }
    if (isWeek(view)) {
      return TimeSlotViewSettings(
        timeIntervalWidth: (MediaQuery.of(context).size.width -
                CalendarConstants.resourceWidth) *
            .14,
        timeTextStyle: textStyle,
        timeFormat: "MMM d, EEEE",
        startHour: 0,
        endHour: 1,
      );
    }
    return const TimeSlotViewSettings();
  }

  ResourceViewSettings getResourceViewSettings(BuildContext context) {
    return ResourceViewSettings(
      size: CalendarConstants.resourceWidth,
      visibleResourceCount: CalendarConstants.resourceCount(context),
      displayNameTextStyle: textStyle.copyWith(fontSize: 12),
    );
  }

  MonthViewSettings getMonthViewSettings() {
    return MonthViewSettings(
      appointmentDisplayCount: ScheduleMenus.moreAppointmentCount,
      monthCellStyle: MonthCellStyle(
        textStyle: textStyle,
        leadingDatesTextStyle: textStyle.copyWith(
          color: Colors.black26,
          fontSize: 14,
        ),
        trailingDatesTextStyle: textStyle.copyWith(
          color: Colors.black26,
          fontSize: 14,
        ),
      ),
      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
    );
  }

  double getViewHeaderHeight(CalendarView view) {
    if (isMonth(view)) {
      return 30;
    }
    if (isWeek(view)) {
      return 0;
    }

    return 30;
  }
}
