import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
            resourceViewHeaderBuilder: (context, details) {
              final user = details.resource.id as UserRes;
              return _userWidget(user);
            },
            resourceViewSettings: ResourceViewSettings(
              size: 300,
              visibleResourceCount: visibleResourceCount(scheduleState),
            ),
            dataSource: getDataSource(scheduleState),
            timeSlotViewSettings: TimeSlotViewSettings(
              timeIntervalWidth: 80,
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
            onTap: (calendarTapDetails) {
              // int userCountPerShift = 1;
              // for (int i = 0;
              //     i < scheduleState.shifts.data![CalendarView.day]!.length;
              //     i++) {
              //   if (scheduleState.shifts.data![CalendarView.day]![i].id ==
              //       calendarTapDetails.appointments!.first.id) {
              //     userCountPerShift += 1;
              //   }
              // }
              // logger("userCountPerShift: $userCountPerShift");
            },
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
              final user = ap.user;
              final location = ap.location;
              //TODO: To enable tooltip, comment the below code and use Tooltip widget
              // padding: const EdgeInsets.all(4),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              // border: Border.all(
              //   width: 1,
              //   color: ThemeColors.gray10,
              // ),
              // ),
              // richMessage: TextSpan(children: [
              //   WidgetSpan(
              //       child: SizedBox(
              //     width: 300,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         KText(
              //           isSelectable: false,
              //           text:
              //               "${DateFormat('ha').format(appointment!.startTime)} - ${DateFormat('ha').format(appointment.endTime)}",
              //           fontSize: 12,
              //           fontWeight: FWeight.bold,
              //         ),
              //         KText(
              //           isSelectable: false,
              //           text: location.name ?? "-",
              //           fontSize: 12,
              //           fontWeight: FWeight.bold,
              //         ),
              //       ],
              //     ),
              //   )),
              // ]),
              return Tooltip(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: user.userRandomBgColor,
                  border: Border.all(
                    width: 1,
                    color: ThemeColors.gray10,
                  ),
                ),
                richMessage: TextSpan(children: [
                  WidgetSpan(
                      child: SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          isSelectable: false,
                          text:
                              "${DateFormat('h:mm a').format(appointment!.startTime)} - ${DateFormat('h:mm a').format(appointment.endTime)}",
                          fontSize: 12,
                          fontWeight: FWeight.bold,
                        ),
                        KText(
                          isSelectable: false,
                          text: location.name ?? "-",
                          fontSize: 12,
                          fontWeight: FWeight.bold,
                        ),
                      ],
                    ),
                  )),
                ]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: user.userRandomBgColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            isSelectable: false,
                            text:
                                "${DateFormat('h:mm a').format(appointment.startTime)} - ${DateFormat('h:mm a').format(appointment.endTime)}",
                            fontSize: 12,
                            fontWeight: FWeight.bold,
                          ),
                          KText(
                            isSelectable: false,
                            text: location.name ?? "-",
                            fontSize: 12,
                            fontWeight: FWeight.bold,
                          ),
                        ],
                      ),
                      IconButton(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(0.0),
                          onPressed: () async {},
                          icon: const HeroIcon(
                            HeroIcons.moreVertical,
                            size: 24.0,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  int visibleResourceCount(ScheduleState scheduleState) {
    final len = scheduleState.users.length;
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
        return 9;
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
    return ShiftDataSource(state.getShifts, state.users);
  }
}
