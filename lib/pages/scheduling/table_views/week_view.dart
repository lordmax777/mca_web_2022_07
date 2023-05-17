import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
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
import '../models/job_model.dart';
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
          return Stack(
            children: [
              SfCalendar(
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
                  visibleResourceCount:
                      CalendarConstants.resourceCount(context),
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
                  allowScroll: true,
                  allowNavigation: false,
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
                      final AllocationModel? id =
                          calendarTapDetails.appointments?.first.id;
                      if (id == null) return;
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
                        return;
                      }

                      //Create shift
                      if (offset != null) {
                        await showFormsMenus(context,
                            globalPosition: offset,
                            data: JobModel(
                              customStartDate: calendarTapDetails.date,
                              customEndDate: calendarTapDetails.date
                                  ?.add(const Duration(hours: 1)),
                              customResource: calendarTapDetails.resource,
                            ));
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
                  final ap = appointment?.id as AllocationModel?;
                  if (ap == null) {
                    return const SizedBox();
                  }
                  final isUserView =
                      state.scheduleState.sidebarType == SidebarType.user;
                  return _appWidget(appointment!, context,
                      isUserView: isUserView);
                },
              ),
              if (isCopyMode)
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      padding: const EdgeInsets.all(16),
                      icon: const DecoratedBox(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 4,
                                    offset: Offset(0, 2)),
                              ],
                              color: Colors.white),
                          child: Icon(Icons.close)),
                      color: ThemeColors.red3,
                      tooltip: "Cancel copy",
                      iconSize: 48,
                      onPressed: () {
                        setState(() {
                          selectedAppointment.clear();
                        });
                      },
                    )),
            ],
          );
        });
  }

  Widget _appWidget(Appointment appointment, BuildContext context,
      {required bool isUserView}) {
    final ap = appointment.id as AllocationModel;
    final location = ap.property;
    final resource = appointment.resourceIds?.first;
    String title = "${location.title ?? "-"} - ${location.locationName}";
    if (!isUserView) {
      title = ap.user?.fullname ?? "-";
    }
    if (resource is UserRes) {
      if (resource.isOpenShiftResource) {
        title = "(Open Shift) $title";
      }
    }
    final start = ap.dateAsDateTime;
    return Tooltip(
      verticalOffset: 10,
      message: title,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapUp: (details) async {
          await showFormsMenus(context,
              globalPosition: details.globalPosition,
              data: JobModel(
                allocation: ap,
                customStartDate: start,
                // customEndDate: end,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: appointment.color,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .08,
                child: Text(
                  title,
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: ap.user?.foregroundColor,
                        fontFamily: ThemeText.fontFamilyM,
                      ),
                ),
              ),
              FittedBox(
                  child: _appActionWidget(appointment,
                      iconColor: ap.user?.foregroundColor ?? Colors.black)),
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

  void _onCopy(AllocationModel ap) {
    setState(() {
      selectedAppointment['copy'] = ap;
    });
  }

  void _onCopyAll(AllocationModel ap) {
    setState(() {
      selectedAppointment['copyAll'] = ap;
    });
  }

  void _onRemove(AllocationModel ap) {
    appStore.dispatch(
      SCRemoveAllocationAction(
        fetchAction: fetcher,
        allocation: ap,
      ),
    );
  }

  void _onEditJob(Appointment ap) async {
    await showDialog<ApiResponse?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => JobEditForm(
        data: JobModel(
          allocation: ap.id as AllocationModel,
          customStartDate: ap.startTime,
          customEndDate: ap.endTime,
          customResource: ap.resourceIds != null
              ? CalendarResource(id: ap.resourceIds!.first)
              : null,
        ),
      ),
    );
  }

  void _onCreateJob(Appointment? ap) async {
    await showDialog<ApiResponse?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => JobEditForm(
        data: JobModel(
          customStartDate: ap?.startTime,
          customEndDate: ap?.endTime,
          customResource: ap?.resourceIds != null
              ? CalendarResource(id: ap!.resourceIds!.first)
              : null,
        ),
      ),
    );
  }

  Widget _appActionWidget(Appointment? ap, {required Color iconColor}) {
    return SimplePopupMenuWidget(
      iconColor: iconColor,
      menus: getPopupAppointmentMenus(
        text: Constants.propertyName,
        onCopy: ap == null ? null : () => _onCopy(ap.id as AllocationModel),
        onCopyAll:
            ap == null ? null : () => _onCopyAll(ap.id as AllocationModel),
        onRemove: ap == null ? null : () => _onRemove(ap.id as AllocationModel),
        onEdit: ap == null ? null : () => _onEditJob(ap),
        onCreate: () => _onCreateJob(ap),
      ),
    );
  }

  Widget _userWidget(UserRes user) {
    return Container(
        decoration: BoxDecoration(
          border: const Border(
            right: BorderSide(
              color: ThemeColors.gray11,
              width: 1,
            ),
            bottom: BorderSide(
              color: ThemeColors.gray11,
              width: 1,
            ),
          ),
          color: user.isOpenShiftResource ? Colors.lime[200]! : null,
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
    } else {
      users = [UserRes.openShiftResource(), ...users];
    }
    return ShiftDataSource(state.getWeekShifts,
        users.map<CalendarResource>((e) => CalendarResource(id: e)).toList());
  }
}
