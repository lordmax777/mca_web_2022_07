import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../manager/models/property_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';

class MonthlyViewCalendar extends StatelessWidget {
  final DateTime month;

  const MonthlyViewCalendar({
    Key? key,
    required this.month,
  }) : super(key: key);

  DateTime get from => firstDayOfMonth(month);

  DateTime get to => lastDayOfMonth(month);

  DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ScheduleState>(
        converter: (store) => store.state.scheduleState,
        builder: (_, scheduleState) {
          return SfCalendar(
            view: CalendarView.month,
            dataSource: getDataSource(scheduleState),
            monthViewSettings: const MonthViewSettings(
              dayFormat: "EEE",
            ),
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
                  logger("calendarCell ${calendarTapDetails.appointments}");
                  break;
                default:
                  logger(calendarTapDetails.targetElement);
              }
            },
            onDragEnd: (appointmentDragEndDetails) {
              appStore.dispatch(SCDragEndAction(appointmentDragEndDetails));
            },
            firstDayOfWeek: 1,
            allowDragAndDrop: false,
            todayHighlightColor: ThemeColors.gray8,

            // appointmentBuilder: (_, calendarAppointmentDetails) {
            //   final appointment = calendarAppointmentDetails.appointments
            //       .toList()
            //       .first as Appointment?;
            //   final ap = appointment?.id as AppointmentIdMd?;
            //   if (ap == null) {
            //     return const SizedBox();
            //   }
            //
            //   final isUserView = scheduleState.sidebarType == SidebarType.user;
            //   // final count = scheduleState.countSameShiftStartDate(appointment!);
            //   return _appWidget(ap, 8, isUserView);
            // },
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
                      if (isLarge) HeroIcon(HeroIcons.pin, size: 12 / count),
                      SizedBox(
                        width: 150,
                        child: KText(
                          isSelectable: false,
                          text: alloc.title ?? "-",
                          fontSize: 12 / count,
                          maxLines: 1,
                          textColor: ThemeColors.gray2,
                          fontWeight: FWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (isLarge)
                    SpacedRow(
                      mainAxisSize: MainAxisSize.min,
                      horizontalSpace: 4,
                      children: [
                        HeroIcon(HeroIcons.house, size: 12 / count),
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
                iconSize: 24 / count,
                onPressed: () async {},
                icon: const HeroIcon(
                  HeroIcons.moreVertical,
                  color: ThemeColors.gray2,
                )),
          ],
        ),
      ),
    );
  }

  CalendarDataSource getDataSource(ScheduleState state) {
    return ShiftDataSource(state.getWeekShifts, []);
  }
}
