import 'package:flutter_redux/flutter_redux.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/models/location_item_md.dart';
import '../../../manager/models/property_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';

class WeeklyViewCalendar extends StatelessWidget {
  final DateTime firstDayOfWeek;
  final DateTime lastDayOfWeek;

  const WeeklyViewCalendar(
      {Key? key, required this.lastDayOfWeek, required this.firstDayOfWeek})
      : super(key: key);

  DateTime get from => firstDayOfWeek;

  DateTime get to => lastDayOfWeek;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          final scheduleState = state.scheduleState;
          return SfCalendar(
            view: CalendarView.timelineWeek,
            initialSelectedDate: from,
            initialDisplayDate: from,
            dataSource: getDataSource(scheduleState),
            resourceViewHeaderBuilder: (context, details) {
              final user = details.resource.id as UserRes;
              return _userWidget(user);
            },
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
            headerHeight: 0,
            viewHeaderHeight: 0,
            minDate: from.subtract(const Duration(days: 1)),
            maxDate: to,
            viewNavigationMode: ViewNavigationMode.snap,
            dragAndDropSettings: const DragAndDropSettings(
              allowScroll: true,
              allowNavigation: true,
            ),
            onTap: (calendarTapDetails) {
              logger((calendarTapDetails.resource?.id as UserRes).id,
                  hint: 'source');
            },
            onDragEnd: (appointmentDragEndDetails) {
              appStore.dispatch(SCDragEndAction(appointmentDragEndDetails));
            },
            firstDayOfWeek: 1,
            todayHighlightColor: ThemeColors.transparent,
            allowDragAndDrop: true,
            cellEndPadding: 0,
            appointmentBuilder: (_, calendarAppointmentDetails) {
              final appointment = calendarAppointmentDetails.appointments
                  .toList()
                  .first as Appointment?;
              final ap = appointment?.id as AppointmentIdMd?;
              if (ap == null) {
                return const SizedBox();
              }
              final count =
                  scheduleState.countSameShiftStartDateCount(appointment!);
              return _appWidget(ap, count);
            },
          );
        });
  }

  Widget _appWidget(AppointmentIdMd ap, int count) {
    final location = ap.location;
    final alloc = ap.property;
    final bool isLarge = count == 1;
    return Tooltip(
      message: location.name ?? "-",
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
            horizontal: 16.0, vertical: !isLarge ? 2.0 : 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        text: location.name ?? "-",
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
    return ShiftDataSource(state.getWeekShifts, state.users);
  }
}
