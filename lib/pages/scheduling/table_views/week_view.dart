import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/job_form.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../comps/simple_popup_menu.dart';
import '../../../manager/models/property_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../theme/theme.dart';
import '../models/data_source.dart';
import '../schdule_appointment_drawer.dart';
import '../scheduling_page.dart';

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
              final res = details.resource.id;
              if (res is UserRes) {
                return _userWidget(res);
              }
              return _locWidget(res as PropertiesMd);
            },
            resourceViewSettings: ResourceViewSettings(
              size: CalendarConstants.resourceWidth,
              showAvatar: false,
              visibleResourceCount: CalendarConstants.resourceCount(context),
            ),
            timeSlotViewSettings: TimeSlotViewSettings(
              timeIntervalWidth: MediaQuery.of(context).size.width * .124,
              timelineAppointmentHeight: CalendarConstants.shiftHeight,
              timeFormat: "EEE d MMM",
              timeTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: ThemeText.fontFamilyR,
              ),
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
            onTap: (calendarTapDetails, offset) async {
              switch (calendarTapDetails.targetElement) {
                case CalendarElement.appointment:
                  if (isCopyMode) {
                    //Copy appointment if selected
                    appStore.dispatch(SCOnCopyAllocationTap(
                      calendarTapDetails,
                      selectedAppointment,
                      context,
                      fetcher,
                    ));
                  }
                  final AppointmentIdMd? id =
                      calendarTapDetails.appointments?.first.id;
                  if (id == null) return;
                  // final jobCreated = await showDialog<ApiResponse?>(
                  //     context: context,
                  //     barrierDismissible: kDebugMode,
                  //     builder: (context) => JobEditForm(
                  //         data:
                  //             CreateShiftData(date: calendarTapDetails.date!)));
                  // final shiftRes = await showCreateShiftPopup(
                  //     context,
                  //     CreateShiftData(
                  //       date: calendarTapDetails.date!,
                  //     ));
                  //TODO: Handle shiftRes
                  break;
                case CalendarElement.calendarCell:

                  //Copy appointment if selected
                  if (isCopyMode) {
                    appStore.dispatch(SCOnCopyAllocationTap(
                      calendarTapDetails,
                      selectedAppointment,
                      context,
                      fetcher,
                    ));
                  }

                  //Create shift
                  if (offset != null) {
                    double left = offset.dx;
                    double top = offset.dy - 60;
                    double right = MediaQuery.of(context).size.width - left;
                    double bottom = MediaQuery.of(context).size.height - top;

                    final createTapResult =
                        await showMenu<ScheduleCreatePopupMenus>(
                            context: context,
                            position:
                                RelativeRect.fromLTRB(left, top, right, bottom),
                            items: getPopupCreateMenus());
                    logger(createTapResult, hint: 'Type');
                    logger(calendarTapDetails.date, hint: "Date");
                    if (calendarTapDetails.date == null) return;
                    if (createTapResult == null) return;
                    final jobCreated = await showDialog<ApiResponse?>(
                        context: context,
                        barrierDismissible: kDebugMode,
                        builder: (context) => JobEditForm(
                            data: CreateShiftData(
                                date: calendarTapDetails.date!)));
                    // final shiftRes = await showCreateShiftPopup(
                    //     context,
                    //     CreateShiftData(
                    //       date: calendarTapDetails.date!,
                    //     ));
                    //TODO: Handle shiftRes

                  } else {
                    showError("There was an unexpected error!");
                  }
                  break;
                default:
                  logger(calendarTapDetails.targetElement);
              }
            },
            todayHighlightColor: ThemeColors.transparent,
            allowDragAndDrop: false,
            appointmentBuilder: (_, calendarAppointmentDetails) {
              final appointment = calendarAppointmentDetails.appointments
                  .toList()
                  .first as Appointment?;
              final ap = appointment?.id as AppointmentIdMd?;
              if (ap == null) {
                return const SizedBox();
              }
              final isUserView =
                  state.scheduleState.sidebarType == SidebarType.user;
              return _appWidget(appointment!, context, isUserView: isUserView);
            },
          );
        });
  }

  void _openDrawer(AppState state, Appointment appointment) async {
    appStore.dispatch(UpdateGeneralStateAction(
        endDrawer: AppointmentDrawer(state: state, appointment: appointment)));
    await Future.delayed(const Duration(milliseconds: 100));
    if (Constants.scaffoldKey.currentState != null) {
      if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {
        Constants.scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }

  Widget _appWidget(Appointment appointment, BuildContext context,
      {required bool isUserView}) {
    final ap = appointment.id as AppointmentIdMd;
    final location = ap.property;
    final color = ap.user.userRandomBgColor;
    String title = "${location.title ?? "-"} - ${location.locationName}";
    if (!isUserView) {
      title = ap.user.fullname;
    }
    return Tooltip(
      verticalOffset: 10,
      message: title,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: (details) async {
          logger("onSecondaryTapDown");
          final jobCreated = await showFormsMenus(context,
              globalPosition: details.globalPosition,
              data: CreateShiftData(
                date: appointment.startTime,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: color,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .085,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: ap.user.foregroundColor,
                          fontFamily: ThemeText.fontFamilyM,
                        ),
                  ),
                ),
              ),
              FittedBox(
                  child:
                      _appActionWidget(ap, iconColor: ap.user.foregroundColor)),
            ],
          ),
        ),
      ),
    );
  }

  get fetcher => SCFetchShiftsWeekAction(
        startDate: widget.firstDayOfWeek,
        endDate: widget.lastDayOfWeek,
      );

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
      appStore.dispatch(
        SCRemoveAllocationAction(
          fetchAction: fetcher,
          allocation: ap,
        ),
      );
    }
  }

  Widget _appActionWidget(AppointmentIdMd ap, {required Color iconColor}) {
    return SimplePopupMenuWidget(
      iconColor: iconColor,
      menus: getPopupAppointmentMenus(
        onCopy: () => _onCopy(ap),
        onCopyAll: () => _onCopyAll(ap),
        onRemove: () => _onRemove(ap),
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
                fontWeight: FWeight.bold,
                textColor: user.foregroundColor,
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
