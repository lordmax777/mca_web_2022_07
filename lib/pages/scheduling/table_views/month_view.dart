import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/comps/simple_popup_menu.dart';
import 'package:mca_web_2022_07/pages/scheduling/table_views/week_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../theme/theme.dart';
import '../models/allocation_model.dart';
import '../models/data_source.dart';
import '../models/job_model.dart';
import '../popup_forms/job_form.dart';
import '../scheduling_page.dart';

class MonthlyViewCalendar extends StatefulWidget {
  final DateTime month;

  const MonthlyViewCalendar({
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
          return Stack(
            children: [
              SfCalendar(
                view: CalendarView.month,
                dataSource: getDataSource(scheduleState),
                initialSelectedDate: from,
                initialDisplayDate: from,
                monthViewSettings: const MonthViewSettings(
                  dayFormat: "EEE",
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
                viewNavigationMode: ViewNavigationMode.none,
                dragAndDropSettings: const DragAndDropSettings(
                  allowScroll: true,
                  allowNavigation: true,
                ),
                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 0,
                  endHour: 1,
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
                maxDate: to,
                headerHeight: 0,
                onDragEnd: (appointmentDragEndDetails) {
                  appStore.dispatch(SCDragEndAction(appointmentDragEndDetails));
                },
                backgroundColor: isCopyMode ? Colors.blue[50] : Colors.white,
                firstDayOfWeek: 1,
                allowDragAndDrop: false,
                todayHighlightColor: ThemeColors.gray8,
                appointmentBuilder: (_, calendarAppointmentDetails) {
                  final appointment = calendarAppointmentDetails.appointments
                      .toList()
                      .first as Appointment?;
                  final ap = appointment?.id as AllocationModel?;
                  if (ap == null) {
                    return const SizedBox();
                  }
                  return _appWidget(appointment!, context);
                },
              ),
              if (isCopyMode)
                cancelCopyWidget(() {
                  setState(() {
                    selectedAppointment.clear();
                  });
                }),
            ],
          );
        });
  }

  Widget _appWidget(Appointment appointment, BuildContext context) {
    final ap = appointment.id as AllocationModel;
    final location = ap.property;
    final title = "${location.title ?? "-"} - ${location.locationName}";
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
                width: MediaQuery.of(context).size.width * 0.1,
                child: Text(
                  title,
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
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

  Widget _appActionWidget(Appointment? ap, {required Color iconColor}) {
    return SimplePopupMenuWidget(
      menus: getPopupAppointmentMenus(
        onCopy: ap == null ? null : () => _onCopy(ap.id as AllocationModel),
        onCopyAll:
            ap == null ? null : () => _onCopyAll(ap.id as AllocationModel),
        onRemove: ap == null ? null : () => _onRemove(ap.id as AllocationModel),
        onEdit: ap == null
            ? null
            : (ap.resourceIds!.first as UserRes).isOpenShiftResource
                ? null
                : () => _onEditJob(ap),
        onCreate: () => _onCreateJob(ap),
      ),
    );
  }

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
        SCRemoveAllocationAction(fetchAction: fetcher, allocation: ap));
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
          customResource: CalendarResource(id: ap.resourceIds!.first),
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
              ? ap!.resourceIds!.first is UserRes
                  ? CalendarResource(id: ap.resourceIds!.first)
                  : null
              : null,
        ),
      ),
    );
  }

  CalendarDataSource getDataSource(ScheduleState state) {
    logger(state.getMonthShifts.length);
    return ShiftDataSource(state.getMonthShifts, []);
  }
}
