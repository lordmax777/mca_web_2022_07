import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/models/property_md.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../manager/models/location_item_md.dart';
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
      await appStore.dispatch(SCFetchShiftsAction(date: day));
      // await appStore.dispatch(SCFetchShiftsWeekAction(
      //     startDate: firstDayOfWeek, endDate: lastDayOfWeek));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) async {},
        builder: (_, state) {
          final scheduleState = state.scheduleState;
          final u = [...(state.usersState.usersList.data ?? [])];
          final l = [...(state.generalState.properties.data ?? [])];
          final users = [UserRes.all(), ...u];
          final locs = [PropertiesMd.all(), ...l];
          return PageWrapper(
              child: TableWrapperWidget(
                  child: SizedBox(
            width: double.infinity,
            height: 800,
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
                          Visibility(
                            visible:
                                scheduleState.sidebarType == SidebarType.user &&
                                    u.isNotEmpty &&
                                    scheduleState.calendarView !=
                                        CalendarView.month,
                            child: DropdownWidget1(
                              hasSearchBox: true,
                              dropdownOptionsWidth: 250,
                              dropdownBtnWidth: 250,
                              hintText: "User",
                              items: users.map((e) => e.fullname).toList(),
                              objItems: users,
                              customItemIcons: {
                                for (var i = 0;
                                    i < scheduleState.filteredUsers.length;
                                    i++)
                                  users.indexOf(scheduleState.filteredUsers[i]):
                                      HeroIcons.check
                              },
                              value: scheduleState.filteredUsers.isEmpty
                                  ? "All"
                                  : scheduleState.filteredUsers.first.fullname,
                              onChangedWithObj: (p0) =>
                                  appStore.dispatch(SCAddFilter(user: p0.item)),
                            ),
                          ),
                          Visibility(
                            visible: scheduleState.sidebarType ==
                                    SidebarType.location &&
                                l.isNotEmpty &&
                                scheduleState.calendarView == CalendarView.week,
                            child: DropdownWidget1(
                                hasSearchBox: true,
                                dropdownOptionsWidth: 300,
                                dropdownBtnWidth: 300,
                                hintText: "Location",
                                items: locs.map((e) => e.title).toList(),
                                objItems: locs,
                                customItemIcons: {
                                  for (var i = 0;
                                      i <
                                          scheduleState
                                              .filteredLocations.length;
                                      i++)
                                    locs.indexOf(
                                            scheduleState.filteredLocations[i]):
                                        HeroIcons.check
                                },
                                value: scheduleState.filteredLocations.isEmpty
                                    ? "All"
                                    : scheduleState
                                        .filteredLocations.first.title,
                                onChangedWithObj: (p0) {
                                  appStore
                                      .dispatch(SCAddFilter(location: p0.item));
                                }),
                          ),
                          if (u.isNotEmpty)
                            DropdownWidget1(
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
                                  appStore
                                      .dispatch(SCChangeCalendarView(p0.item));
                                }),
                          if (scheduleState.calendarView == CalendarView.day)
                            Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      day =
                                          day.subtract(const Duration(days: 1));
                                      appStore.dispatch(
                                          SCFetchShiftsAction(date: day));
                                    },
                                    icon: const HeroIcon(
                                      HeroIcons.leftSmall,
                                      color: ThemeColors.gray2,
                                      size: 18,
                                    ),
                                  ),
                                  KText(
                                    textAlign: TextAlign.center,
                                    text: DateFormat("EEE, MMM d").format(day),
                                    fontSize: 16,
                                    textColor: ThemeColors.gray2,
                                    fontWeight: FWeight.medium,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      day = day.add(const Duration(days: 1));
                                      appStore.dispatch(
                                          SCFetchShiftsAction(date: day));
                                    },
                                    icon: const HeroIcon(
                                      HeroIcons.rightSmall,
                                      color: ThemeColors.gray2,
                                      size: 18,
                                    ),
                                  ),
                                  // Text(
                                  //   scheduleState.
                                  // )
                                ],
                              ),
                            ),
                          if (scheduleState.calendarView == CalendarView.week)
                            Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      firstDayOfWeek = firstDayOfWeek
                                          .subtract(const Duration(days: 7));
                                      await appStore
                                          .dispatch(SCFetchShiftsWeekAction(
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
                                    textAlign: TextAlign.center,
                                    text:
                                        "${DateFormat("d").format(firstDayOfWeek)}${getDayOfMonthSuffix(int.parse(DateFormat("d").format(firstDayOfWeek)))} - ${DateFormat("d").format(lastDayOfWeek)}${getDayOfMonthSuffix(int.parse(DateFormat("d").format(lastDayOfWeek)))}${DateFormat(" MMM").format(lastDayOfWeek)}",
                                    fontSize: 16,
                                    textColor: ThemeColors.gray2,
                                    fontWeight: FWeight.medium,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      firstDayOfWeek = firstDayOfWeek
                                          .add(const Duration(days: 7));
                                      await appStore
                                          .dispatch(SCFetchShiftsWeekAction(
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
                            ),
                          if (scheduleState.calendarView == CalendarView.month)
                            Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      firstDayOfMonth = DateTime(
                                          firstDayOfMonth.year,
                                          firstDayOfMonth.month - 1,
                                          1);
                                    },
                                    icon: const HeroIcon(
                                      HeroIcons.leftSmall,
                                      color: ThemeColors.gray2,
                                      size: 18,
                                    ),
                                  ),
                                  KText(
                                    textAlign: TextAlign.center,
                                    text:
                                        "${DateFormat("MMM").format(firstDayOfMonth)} ${DateFormat("yyyy").format(firstDayOfMonth)}",
                                    fontSize: 16,
                                    textColor: ThemeColors.gray2,
                                    fontWeight: FWeight.medium,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      firstDayOfMonth = DateTime(
                                          firstDayOfMonth.year,
                                          firstDayOfMonth.month + 1,
                                          1);
                                    },
                                    icon: const HeroIcon(
                                      HeroIcons.rightSmall,
                                      color: ThemeColors.gray2,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (scheduleState.calendarView == CalendarView.week)
                        ButtonLargeSecondary(
                          text: scheduleState.sidebarType == SidebarType.user
                              ? "User"
                              : "Location",
                          leftIcon: const HeroIcon(HeroIcons.loop),
                          onPressed: () {
                            appStore.dispatch(SCChangeSidebarType());
                          },
                        ),
                    ],
                  ),
                ),
                ErrorWrapper(
                    height: 650,
                    errors: [
                      scheduleState.shifts.error,
                    ],
                    child: SizedBox(
                        height: 650,
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
        return WeeklyViewCalendar(
            lastDayOfWeek: lastDayOfWeek, firstDayOfWeek: firstDayOfWeek);
      case CalendarView.month:
        return MonthlyViewCalendar(month: firstDayOfMonth);
      default:
        return const Center(
          child: Text("No calendar view selected"),
        );
      // return MonthlyViewCalendar();
    }
  }
}
