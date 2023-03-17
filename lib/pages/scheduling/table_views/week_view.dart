import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/models/location_item_md.dart';
import '../../../manager/models/property_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';

class WeeklyViewCalendar extends StatefulWidget {
  final DateTime firstDayOfWeek;
  final DateTime lastDayOfWeek;

  const WeeklyViewCalendar(
      {Key? key, required this.lastDayOfWeek, required this.firstDayOfWeek})
      : super(key: key);

  @override
  State<WeeklyViewCalendar> createState() => _WeeklyViewCalendarState();
}

class _WeeklyViewCalendarState extends State<WeeklyViewCalendar> {
  DateTime get from => widget.firstDayOfWeek;

  DateTime get to => widget.lastDayOfWeek;

  final CalendarController controller = CalendarController();

  final ShiftDataSource _source = ShiftDataSource(<AppointmentIdMd1>[], null);

  @override
  void initState() {
    controller.view = CalendarView.timelineWeek;
    controller.selectedDate = to.subtract(from.difference(to));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          final scheduleState = state.scheduleState;
          return SfCalendar(
            controller: controller,
            view: controller.view ?? CalendarView.timelineWeek,
            initialSelectedDate: from,
            initialDisplayDate: from,
            dataSource: _source,
            resourceViewHeaderBuilder: (context, details) {
              final res = details.resource.id;
              if (res is UserRes) {
                return _userWidget(res);
              }
              return _locWidget(res as PropertiesMd);
            },
            showNavigationArrow: true,
            showDatePickerButton: true,
            showCurrentTimeIndicator: false,
            showWeekNumber: false,
            resourceViewSettings: ResourceViewSettings(
              size: 300,
              visibleResourceCount: visibleResourceCount(scheduleState),
            ),
            timeSlotViewSettings: const TimeSlotViewSettings(
              timeIntervalWidth: 250,
              timeFormat: "EEE d MMM",
              timeTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: ThemeText.fontFamilyR,
              ),
              timeIntervalHeight: 40,
              timeRulerSize: 40,
              startHour: 0,
              endHour: 1,
            ),
            viewHeaderHeight: 0,
            loadMoreWidgetBuilder: (context, loadMoreAppointments) {
              return FutureBuilder<void>(
                future: loadMoreAppointments(),
                builder: (context, snapShot) {
                  return Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator());
                },
              );
            },
            minDate: from.subtract(const Duration(days: 1)),
            maxDate: to,
            viewNavigationMode: ViewNavigationMode.snap,
            dragAndDropSettings: const DragAndDropSettings(
              allowScroll: !kDebugMode,
              allowNavigation: !kDebugMode,
            ),
            onTap: (calendarTapDetails) {
              switch (calendarTapDetails.targetElement) {
                case CalendarElement.appointment:
                  logger("appointment");
                  break;
                case CalendarElement.calendarCell:
                  logger("calendarCell");
                  break;
                default:
                  logger(calendarTapDetails.targetElement);
              }
            },
            onDragEnd: (appointmentDragEndDetails) {
              appStore.dispatch(SCDragEndAction(appointmentDragEndDetails));
            },
            firstDayOfWeek: 1,
            todayHighlightColor: ThemeColors.transparent,
            allowDragAndDrop: false,
            cellEndPadding: 0,
            appointmentBuilder: (_, calendarAppointmentDetails) {
              final appointment = calendarAppointmentDetails.appointments
                  .toList()
                  .first as AppointmentIdMd1?;
              final ap = appointment;
              if (ap == null) {
                return const SizedBox();
              }
              final isUserView =
                  state.scheduleState.sidebarType == SidebarType.user;
              final count = scheduleState.countSameShiftStartDate(appointment!);
              return _appWidget(ap, count, isUserView);
            },
          );
        });
  }

  Widget _appWidget(AppointmentIdMd ap, int count, bool isUserView) {
    final alloc = ap.property;
    final bool isLarge = count == 1;
    return Tooltip(
      message: alloc.title ?? "-",
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.transparent,
          border: Border.all(
            color: ThemeColors.gray10,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 16.0, vertical: !isLarge ? 0.0 : 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isUserView)
              SpacedRow(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                horizontalSpace: 4,
                children: [
                  HeroIcon(HeroIcons.user, size: 16 / count),
                  SizedBox(
                    width: 150,
                    child: KText(
                      isSelectable: false,
                      text: ap.user.fullname,
                      fontSize: 20 / count,
                      maxLines: 1,
                      textColor: ThemeColors.gray2,
                      fontWeight: FWeight.bold,
                    ),
                  ),
                ],
              ),
            if (isUserView)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SpacedRow(
                    mainAxisSize: MainAxisSize.min,
                    horizontalSpace: 4,
                    children: [
                      HeroIcon(HeroIcons.pin, size: 16 / count),
                      SizedBox(
                        width: 150,
                        child: KText(
                          isSelectable: false,
                          text: alloc.title ?? "-",
                          fontSize: 14 / count,
                          maxLines: 1,
                          textColor: ThemeColors.gray2,
                          fontWeight: FWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SpacedRow(
                    mainAxisSize: MainAxisSize.min,
                    horizontalSpace: 4,
                    children: [
                      HeroIcon(HeroIcons.house, size: 16 / count),
                      SizedBox(
                        width: 150,
                        child: KText(
                          maxLines: 1,
                          isSelectable: false,
                          text: alloc.title ?? "-",
                          fontSize: 14 / count,
                          textColor: ThemeColors.gray2,
                          fontWeight: FWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            IconButton(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(0.0),
                iconSize: 24,
                onPressed: () async {},
                icon: const HeroIcon(
                  HeroIcons.moreVertical,
                  size: 24.0,
                  color: ThemeColors.gray2,
                )),
          ],
        ),
      ),
    );
  }

  int visibleResourceCount(ScheduleState scheduleState) {
    final isUserView = scheduleState.sidebarType == SidebarType.user;
    final len = (isUserView
            ? scheduleState.userResources
            : scheduleState.locationResources)
        .length;
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
        return 4;
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

  Widget _locWidget(PropertiesMd location) {
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
            const CircleAvatar(
              backgroundColor: ThemeColors.blue7,
              maxRadius: 24.0,
              child: HeroIcon(
                HeroIcons.pin,
                size: 24.0,
                color: ThemeColors.white,
              ),
            ),
            const SizedBox(width: 16.0),
            SizedBox(
              width: 200,
              child: KText(
                isSelectable: false,
                maxLines: 2,
                text: location.title,
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                fontWeight: FWeight.bold,
              ),
            ),
          ],
        ));
  }
}
