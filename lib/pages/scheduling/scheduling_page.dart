export './models/create_shift_type.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/models/property_md.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/job_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/table_views/full_calendar.dart';
import 'package:mca_web_2022_07/utils/global_functions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../comps/autocomplete_input_field.dart';
import '../../comps/modals/custom_date_picker.dart';
import '../../comps/modals/custom_date_range_picker.dart';
import '../../comps/modals/custom_month_picker.dart';
import '../../comps/simple_popup_menu.dart';
import '../../manager/models/users_list.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../theme/theme.dart';
import 'models/create_shift_type.dart';
import 'models/job_model.dart';
import 'table_views/day_view.dart';
import 'table_views/month_view.dart';
import 'table_views/week_view.dart';

extension TimeExtenstion on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1));
  DateTime get endOfWeek => add(Duration(days: 7 - weekday));
  DateTime get startOfMonth => DateTime(year, month);
  DateTime get endOfMonth =>
      DateTime(year, month + 1).subtract(const Duration(days: 1));

  operator -(Duration other) {
    return subtract(other);
  }

  operator +(Duration other) {
    return add(other);
  }
}

class SchedulingPage extends StatefulWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  State<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  //Day
  DateTime day = DateTime.now();

  //Week
  DateTime firstDayOfWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday));

  DateTime get lastDayOfWeek => firstDayOfWeek.add(const Duration(days: 7));

  // Month
  DateTime firstDayOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await appStore.dispatch(SCFetchShiftsAction(date: day));
      await appStore.dispatch(SCFetchShiftsWeekAction(
          startDate: firstDayOfWeek, endDate: lastDayOfWeek));
      await appStore
          .dispatch(SCFetchShiftsMonthAction(startDate: firstDayOfMonth));
    });
  }

  Widget _usersListDropdown(AppState state) {
    final scheduleState = state.scheduleState;
    final u = [...(state.usersState.usersList.data ?? [])];
    final List<UserRes> users = [UserRes.all(), ...u];
    return Visibility(
      visible: scheduleState.sidebarType == SidebarType.user &&
          u.isNotEmpty &&
          scheduleState.calendarView != CalendarView.month,
      child: CustomAutocompleteTextField<UserRes>(
        height: 50,
        options: (p0) => users
            .where((element) =>
                element.fullname.toLowerCase().contains(p0.text.toLowerCase()))
            .toList(),
        onSelected: (p0) {
          appStore.dispatch(SCAddFilter(user: p0));
        },
        initialValue: TextEditingValue(
          text: scheduleState.filteredUsers.isEmpty
              ? "All"
              : scheduleState.filteredUsers.first.fullname,
        ),
        width: 250,
        hintText: "User",
        displayStringForOption: (p0) => p0.fullname,
        listItemWidget: (p0) {
          return ListTile(
            title: Text(p0.fullname),
            trailing: state.scheduleState.filteredUsers
                    .any((element) => element == p0)
                ? HeroIcon(
                    HeroIcons.check,
                    color: ThemeColors.MAIN_COLOR,
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _locsListDropdown(AppState state) {
    final scheduleState = state.scheduleState;
    final l = [...(state.generalState.properties.data ?? [])];
    final List<PropertiesMd> locs = [PropertiesMd.all(), ...l];
    return Visibility(
      visible: scheduleState.sidebarType == SidebarType.location &&
          l.isNotEmpty &&
          scheduleState.calendarView == CalendarView.week,
      child: CustomAutocompleteTextField<PropertiesMd>(
        height: 50,
        options: (p0) => locs.where((element) {
          final title = element.title.toLowerCase() ?? "";
          final locationName = element.locationName.toLowerCase() ?? "";
          return title.contains(p0.text.toLowerCase()) ||
              locationName.contains(p0.text.toLowerCase());
        }).toList(),
        onSelected: (p0) {
          appStore.dispatch(SCAddFilter(location: p0));
        },
        initialValue: TextEditingValue(
          text: scheduleState.filteredLocations.isEmpty
              ? "All"
              : scheduleState.filteredLocations.first.title ?? "",
        ),
        width: 300,
        hintText: "Location",
        displayStringForOption: (p0) => p0.title ?? "",
        listItemWidget: (p0) {
          return ListTile(
            title: Text(
                p0.title == "All" ? "All" : "${p0.title} - ${p0.locationName}"),
            trailing: state.scheduleState.filteredLocations
                    .any((element) => element == p0)
                ? HeroIcon(
                    HeroIcons.check,
                    color: ThemeColors.MAIN_COLOR,
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _calendarViewsDropdown(AppState state) {
    final scheduleState = state.scheduleState;
    return DropdownWidget1(
        dropdownOptionsWidth: 150,
        dropdownBtnWidth: 150,
        hintText: "Time View",
        items: [
          CalendarView.day.name,
          CalendarView.week.name,
          CalendarView.month.name,
        ],
        objItems: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
        ],
        value: scheduleState.calendarView.name,
        onChangedWithObj: (p0) async {
          appStore.dispatch(SCChangeCalendarView(p0.item));
        });
  }

  Widget _dayDateChanger(AppState state) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ThemeColors.gray10,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              day = day.subtract(const Duration(days: 1));
              appStore.dispatch(SCFetchShiftsAction(date: day));
            },
            icon: const HeroIcon(
              HeroIcons.leftSmall,
              color: ThemeColors.gray2,
              size: 18,
            ),
          ),
          KText(
            isSelectable: false,
            onTap: () async {
              final date =
                  await showCustomDatePicker(context, initialTime: day);
              if (date != null) {
                day = date;
                appStore.dispatch(SCFetchShiftsAction(date: day));
              }
            },
            textAlign: TextAlign.center,
            text: DateFormat("EEE, MMM d").format(day),
            fontSize: 16,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.medium,
          ),
          IconButton(
            onPressed: () {
              day = day.add(const Duration(days: 1));
              appStore.dispatch(SCFetchShiftsAction(date: day));
            },
            icon: const HeroIcon(
              HeroIcons.rightSmall,
              color: ThemeColors.gray2,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekDateChanger(AppState state) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ThemeColors.gray10,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () async {
              firstDayOfWeek = firstDayOfWeek.subtract(const Duration(days: 7));
              await appStore.dispatch(SCFetchShiftsWeekAction(
                startDate: firstDayOfWeek,
                endDate: lastDayOfWeek - const Duration(days: 1),
              ));
            },
            icon: const HeroIcon(
              HeroIcons.leftSmall,
              color: ThemeColors.gray2,
              size: 18,
            ),
          ),
          KText(
            onTap: () async {
              final DateTimeRange? range = await showCustomDateRangePicker(
                context,
                initialDate: firstDayOfWeek,
                initialDateRange: DateTimeRange(
                  start: firstDayOfWeek,
                  end: lastDayOfWeek - const Duration(days: 1),
                ),
              );
              if (range != null) {
                logger("range: ${range.toString()}");
                firstDayOfWeek = range.start;
                await appStore.dispatch(SCFetchShiftsWeekAction(
                  startDate: firstDayOfWeek,
                  endDate: lastDayOfWeek - const Duration(days: 1),
                ));
              }
            },
            isSelectable: false,
            textAlign: TextAlign.center,
            text:
                "${DateFormat("d").format(firstDayOfWeek)}${getDayOfMonthSuffix(int.parse(DateFormat("d").format(firstDayOfWeek)))} - ${DateFormat("d").format(lastDayOfWeek - const Duration(days: 1))}${getDayOfMonthSuffix(int.parse(DateFormat("d").format(lastDayOfWeek)))}${DateFormat(" MMM").format(lastDayOfWeek)}",
            fontSize: 16,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.medium,
          ),
          IconButton(
            onPressed: () async {
              firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
              await appStore.dispatch(SCFetchShiftsWeekAction(
                startDate: firstDayOfWeek,
                endDate: lastDayOfWeek - const Duration(days: 1),
              ));
            },
            icon: const HeroIcon(
              HeroIcons.rightSmall,
              color: ThemeColors.gray2,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthDateChanger(AppState state) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ThemeColors.gray10,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () async {
              firstDayOfMonth =
                  DateTime(firstDayOfMonth.year, firstDayOfMonth.month - 1, 1);
              await appStore.dispatch(
                  SCFetchShiftsMonthAction(startDate: firstDayOfMonth));
            },
            icon: const HeroIcon(
              HeroIcons.leftSmall,
              color: ThemeColors.gray2,
              size: 18,
            ),
          ),
          KText(
            onTap: () async {
              final date = await showCustomMonthPicker(context,
                  initialTime: firstDayOfMonth);
              if (date != null) {
                firstDayOfMonth = date;
                await appStore.dispatch(
                    SCFetchShiftsMonthAction(startDate: firstDayOfMonth));
              }
            },
            isSelectable: false,
            textAlign: TextAlign.center,
            text:
                "${DateFormat("MMM").format(firstDayOfMonth)} ${DateFormat("yyyy").format(firstDayOfMonth)}",
            fontSize: 16,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.medium,
          ),
          IconButton(
            onPressed: () async {
              firstDayOfMonth =
                  DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 1);
              await appStore.dispatch(
                  SCFetchShiftsMonthAction(startDate: firstDayOfMonth));
            },
            icon: const HeroIcon(
              HeroIcons.rightSmall,
              color: ThemeColors.gray2,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resourceChanger(AppState state) {
    final scheduleState = state.scheduleState;
    return ButtonLargeSecondary(
      text: scheduleState.sidebarType == SidebarType.user ? "User" : "Location",
      leftIcon: const HeroIcon(HeroIcons.loop),
      onPressed: () {
        appStore.dispatch(SCChangeSidebarType());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        rebuildOnChange: false,
        converter: (store) => store.state,
        builder: (_, state) {
          final scheduleState = state.scheduleState;

          return PageWrapper(
              child: TableWrapperWidget(
                  child: SizedBox(
            // color: Colors.red,red
            width: double.infinity,
            height: CalendarConstants.fullHeight(context),
            child: SpacedColumn(
              verticalSpace: 16.0,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: PagesTitleWidget(title: "Scheduling"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SpacedRow(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        horizontalSpace: 16.0,
                        children: [
                          // _usersListDropdown(state),
                          // _locsListDropdown(state),
                          // if (u.isNotEmpty) _calendarViewsDropdown(state),
                          // if (scheduleState.calendarView == CalendarView.day)
                          //   _dayDateChanger(state),
                          // if (scheduleState.calendarView == CalendarView.week ||
                          //     scheduleState.calendarView ==
                          //         CalendarView.timelineWeek)
                          //   _weekDateChanger(state),
                          // if (scheduleState.calendarView == CalendarView.month)
                          //   _monthDateChanger(state),
                        ],
                      ),
                      // if (scheduleState.calendarView == CalendarView.week ||
                      //     scheduleState.calendarView ==
                      //         CalendarView.timelineWeek)
                      //   _resourceChanger(state),
                    ],
                  ),
                ),
                ErrorWrapper(
                    height: CalendarConstants.tableHeight(context),
                    errors: [
                      // scheduleState.shifts.error,
                    ],
                    child: SizedBox(
                        height: CalendarConstants.tableHeight(context),
                        child: _getCalendar(scheduleState.calendarView))),
              ],
            ),
          )));
        });
  }

  Widget _getCalendar(CalendarView view) {
    return FullCalendar(day: day);
    switch (view) {
      case CalendarView.day:
        return DailyViewCalendar(day: day);
      case CalendarView.week:
      case CalendarView.timelineWeek:
        return WeeklyViewCalendar(
            lastDayOfWeek: lastDayOfWeek, firstDayOfWeek: firstDayOfWeek);
      case CalendarView.month:
        return MonthlyViewCalendar(month: firstDayOfMonth);
      default:
        return const Center(
          child: Text("Cannot find calendar view"),
        );
      // return MonthlyViewCalendar();
    }
  }
}

List<SimplePopupMenu> getPopupAppointmentMenus({
  VoidCallback? onCopy,
  VoidCallback? onCopyAll,
  VoidCallback? onRemove,
  VoidCallback? onEdit,
  VoidCallback? onCreate,
  String? text,
}) {
  final menus = <SimplePopupMenu>[];
  if (onCreate != null) {
    menus.add(SimplePopupMenu(
      label: "Create${text == null ? "" : " $text"}",
      onTap: onCreate,
      icon: HeroIcons.add,
    ));
  }
  if (onEdit != null) {
    menus.add(SimplePopupMenu(
      label: "Edit${text == null ? "" : " $text"}",
      onTap: onEdit,
      icon: HeroIcons.edit,
    ));
  }

  if (onCopy != null) {
    menus.add(SimplePopupMenu(
      label: "Copy${text == null ? "" : " $text"}",
      onTap: onCopy,
      icon: HeroIcons.clipboard,
    ));
  }
  if (onCopyAll != null) {
    menus.add(SimplePopupMenu(
      label: "Copy All${text == null ? "" : " ${text.toPlural}"}",
      onTap: onCopyAll,
      icon: HeroIcons.clipboardTick,
    ));
  }
  if (onRemove != null) {
    menus.add(SimplePopupMenu(
      label: "Remove${text == null ? "" : " $text"}",
      onTap: onRemove,
      icon: HeroIcons.bin,
    ));
  }

  return menus;
}

enum ScheduleCreatePopupMenus {
  jobNew,
  jobUpdate,
  quote;

  String get label {
    switch (this) {
      case ScheduleCreatePopupMenus.jobNew:
      case ScheduleCreatePopupMenus.jobUpdate:
        return Constants.propertyName;
      case ScheduleCreatePopupMenus.quote:
        return "Quote";
      default:
        return "";
    }
  }
}

List<PopupMenuEntry<ScheduleCreatePopupMenus>> getPopupCreateMenus(
    {bool hasEditJob = false}) {
  return [
    if (hasEditJob)
      PopupMenuItem(
        value: ScheduleCreatePopupMenus.jobUpdate,
        child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          horizontalSpace: 8,
          children: [
            const HeroIcon(
              HeroIcons.edit,
              color: ThemeColors.gray2,
              size: 18,
            ),
            Text("Edit ${Constants.propertyName}"),
          ],
        ),
      ),
    PopupMenuItem(
      value: ScheduleCreatePopupMenus.jobNew,
      child: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 8,
        children: [
          const HeroIcon(
            HeroIcons.briefcase,
            color: ThemeColors.gray2,
            size: 18,
          ),
          Text("New ${Constants.propertyName}"),
        ],
      ),
    ),
  ];
}

Widget addIcon(
    {String? tooltip, VoidCallback? onPressed, HeroIcons? icon, Color? color}) {
  return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (color ?? ThemeColors.MAIN_COLOR)
                  .withOpacity(.5), //Colors.grey[300]!,
            ),
          ),
          child: HeroIcon(
            icon ?? HeroIcons.add,
            color: (color ?? ThemeColors.MAIN_COLOR),
          )));
}

Future<ApiResponse?> showFormsMenus(BuildContext context,
    {required Offset globalPosition, required JobModel data}) async {
  //Positions the menu
  final RenderBox overlay =
      Overlay.of(context)!.context.findRenderObject() as RenderBox;
  Offset off;
  double left;
  double top;
  double right;
  double bottom;
  off = overlay.globalToLocal(globalPosition);
  left = off.dx;
  top = off.dy;
  right = MediaQuery.of(context).size.width - left;
  bottom = MediaQuery.of(context).size.height - top;

  final bool hasEditJob = data.allocation != null;

  //Shows the menu
  final createTapResult = await showMenu<ScheduleCreatePopupMenus>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: getPopupCreateMenus(hasEditJob: hasEditJob));

  logger(createTapResult, hint: "createTapResult");

  if (createTapResult == null) return null;

  //Shows the form based on the menu selected
  switch (createTapResult) {
    case ScheduleCreatePopupMenus.jobUpdate:
      //Shows the form
      final jobCreated = await showDialog<ApiResponse?>(
          context: context,
          barrierDismissible: false,
          builder: (context) => JobEditForm(data: data));
      return jobCreated;
    case ScheduleCreatePopupMenus.jobNew:
      data.allocation = null;
      //Shows the form
      final jobCreated = await showDialog<ApiResponse?>(
          context: context,
          barrierDismissible: false,
          builder: (context) => JobEditForm(data: data));
      return jobCreated;
    case ScheduleCreatePopupMenus.quote:
      return null;
  }
}
