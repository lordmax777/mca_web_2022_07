import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../comps/simple_popup_menu.dart';
import '../../../manager/models/property_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';
import '../schdule_appointment_drawer.dart';

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

  final Map<String, dynamic> selectedAppointment = <String, dynamic>{};

  bool get isCopyMode => selectedAppointment.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ScheduleState>(
        converter: (store) => store.state.scheduleState,
        builder: (_, scheduleState) {
          return SfCalendar(
            view: CalendarView.timelineWeek,
            initialSelectedDate: from,
            initialDisplayDate: from,
            dataSource: getDataSource(scheduleState),
            resourceViewHeaderBuilder: (context, details) {
              final res = details.resource.id;
              if (res is UserRes) {
                return _userWidget(res);
              }
              return _locWidget(res as PropertiesMd);
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
            viewHeaderHeight: 0,
            headerHeight: 0,
            backgroundColor: isCopyMode ? Colors.blue[50] : Colors.white,
            maxDate: to,
            viewNavigationMode: ViewNavigationMode.none,
            dragAndDropSettings: const DragAndDropSettings(
              allowScroll: !kDebugMode,
              allowNavigation: !kDebugMode,
            ),
            onTap: (calendarTapDetails) async {
              switch (calendarTapDetails.targetElement) {
                case CalendarElement.appointment:
                  logger("appointment");
                  appStore.dispatch(UpdateGeneralStateAction(
                      endDrawer: AppointmentDrawer(
                          appointment:
                              calendarTapDetails.appointments!.first)));
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (Constants.scaffoldKey.currentState != null) {
                    if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {
                      Constants.scaffoldKey.currentState!.openEndDrawer();
                    }
                  }
                  break;
                case CalendarElement.calendarCell:
                  var resource = (calendarTapDetails.resource?.id);
                  int? userId;
                  int? shiftId;
                  if (resource is UserRes) {
                    userId = resource.id;
                  } else if (resource is PropertiesMd) {
                    shiftId = resource.id;
                  }
                  if (shiftId == null && userId == null) return;
                  _onAppointmentTap(
                      calendarTapDetails.date!, userId, shiftId, scheduleState);
                  break;
                default:
                  logger(calendarTapDetails.targetElement);
              }
            },
            // onDragEnd: (appointmentDragEndDetails) {
            //   appStore.dispatch(SCDragEndAction(appointmentDragEndDetails));
            // },
            firstDayOfWeek: 1,
            todayHighlightColor: ThemeColors.transparent,
            allowDragAndDrop: false,
            cellEndPadding: 0,
            appointmentBuilder: (_, calendarAppointmentDetails) {
              final appointment = calendarAppointmentDetails.appointments
                  .toList()
                  .first as Appointment?;
              final ap = appointment?.id as AppointmentIdMd?;
              if (ap == null) {
                return const SizedBox();
              }

              final isUserView = scheduleState.sidebarType == SidebarType.user;
              return _appWidget(ap, isUserView, context);
            },
          );
        });
  }

  Widget _appWidget(AppointmentIdMd ap, bool isUserView, BuildContext context) {
    final alloc = ap.property;
    return Tooltip(
      message: (isUserView ? alloc.locationName : ap.user.fullname) ?? "-",
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.transparent,
          border: Border.all(
            color: ThemeColors.gray10,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
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
                  const HeroIcon(HeroIcons.user, size: 16),
                  SizedBox(
                    width: 150,
                    child: KText(
                      isSelectable: false,
                      text: ap.user.fullname,
                      fontSize: 20,
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
                      const HeroIcon(HeroIcons.pin, size: 16),
                      SizedBox(
                        width: 150,
                        child: KText(
                          isSelectable: false,
                          text: alloc.locationName ?? "-",
                          fontSize: 16,
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
                      const HeroIcon(HeroIcons.house, size: 16),
                      SizedBox(
                        width: 150,
                        child: KText(
                          maxLines: 1,
                          isSelectable: false,
                          text: alloc.title ?? "-",
                          fontSize: 16,
                          textColor: ThemeColors.gray2,
                          fontWeight: FWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            SimplePopupMenuWidget(
              menus: [
                SimplePopupMenu(
                  label: "Copy",
                  onTap: () async {
                    setState(() {
                      selectedAppointment['copy'] = ap;
                    });
                    // showError("Now select a date to copy to",
                    //     titleMsg: "Copied.");

                    return;
                    // DateTime? val = await showDatePicker(
                    //   context: context,
                    //   initialDate: DateTime.parse(ap.allocation.date),
                    //   firstDate: DateTime(2015),
                    //   lastDate: DateTime(2035),
                    // );
                    // if (val != null && ap.allocation.dateTimeDate != null) {
                    //   appStore.dispatch(SCCopyAllocationAction(
                    //     fetchAction: SCFetchShiftsWeekAction(
                    //       startDate: widget.firstDayOfWeek,
                    //       endDate: widget.lastDayOfWeek,
                    //     ),
                    //     allocation: ap,
                    //     targetDate: val,
                    //     userId: ap.user.id,
                    //     date: ap.allocation.dateTimeDate!,
                    //   ));
                    // }
                  },
                ),
                SimplePopupMenu(
                  label: "Copy All",
                  onTap: () async {
                    setState(() {
                      selectedAppointment['copyAll'] = ap;
                    });
                    // showError("Now select a date to copy to",
                    //     titleMsg: "Copied.");
                    return;
                    // DateTime? val = await showDatePicker(
                    //   context: context,
                    //   initialDate: DateTime.parse(ap.allocation.date),
                    //   firstDate: DateTime(2015),
                    //   lastDate: DateTime(2035),
                    // );
                    // if (val != null && ap.allocation.dateTimeDate != null) {
                    //   appStore.dispatch(SCCopyAllocationAction(
                    //     fetchAction: SCFetchShiftsWeekAction(
                    //       startDate: widget.firstDayOfWeek,
                    //       endDate: widget.lastDayOfWeek,
                    //     ),
                    //     allocation: ap,
                    //     targetDate: val,
                    //     date: ap.allocation.dateTimeDate!,
                    //   ));
                    // }
                  },
                ),
                SimplePopupMenu(
                  label: "Remove",
                  onTap: () async {
                    if (ap.allocation.dateTimeDate != null) {
                      appStore.dispatch(SCRemoveAllocationAction(
                        fetchAction: SCFetchShiftsWeekAction(
                          startDate: widget.firstDayOfWeek,
                          endDate: widget.lastDayOfWeek,
                        ),
                        allocation: ap,
                      ));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onAppointmentTap(DateTime date, int? targetUserId, int? targtShiftId,
      ScheduleState state) async {
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
    if (date.isBefore(ap.allocation.dateTimeDate!)) {
      showError("Cannot copy to a date before the current date");
      return;
    }
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
          isUserView: state.sidebarType == SidebarType.user,
          fetchAction: SCFetchShiftsWeekAction(
            startDate: widget.firstDayOfWeek,
            endDate: widget.lastDayOfWeek,
          ),
          allocation: ap,
          targetUserId: targetUserId,
          targetShiftId: targtShiftId,
          targetDate: date,
        ));
      } else {
        appStore.dispatch(SCCopyAllocationAction(
          fetchAction: SCFetchShiftsWeekAction(
            startDate: widget.firstDayOfWeek,
            endDate: widget.lastDayOfWeek,
          ),
          allocation: ap,
          targetUserId: targetUserId,
          targetShiftId: targtShiftId,
          targetDate: date,
        ));
      }
      selectedAppointment.clear();
    }
  }

  int visibleResourceCount(ScheduleState scheduleState) {
    final isUserView = scheduleState.sidebarType == SidebarType.user;
    final len = (isUserView
            ? scheduleState.userResources
            : scheduleState.locationResources)
        .length;
    final count = scheduleState.largestAppointmentCountWeek;
    logger("visibleResourceCount: $count");
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
        switch (count) {
          case 0:
          case 1:
            return 9;
          case 2:
          case 3:
            return 3;
          case 4:
            return 2;
          default:
            return 1;
        }
      // if (count == 0) {
      //   return 9;
      // }
      // return 600 ~/ (50 * count);
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
                text: "${location.title} - ${location.locationName}",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                fontWeight: FWeight.bold,
              ),
            ),
          ],
        ));
  }

  CalendarDataSource getDataSource(ScheduleState state) {
    final isUserView = state.sidebarType == SidebarType.user;
    dynamic users = state.userResources;
    if (!isUserView) {
      users = state.locationResources;
    }
    return ShiftDataSource(state.getWeekShifts,
        users.map<CalendarResource>((e) => CalendarResource(id: e)).toList());
  }
}
