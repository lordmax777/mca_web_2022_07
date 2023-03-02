import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../manager/models/users_list.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';
import 'table_views/day_view.dart';
import 'table_views/week_view.dart';

class SchedulingPage extends StatelessWidget {
  SchedulingPage({Key? key}) : super(key: key);
  DateTime get today => DateTime.now();
  //Day
  DateTime day = DateTime.now();

  //Week
  DateTime firstDayOfWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday));
  DateTime get lastDayOfWeek => firstDayOfWeek.add(const Duration(days: 6));

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) async {
          await appStore.dispatch(SCFetchShiftsAction(date: day));
        },
        builder: (_, state) {
          logger("BUILD SchedulingPage");
          final scheduleState = state.scheduleState;
          final u = [...(state.usersState.usersList.data ?? [])];
          final users = [
            UserRes(
                username: "All",
                loginRequired: false,
                locationAdmin: false,
                lastStatus: "",
                lastName: "All",
                groupAdmin: false,
                fullname: "All",
                firstName: "All",
                id: -1,
                title: ""),
            ...u
          ];
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
                  child: SpacedRow(
                    horizontalSpace: 16.0,
                    children: [
                      if (scheduleState.sidebarType == SidebarType.user &&
                          u.isNotEmpty)
                        DropdownWidget1(
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
                              appStore.dispatch(SCAddFilterUser(p0.item)),
                        ),
                      if (u.isNotEmpty)
                        DropdownWidget1(
                          dropdownOptionsWidth: 150,
                          dropdownBtnWidth: 150,
                          hintText: "Time View",
                          items: [
                            CalendarView.timelineDay.name
                                .replaceAll("timeline", ""),
                            CalendarView.week.name.replaceAll("timeline", ""),
                            CalendarView.timelineMonth.name
                                .replaceAll("timeline", ""),
                          ],
                          objItems: const [
                            CalendarView.timelineDay,
                            CalendarView.week,
                            CalendarView.timelineMonth,
                          ],
                          value: scheduleState.calendarView.name
                              .replaceAll("timeline", ""),
                          onChangedWithObj: (p0) =>
                              appStore.dispatch(SCChangeCalendarView(p0.item)),
                        ),
                      if (scheduleState.calendarView ==
                          CalendarView.timelineDay)
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  day = day.subtract(const Duration(days: 1));
                                  appStore
                                      .dispatch(SCFetchShiftsAction(date: day));
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
                                  appStore
                                      .dispatch(SCFetchShiftsAction(date: day));
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  firstDayOfWeek = firstDayOfWeek
                                      .subtract(const Duration(days: 7));
                                  appStore.dispatch(SCFetchShiftsAction(
                                      date: firstDayOfWeek));
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
                                onPressed: () {
                                  firstDayOfWeek = firstDayOfWeek
                                      .add(const Duration(days: 7));
                                  appStore.dispatch(SCFetchShiftsAction(
                                      date: firstDayOfWeek));
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
                ),
                ErrorWrapper(
                    height: 650,
                    errors: [scheduleState.shifts.error],
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
      case CalendarView.timelineDay:
        return DailyViewCalendar(day: day);
      case CalendarView.week:
        return WeeklyViewCalendar(
            lastDayOfWeek: lastDayOfWeek, firstDayOfWeek: firstDayOfWeek);
      default:
        return DailyViewCalendar(day: day);
      // return MonthlyViewCalendar();
    }
  }
}
