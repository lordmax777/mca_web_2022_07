import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/comps/simple_popup_menu.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';
import '../scheduling_page.dart';

class MonthlyViewCalendar extends StatefulWidget {
  final DateTime month;

  MonthlyViewCalendar({
    Key? key,
    required this.month,
  }) : super(key: key);

  @override
  State<MonthlyViewCalendar> createState() => _MonthlyViewCalendarState();
}

class _MonthlyViewCalendarState extends State<MonthlyViewCalendar> {
  DateTime get from => firstDayOfMonth(widget.month);

  DateTime get to => lastDayOfMonth(widget.month);

  DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  final Map<String, dynamic> selectedAppointment = <String, dynamic>{};
  bool get isCopyMode => selectedAppointment.isNotEmpty;

  get fetcher => SCFetchShiftsMonthAction(startDate: widget.month);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ScheduleState>(
        converter: (store) => store.state.scheduleState,
        builder: (_, scheduleState) {
          logger(scheduleState.getWeekShifts.length);
          return SfCalendar(
            view: CalendarView.month,
            dataSource: getDataSource(scheduleState),
            monthViewSettings: const MonthViewSettings(
              dayFormat: "EEE",
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
            // maxDate: to,
            viewNavigationMode: ViewNavigationMode.none,
            dragAndDropSettings: const DragAndDropSettings(
              allowScroll: !kDebugMode,
              allowNavigation: !kDebugMode,
            ),
            timeSlotViewSettings: const TimeSlotViewSettings(
              startHour: 0,
              endHour: 1,
            ),
            headerHeight: 0,
            onTap: (calendarTapDetails) {
              switch (calendarTapDetails.targetElement) {
                case CalendarElement.appointment:
                  logger("appointment");
                  break;
                case CalendarElement.calendarCell:
                  logger("calendarCell ${calendarTapDetails.date}");
                  _onAppointmentTap(calendarTapDetails.date!, scheduleState);
                  break;
                default:
                  logger(calendarTapDetails.targetElement);
              }
            },
            onDragEnd: (appointmentDragEndDetails) {
              appStore.dispatch(SCDragEndAction(appointmentDragEndDetails));
            },
            backgroundColor: isCopyMode ? Colors.blue[50] : Colors.white,
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
            //   logger(calendarAppointmentDetails.appointments.toList().length);
            //   return Container(
            //     color: ap.user.userRandomBgColor,
            //     padding: const EdgeInsets.only(left: 8, right: 8),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           ap.user.fullname,
            //           style: TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //         SimplePopupMenuWidget(
            //             menus: [
            //               SimplePopupMenu(
            //                 label: "Copy",
            //                 onTap: () {
            //                   setState(() {
            //                     selectedAppointment['copy'] = ap;
            //                   });
            //                 },
            //               ),
            //               SimplePopupMenu(
            //                 label: "Copy All",
            //                 onTap: () {
            //                   setState(() {
            //                     selectedAppointment['copyAll'] = ap;
            //                   });
            //                 },
            //               ),
            //               SimplePopupMenu(
            //                 label: "Remove",
            //                 onTap: () {
            //                   if (ap.allocation.dateTimeDate != null) {
            //                     appStore.dispatch(SCRemoveAllocationAction(
            //                       fetchAction: fetcher,
            //                       allocation: ap,
            //                     ));
            //                   }
            //                 },
            //               ),
            //             ],
            //             child: const Icon(
            //               Icons.more_vert,
            //               color: Colors.white,
            //               size: 20,
            //             )),
            //       ],
            //     ),
            //   );
            // });
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
    final title = "${location.title ?? "-"} - ${location.locationName}";
    return Tooltip(
      verticalOffset: 10,
      message: title,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: user.userRandomBgColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                    fontFamily: ThemeText.fontFamilyM,
                  ),
            ),
            FittedBox(child: _appActionWidget(ap)),
          ],
        ),
      ),
    );
  }

  Widget _appActionWidget(AppointmentIdMd ap) {
    return SimplePopupMenuWidget(
      menus: getPopupAppointmentMenus(
        onCopy: () => _onCopy(ap),
        onCopyAll: () => _onCopyAll(ap),
        onRemove: () => _onRemove(ap),
      ),
    );
  }

  void _onCopy(AppointmentIdMd ap) {
    setState(() {
      selectedAppointment['copy'] = ap;
    });
  }

  void _onCopyAll(AppointmentIdMd ap) {
    setState(() {
      selectedAppointment['copyAll'] = ap;
    });
  }

  void _onRemove(AppointmentIdMd ap) {
    if (ap.allocation.dateTimeDate != null) {
      appStore.dispatch(SCRemoveAllocationAction(
        fetchAction: fetcher,
        allocation: ap,
      ));
    }
  }

  void _onAppointmentTap(DateTime date, ScheduleState state) async {
    if (selectedAppointment.isEmpty) {
      return;
    }
    AppointmentIdMd? ap = selectedAppointment['copy'];
    bool isAll = false;
    if (ap == null) {
      ap = selectedAppointment['copyAll'];
      isAll = true;
    }
    if (ap == null) {
      return;
    }
    if (ap.allocation.dateTimeDate == null) {
      return;
    }
    // if (date.isBefore(ap.allocation.dateTimeDate!)) {
    //   showError("Cannot copy to a date before the current date");
    //   return;
    // }
    bool? canCopy = false;
    canCopy = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Copy"),
          content: Text(
              "Are you sure you want to copy to ${DateFormat('dd MMM yyyy').format(date)}?"),
          actions: [
            TextButton(
              onPressed: () {
                return Get.back(result: false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                return Get.back(result: true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    canCopy ??= false;
    if (canCopy) {
      logger("$isAll", hint: "isAll");
      if (isAll) {
        appStore.dispatch(SCCopyAllAllocationAction(
          isUserView: false,
          fetchAction: fetcher,
          allocation: ap,
          targetDate: date,
        ));
      } else {
        appStore.dispatch(SCCopyAllocationAction(
          fetchAction: fetcher,
          allocation: ap,
          targetDate: date,
        ));
      }
      selectedAppointment.clear();
    }
  }

  CalendarDataSource getDataSource(ScheduleState state) {
    logger(state.backupShiftsMonth.length);
    return ShiftDataSource(state.backupShiftsMonth, []);
  }
}
