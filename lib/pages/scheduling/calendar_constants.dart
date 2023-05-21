import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
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

  static const double resourceWidth = 300;

  static const double shiftHeight = 50;

  static double shiftWidth(BuildContext context) =>
      (MediaQuery.of(context).size.width - resourceWidth) * .0409;

  static int resourceCount(BuildContext context) =>
      (tableHeight(context) / (shiftHeight * 3)).ceil();

  static Color openShiftAppointmentColor = Colors.green;

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

  Widget _getTypeWidget({
    required String title,
    required String initials,
    String? subtitle,
    required Color bgColor,
  }) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ThemeColors.gray11,
            width: 1,
          ),
          right: BorderSide(
            color: ThemeColors.gray11,
            width: 1,
          ),
          bottom: BorderSide(
            color: ThemeColors.gray11,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: SpacedRow(
          horizontalSpace: 16,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: bgColor,
              maxRadius: 32.0,
              child: KText(
                fontSize: 18.0,
                isSelectable: false,
                fontWeight: FWeight.bold,
                textColor: bgColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
                text: initials,
              ),
            ),
            SpacedColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              verticalSpace: 4.0,
              children: [
                SizedBox(
                    width: 190,
                    child: KText(
                      isSelectable: false,
                      maxLines: 2,
                      text: title,
                      fontSize: 18.0,
                      textColor: ThemeColors.gray2,
                      fontWeight: FWeight.bold,
                    )),
                if (subtitle != null)
                  SizedBox(
                      width: 190,
                      child: KText(
                        isSelectable: false,
                        maxLines: 2,
                        text: subtitle,
                        fontSize: 18.0,
                        textColor: ThemeColors.black,
                        fontWeight: FWeight.regular,
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget resourceViewHeaderBuilder(
      BuildContext ctx, ResourceViewHeaderDetails details) {
    final resource = details.resource;
    final type = resource.findType(_users, _properties);
    //handle open shift
    if (type == null) {
      return _getTypeWidget(
        title: resource.displayName,
        initials: "OS",
        bgColor: CalendarConstants.openShiftAppointmentColor,
      );
    }
    if (type is UserRes) {
      final user = type;
      return _getTypeWidget(
          title: user.fullname,
          initials: user.initials,
          bgColor: user.userRandomBgColor,
          subtitle: user.username);
    }
    if (type is PropertiesMd) {
      final location = type;
      return _getTypeWidget(
        title: location.title,
        initials: location.initials,
        bgColor: Colors.blueAccent,
        subtitle: location.locationName,
      );
    }
    return const SizedBox();
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

//TODO: ONDRAGE
// onDragStart: (appointmentDragStartDetails) {
//   final app = appointmentDragStartDetails.appointment as Appointment?;
//   if (app == null) return;
//   prevApp = app;
// },
// onDragEnd: (appointmentDragUpdateDetails) async {
//   final app = appointmentDragUpdateDetails.appointment as Appointment?;
//   final alloc = app?.id as AllocationModel?;
//   if (alloc == null) return;
//   final resource =
//       appointmentDragUpdateDetails.sourceResource?.id as String?;
//   final targetResource =
//       appointmentDragUpdateDetails.targetResource?.id as String?;
//   final userId = alloc.user?.id ?? 0;
//   final shiftId = alloc.shift.id;
//   final date = alloc.date;
//   final mode = AllocationActions.copy.name;
//   int? targetShiftId;
//   int? targetUserId;
//   final targetDate = DateFormat('yyyy-MM-dd')
//       .format(appointmentDragUpdateDetails.droppingTime!);
//   if (targetResource?.startsWith("US_") ?? false) {
//     targetUserId = int.tryParse(targetResource!.substring(3));
//   } else if (targetResource?.startsWith("PR_") ?? false) {
//     targetShiftId = int.tryParse(targetResource!.substring(3));
//   }
//
//   print("targetUserId: $targetUserId");
//   print("targetShiftId: $targetShiftId");
//   print("targetDate: $targetDate");
//   print("userId: $userId");
//   print("shiftId: $shiftId");
//   print("date: $date");
//   print("mode: $mode");
//   showLoading();
//   final ApiResponse res = await restClient()
//       .postShifts(0, userId, shiftId, date, mode,
//           date_until: date,
//           target_shift: targetShiftId,
//           target_user: targetUserId,
//           target_date: targetDate)
//       .nocodeErrorHandler();
//   await closeLoading();
//   if (res.success) {
//     _events.notifyListeners(CalendarDataSourceAction.add, [prevApp]);
//   } else {
//     //TODO: show error
//     showError(
//         HtmlHelper.replaceBr(ApiHelpers.getRawDataErrorMessages(res)));
//     //copy back to original position
//     prevApp?.resourceIds = [resource!];
//     _events.appointments.add(prevApp);
//     _events.notifyListeners(CalendarDataSourceAction.add, [prevApp]);
//     _events.appointments.remove(app);
//     _events.notifyListeners(CalendarDataSourceAction.remove, [app]);
//   }
// },
