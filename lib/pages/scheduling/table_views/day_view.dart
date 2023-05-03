import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/models/location_item_md.dart';
import '../../../manager/models/property_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';
import '../popup_forms/job_form.dart';
import '../scheduling_page.dart';

class DailyViewCalendar extends StatelessWidget {
  final DateTime day;

  const DailyViewCalendar({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          final scheduleState = state.scheduleState;
          const interval = 60;
          return SfCalendar(
            view: CalendarView.timelineDay,
            resourceViewHeaderBuilder: (context, details) {
              final user = details.resource.id as UserRes;
              return _userWidget(user);
            },
            resourceViewSettings: ResourceViewSettings(
              size: CalendarConstants.resourceWidth,
              showAvatar: false,
              visibleResourceCount: CalendarConstants.resourceCount(context),
            ),
            dataSource: getDataSource(scheduleState),
            timeSlotViewSettings: TimeSlotViewSettings(
              timeIntervalWidth: MediaQuery.of(context).size.width * .0363,
              timelineAppointmentHeight: CalendarConstants.shiftHeight,
              timeInterval: const Duration(minutes: interval),
              timeFormat: "h:mm a",
              timeTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: ThemeText.fontFamilyR,
              ),
            ),
            headerHeight: 0,
            viewHeaderHeight: 0,
            viewNavigationMode: ViewNavigationMode.none,
            dragAndDropSettings: const DragAndDropSettings(
              allowScroll: true,
              allowNavigation: false,
            ),
            onSelectionChanged: (calendarSelectionDetails) async {},
            initialSelectedDate: day,
            initialDisplayDate: day,
            todayHighlightColor: Colors.transparent,
            allowDragAndDrop: false,
            appointmentBuilder: (_, calendarAppointmentDetails) {
              final appointment = calendarAppointmentDetails.appointments
                  .toList()
                  .first as Appointment?;
              final ap = appointment?.id as AppointmentIdMd?;
              if (ap == null) {
                return const SizedBox();
              }
              return _appWidget(appointment!, context);
            },
          );
        });
  }

  Widget _appWidget(Appointment appointment, BuildContext context) {
    final ap = appointment.id as AppointmentIdMd;
    final location = ap.property;
    final user = ap.user;
    final formatter = DateFormat('h:mm a');
    final start = appointment.startTime;
    final end = appointment.endTime;
    final title =
        "${formatter.format(start)} - ${formatter.format(end)} / ${location.title ?? "-"} / ${location.locationName}";
    return Tooltip(
      verticalOffset: 10,
      message: title,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (details) async {
          final RenderBox overlay =
              Overlay.of(context)!.context.findRenderObject() as RenderBox;
          final offset = overlay.globalToLocal(details.globalPosition);
          double left = offset.dx;
          double top = offset.dy;
          double right = MediaQuery.of(context).size.width - left;
          double bottom = MediaQuery.of(context).size.height - top;

          final createTapResult = await showMenu<ScheduleCreatePopupMenus>(
              context: context,
              position: RelativeRect.fromLTRB(left, top, right, bottom),
              items: getPopupCreateMenus());
          logger(createTapResult, hint: 'Type');
          if (createTapResult == null) return;
          final jobCreated = await showDialog<ApiResponse?>(
              context: context,
              barrierDismissible: false,
              builder: (context) => JobEditForm(
                  data: CreateShiftData(date: appointment.startTime)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: user.userRandomBgColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                    fontFamily: ThemeText.fontFamilyM,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userWidget(UserRes user) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
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
        padding: const EdgeInsets.only(left: 24.0),
        child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: user.userRandomBgColor,
              maxRadius: 24.0,
              child: KText(
                fontSize: 16.0,
                isSelectable: false,
                textColor: user.foregroundColor,
                fontWeight: FWeight.bold,
                text:
                    "${user.firstName.substring(0, 1)}${user.lastName.substring(0, 1)}"
                        .toUpperCase(),
              ),
            ),
            const SizedBox(width: 16.0),
            SpacedColumn(
              verticalSpace: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    child: KText(
                      isSelectable: false,
                      maxLines: 2,
                      text: user.fullname,
                      fontSize: 14.0,
                      textColor: ThemeColors.gray2,
                      fontWeight: FWeight.bold,
                    )),
                SizedBox(
                    width: 200,
                    child: KText(
                      isSelectable: false,
                      maxLines: 2,
                      text: user.username,
                      fontSize: 14.0,
                      textColor: ThemeColors.black,
                      fontWeight: FWeight.regular,
                    )),
              ],
            ),
          ],
        ));
  }

  CalendarDataSource getDataSource(ScheduleState state) {
    dynamic users = state.userResources;
    return ShiftDataSource(state.getDayShifts,
        users.map<CalendarResource>((e) => CalendarResource(id: e)).toList());
  }
}
