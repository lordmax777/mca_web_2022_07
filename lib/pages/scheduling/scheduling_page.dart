import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/models/property_md.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:mca_web_2022_07/pages/scheduling/calendar_constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../comps/modals/custom_date_picker.dart';
import '../../comps/modals/custom_date_range_picker.dart';
import '../../comps/modals/custom_month_picker.dart';
import '../../comps/simple_popup_menu.dart';
import '../../manager/models/users_list.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';
import 'table_views/day_view.dart';
import 'table_views/month_view.dart';
import 'table_views/week_view.dart';

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
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  DateTime get lastDayOfWeek => firstDayOfWeek.add(const Duration(days: 6));

  // Month
  DateTime firstDayOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // appStore.dispatch(SCFetchShiftsAction(date: day));
      // appStore.dispatch(SCFetchShiftsWeekAction(
      //     startDate: firstDayOfWeek, endDate: lastDayOfWeek));
      // appStore.dispatch(SCFetchShiftsMonthAction(startDate: firstDayOfMonth));
    });
  }

  Widget _usersListDropdown(AppState state) {
    final scheduleState = state.scheduleState;
    final u = [...(state.usersState.usersList.data ?? [])];
    final users = [UserRes.all(), ...u];
    return Visibility(
      visible: scheduleState.sidebarType == SidebarType.user &&
          u.isNotEmpty &&
          scheduleState.calendarView != CalendarView.month,
      child: DropdownWidget1(
        hasSearchBox: true,
        dropdownOptionsWidth: 250,
        dropdownBtnWidth: 250,
        hintText: "User",
        items: users.map((e) => e.fullname).toList(),
        objItems: users,
        customItemIcons: {
          for (var i = 0; i < scheduleState.filteredUsers.length; i++)
            users.indexOf(scheduleState.filteredUsers[i]): HeroIcons.check
        },
        value: scheduleState.filteredUsers.isEmpty
            ? "All"
            : scheduleState.filteredUsers.first.fullname,
        onChangedWithObj: (p0) => appStore.dispatch(SCAddFilter(user: p0.item)),
      ),
    );
  }

  Widget _locsListDropdown(AppState state) {
    final scheduleState = state.scheduleState;
    final l = [...(state.generalState.properties.data ?? [])];
    final locs = [PropertiesMd.all(), ...l];
    return Visibility(
      visible: scheduleState.sidebarType == SidebarType.location &&
          l.isNotEmpty &&
          scheduleState.calendarView == CalendarView.week,
      child: DropdownWidget1(
          hasSearchBox: true,
          dropdownOptionsWidth: 300,
          dropdownBtnWidth: 300,
          hintText: "Location",
          items: locs.map((e) => "${e.title}").toList(),
          objItems: locs,
          customItemIcons: {
            for (var i = 0; i < scheduleState.filteredLocations.length; i++)
              locs.indexOf(scheduleState.filteredLocations[i]): HeroIcons.check
          },
          value: scheduleState.filteredLocations.isEmpty
              ? "All"
              : scheduleState.filteredLocations.first.title,
          onChangedWithObj: (p0) {
            appStore.dispatch(SCAddFilter(location: p0.item));
          }),
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
          // CalendarView.timelineWeek.name,
          CalendarView.month.name,
        ],
        objItems: const [
          CalendarView.day,
          CalendarView.week,
          // CalendarView.timelineWeek,
          CalendarView.month,
        ],
        value: scheduleState.calendarView.name,
        onChangedWithObj: (p0) async {
          // if (p0.item == CalendarView.timelineWeek) {
          //   //Subtract 2 weeks from firstDayOfWeek
          //   firstDayOfWeek = firstDayOfWeek.subtract(const Duration(days: 14));
          // }
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
              final date = await showCustomDatePicker(context);
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
                endDate: lastDayOfWeek,
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
                  end: lastDayOfWeek,
                ),
              );
              if (range != null) {
                logger("range: ${range.toString()}");
                firstDayOfWeek = range.start;
                await appStore.dispatch(SCFetchShiftsWeekAction(
                  startDate: firstDayOfWeek,
                  endDate: lastDayOfWeek,
                ));
              }
            },
            isSelectable: false,
            textAlign: TextAlign.center,
            text:
                "${DateFormat("d").format(firstDayOfWeek)}${getDayOfMonthSuffix(int.parse(DateFormat("d").format(firstDayOfWeek)))} - ${DateFormat("d").format(lastDayOfWeek)}${getDayOfMonthSuffix(int.parse(DateFormat("d").format(lastDayOfWeek)))}${DateFormat(" MMM").format(lastDayOfWeek)}",
            fontSize: 16,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.medium,
          ),
          IconButton(
            onPressed: () async {
              firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
              await appStore.dispatch(SCFetchShiftsWeekAction(
                startDate: firstDayOfWeek,
                endDate: lastDayOfWeek,
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
              final date = await showCustomMonthPicker(context);
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
        converter: (store) => store.state,
        onInit: (store) async {},
        builder: (_, state) {
          final scheduleState = state.scheduleState;

          return PageWrapper(
              child: TableWrapperWidget(
                  child: SizedBox(
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
                        horizontalSpace: 16.0,
                        children: [
                          _usersListDropdown(state),
                          _locsListDropdown(state),
                          if (u.isNotEmpty) _calendarViewsDropdown(state),
                          if (scheduleState.calendarView == CalendarView.day)
                            _dayDateChanger(state),
                          if (scheduleState.calendarView == CalendarView.week ||
                              scheduleState.calendarView ==
                                  CalendarView.timelineWeek)
                            _weekDateChanger(state),
                          if (scheduleState.calendarView == CalendarView.month)
                            _monthDateChanger(state),
                        ],
                      ),
                      if (scheduleState.calendarView == CalendarView.week ||
                          scheduleState.calendarView ==
                              CalendarView.timelineWeek)
                        _resourceChanger(state),
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

List<SimplePopupMenu> getPopupAppointmentMenus(
    {VoidCallback? onCopy,
    VoidCallback? onCopyAll,
    VoidCallback? onRemove,
    VoidCallback? onEdit}) {
  final menus = <SimplePopupMenu>[];

  if (onCopy != null) {
    menus.add(SimplePopupMenu(
      label: "Copy",
      onTap: onCopy,
    ));
  }
  if (onCopyAll != null) {
    menus.add(SimplePopupMenu(
      label: "Copy All",
      onTap: onCopyAll,
    ));
  }
  if (onRemove != null) {
    menus.add(SimplePopupMenu(
      label: "Remove",
      onTap: onRemove,
    ));
  }
  if (onEdit != null) {
    menus.add(SimplePopupMenu(
      label: "Edit",
      onTap: onEdit,
    ));
  }
  return menus;
}

enum ScheduleCreatePopupMenus {
  job,
}

List<PopupMenuEntry<ScheduleCreatePopupMenus>> getPopupCreateMenus() {
  return [
    PopupMenuItem(
      value: ScheduleCreatePopupMenus.job,
      child: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 8,
        children: const [
          HeroIcon(
            HeroIcons.briefcase,
            color: ThemeColors.gray2,
            size: 18,
          ),
          Text("New Job"),
        ],
      ),
    ),
  ];
}
