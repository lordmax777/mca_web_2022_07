import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/models/location_item_md.dart';
import '../../../manager/models/property_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';

class DailyViewCalendar extends StatelessWidget {
  final DateTime day;

  const DailyViewCalendar({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          final scheduleState = state.scheduleState;
          final interval = scheduleState.interval;
          return SfCalendar(
            view: CalendarView.timelineDay,
            // resourceViewHeaderBuilder: (context, details) {
            //   final user = details.resource.id as UserRes;
            //   return _userWidget(user);
            // },
            resourceViewSettings: ResourceViewSettings(
              // size: 300,
              // size: 300,
              showAvatar: false,
              // visibleResourceCount: visibleResourceCount(scheduleState),
            ),
            dataSource: getDataSource(scheduleState),
            timeSlotViewSettings: TimeSlotViewSettings(
              timeIntervalWidth: 70,
              timelineAppointmentHeight: 30,
              timeInterval: Duration(minutes: interval),
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
            onSelectionChanged: (calendarSelectionDetails) async {
              // openEndDrawer(const Drawer());
            },
            onTap: (calendarTapDetails) {},
            initialSelectedDate: day,
            initialDisplayDate: day,
            todayHighlightColor: Colors.transparent,
            allowDragAndDrop: false,
            // appointmentBuilder: (_, calendarAppointmentDetails) {
            //   final appointment = calendarAppointmentDetails.appointments
            //       .toList()
            //       .first as Appointment?;
            //   final ap = appointment?.id as AppointmentIdMd?;
            //   if (ap == null) {
            //     return const SizedBox();
            //   }
            //   // final count = scheduleState.countSameShiftStartDate(appointment!,
            //   //     isWeek: false);
            //
            //   return _appWidget(appointment!, 8);
            // },
          );
        });
  }

  Widget _appWidget(Appointment appointment, int count) {
    final ap = appointment.id as AppointmentIdMd;
    final location = ap.property;
    final user = ap.user;
    final bool isLarge = count == 1;

    return Tooltip(
      message:
          "${DateFormat('h:mm a').format(appointment.startTime)} - ${DateFormat('h:mm a').format(appointment.endTime)}",
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: user.userRandomBgColor,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 16.0, vertical: isLarge ? 8.0 : 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isLarge)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    isSelectable: false,
                    text:
                        "${DateFormat('h:mm a').format(appointment.startTime)} - ${DateFormat('h:mm a').format(appointment.endTime)}",
                    fontSize: 14,
                    fontWeight: FWeight.bold,
                  ),
                  KText(
                    isSelectable: false,
                    text: location.title ?? "-",
                    fontSize: 14,
                    fontWeight: FWeight.bold,
                  ),
                ],
              )
            else
              SpacedRow(
                horizontalSpace: 16.0,
                children: [
                  KText(
                    isSelectable: false,
                    text:
                        "${DateFormat('h:mm a').format(appointment.startTime)} - ${DateFormat('h:mm a').format(appointment.endTime)}",
                    fontSize: 14 / count * 2,
                    fontWeight: FWeight.bold,
                  ),
                  KText(
                    isSelectable: false,
                    text: location.title ?? "-",
                    fontSize: 14 / count * 2,
                    fontWeight: FWeight.bold,
                  ),
                ],
              ),
            // IconButton(
            //     alignment: Alignment.centerRight,
            //     padding: const EdgeInsets.all(0.0),
            //     onPressed: () async {},
            //     icon: HeroIcon(
            //       HeroIcons.moreVertical,
            //       size: 24.0 / count,
            //       color: Colors.white,
            //     )),
          ],
        ),
      ),
    );
  }

  int visibleResourceCount(ScheduleState scheduleState) {
    final len = scheduleState.userResources.length;
    final count = scheduleState.largestAppointmentCountDay;
    switch (len) {
      // case 0:
      //   return 0;
      // case 1:
      // case 2:
      // case 3:
      // case 4:
      // case 5:
      // case 6:
      // case 7:
      // case 8:
      //   return len;
      default:
        switch (count) {
          case 0:
          case 1:
            return 9;
          case 2:
          case 3:
            return 3;
          case 4:
            return 3;
          case 5:
            return 2;
          default:
            return 1;
        }
    }
    switch (len) {
      case 0:
        return 0;
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        return len;
      default:
        if (scheduleState.largestAppointmentCountDay == 0) {
          return 9;
        }
        return 650 ~/ (36 * scheduleState.largestAppointmentCountDay);
    }
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
    return ShiftDataSource(state.getShifts,
        users.map<CalendarResource>((e) => CalendarResource(id: e)).toList());
  }
}
