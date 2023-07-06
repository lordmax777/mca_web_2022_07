import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_helper.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

abstract class CalendarConstants {
  static double tableHeight(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 230;
    return height;
  }

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

  static const quickScheduleDrawerWidth = 500.0;

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
  List<CalendarResource> resources(
    bool isUserResource,
    List<UserMd> users,
    List<PropertyMd> properties,
  ) {
    users.sort((a, b) => a.fullname.compareTo(b.fullname));
    properties.sort((a, b) => a.title.compareTo(b.title));
    final List<CalendarResource> resources = [
      CalendarConstants.openCalendarResource,
      if (isUserResource)
        ...users
            .map((us) => CalendarResource(
                id: "US_${us.id}",
                displayName:
                    "${us.fulltitle}${kDebugMode ? " (${us.id})" : ""}",
                color: Colors.blueAccent))
            .toList()
      else
        ...properties
            .map((pr) => CalendarResource(
                id: "PR_${pr.id}",
                displayName: "${pr.title}${kDebugMode ? " (${pr.id})" : ""}",
                color: Colors.blueAccent))
            .toList()
    ];
    // //if showResourcesWithAppointment is false, then show all slots without using resourcesWithAppointment
    // if (!showResourcesWithAppointment) {
    //   return resources;
    // }

    // //if showResourcesWithAppointment is true, then show only resourcesWithAppointment
    // if (resourcesWithAppointment.isNotEmpty && isFilterEmpty) {
    //   return resources
    //       .where((element) => resourcesWithAppointment
    //           .any((resourceId) => resourceId == element.id))
    //       .toList();
    // }
    //else show all resources
    return resources;
  }

  final TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  final List<CalendarView> allowedViews = [
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.month,
    CalendarView.schedule,
  ];

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
        timeFormat: kDebugMode ? "MMM d" : "MMM d, EEEE",
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
      displayNameTextStyle: textStyle.copyWith(
        fontSize: 18,
        color: Colors.white,
      ),
      showAvatar: false,
    );
  }

  Widget _getTypeWidget({
    required String title,
    required String initials,
    String? subtitle,
    required Color bgColor,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
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
              child: Text(
                initials,
                style: TextStyle(
                  color: bgColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SpacedColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              verticalSpace: 4.0,
              children: [
                SizedBox(
                    width: 190,
                    child: Text(
                      title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                if (subtitle != null)
                  SizedBox(
                      width: 190,
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget resourceViewHeaderBuilder(
      BuildContext ctx,
      ResourceViewHeaderDetails details,
      List<UserMd> users,
      List<PropertyMd> properties) {
    final resource = details.resource;
    final type = resource.findType(users, properties);
    //handle open shift
    if (type == null) {
      return _getTypeWidget(
        title: resource.displayName,
        initials: "OS",
        bgColor: CalendarConstants.openShiftAppointmentColor,
      );
    }
    if (type is UserMd) {
      final user = type;
      return _getTypeWidget(
          title: resource.displayName,
          initials: user.initials,
          bgColor: Colors.blueAccent,
          subtitle: user.username);
    }
    if (type is PropertyMd) {
      final location = type;
      return _getTypeWidget(
        title: resource.displayName,
        initials: location.initials,
        bgColor: Colors.blueAccent,
        subtitle: location.locationName,
      );
    }
    return const SizedBox();
  }

  MonthViewSettings getMonthViewSettings() {
    return MonthViewSettings(
      showTrailingAndLeadingDates: false,
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

class ScheduleMenus {
  static const int moreAppointmentCount = 4;

  ScheduleMenus(this._context, this._position);

  final BuildContext _context;
  final Offset? _position;

  RelativeRect? _getPosition() {
    if (_position == null) return null;
    //Positions the menu
    final RenderBox overlay =
        Overlay.of(_context).context.findRenderObject() as RenderBox;
    Offset off;
    double left;
    double top;
    double right;
    double bottom;
    off = overlay.globalToLocal(_position!);
    left = off.dx;
    top = off.dy;
    right = MediaQuery.of(_context).size.width - left;
    bottom = MediaQuery.of(_context).size.height - top;
    return RelativeRect.fromLTRB(left, top, right, bottom);
  }

  Future<bool> showMoreAppointmentsPopup(
      CalendarTapDetails calendarTapDetails) async {
    final List<Appointment> appointments = (calendarTapDetails.appointments
            ?.map((e) => e as Appointment)
            .toList()) ??
        <Appointment>[];

    if (_position == null) return false;
    if (appointments.isEmpty || appointments.length < 3) return false;

    final RelativeRect pos = _getPosition()!;
    final List<PopupMenuItem<Appointment>> items = [];
    for (int i = 0; i < appointments.length; i++) {
      //Get all the hidden appointments
      final Appointment app = appointments[i];
      items.add(PopupMenuItem(
        value: app,
        enabled: false,
        textStyle: const TextStyle(color: Colors.black),
        key: ValueKey(app),
        height: 30,
        padding: const EdgeInsets.symmetric(vertical: .5),
        child: InkWell(
          onTap: () {
            Navigator.of(_context).pop(app);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            margin: const EdgeInsets.symmetric(vertical: 1),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            height: 40,
            decoration: BoxDecoration(
              // color: app.color,
              border: Border.all(
                color: Colors.black,
                width: .5,
              ),
            ),
            child: Text(
              app.subject,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ));
    }
    final resultFromAppointmentTap = await showMenu<Appointment>(
      context: _context,
      position: pos,
      items: items,
    );
    if (resultFromAppointmentTap == null) return false;
    // final res = await showFormActionsPopup(
    //     resultFromAppointmentTap, calendarTapDetails.date);
    // return res;//TODO: fix this
    return false;
  }

  // Future<bool> showFormActionsPopup( //TODO: fix this
  //     Appointment? appointment,
  //     DateTime? date, {
  //       Future<List<Appointment>?> Function(JobModel? createdjob)?
  //       onJobCreateSuccess,
  //       Future<void> Function()? onJobDeleteSuccess,
  //       CalendarResource? customResource,
  //     }) async {
  //   final DateTime? stDate = date;
  //   CalendarResource? resource = appointment == null
  //       ? customResource
  //       : CalendarResource(id: appointment.resourceIds!.first);
  //
  //   final res = await showFormsMenus(
  //     _context,
  //     globalPosition: _position!,
  //     onJobCreateSuccess: onJobCreateSuccess,
  //     onJobDeleteSuccess: onJobDeleteSuccess,
  //     data: JobModel(
  //       customStartDate: stDate,
  //       customEndDate: stDate?.add(const Duration(hours: 1)),
  //       customResource: resource,
  //       allocation: appointment?.id as AllocationModel?,
  //     ),
  //   );
  //   return res;
  // }
}
