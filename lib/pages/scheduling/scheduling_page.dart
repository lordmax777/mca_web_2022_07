import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../manager/models/users_list.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class SchedulingPage extends StatelessWidget {
  SchedulingPage({Key? key}) : super(key: key);

  DateTime date = DateTime.now().subtract(const Duration(days: 28));

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) async {
          await appStore.dispatch(SCFetchShiftsAction(date: date));
          print("SchedulingPage onInitialBuild");
        },
        builder: (_, state) {
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
                            CalendarView.timelineWeek.name
                                .replaceAll("timeline", ""),
                            CalendarView.timelineMonth.name
                                .replaceAll("timeline", ""),
                          ],
                          objItems: const [
                            CalendarView.timelineDay,
                            CalendarView.timelineWeek,
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
                                  date = date.subtract(const Duration(days: 1));
                                  appStore.dispatch(
                                      SCFetchShiftsAction(date: date));
                                },
                                icon: const HeroIcon(
                                  HeroIcons.leftSmall,
                                  color: ThemeColors.gray2,
                                  size: 18,
                                ),
                              ),
                              KText(
                                textAlign: TextAlign.center,
                                text: DateFormat.yMMMMd("en_US").format(date),
                                fontSize: 16,
                                textColor: ThemeColors.gray2,
                                fontWeight: FWeight.medium,
                              ),
                              IconButton(
                                onPressed: () {
                                  date = date.add(const Duration(days: 1));
                                  appStore.dispatch(
                                      SCFetchShiftsAction(date: date));
                                },
                                icon: const HeroIcon(
                                  HeroIcons.rightSmall,
                                  color: ThemeColors.gray2,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                ErrorWrapper(
                    height: 650,
                    errors: [scheduleState.shifts.error],
                    child: SizedBox(height: 650, child: DailyViewCalendar())),
              ],
            ),
          )));
        });
  }
}

class DailyViewCalendar extends StatelessWidget {
  DailyViewCalendar({Key? key}) : super(key: key);

  final date = DateTime.now().subtract(const Duration(days: 28));

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          final scheduleState = state.scheduleState;
          final interval = scheduleState.interval;
          return SfCalendar(
            view: CalendarView.timelineDay,
            resourceViewHeaderBuilder: (context, details) {
              final user = details.resource.id as UserRes;
              return _userWidget(user);
            },
            resourceViewSettings: ResourceViewSettings(
              size: 300,
              visibleResourceCount: visibleResourceCount(scheduleState),
              showAvatar: false,
            ),
            dataSource: getDataSource(scheduleState),
            timeSlotViewSettings: TimeSlotViewSettings(
              timeIntervalWidth: 80,
              timeInterval: Duration(minutes: interval),
              timeFormat: "h:mm a",
              timeTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: ThemeText.fontFamilyR,
              ),
            ),
            headerHeight: 0,
            viewHeaderHeight: 0, //0
            viewNavigationMode: ViewNavigationMode.none,
            dragAndDropSettings: const DragAndDropSettings(
              allowScroll: true,
              allowNavigation: false,
            ),
            onSelectionChanged: (calendarSelectionDetails) {
              logger(calendarSelectionDetails.date, hint: 'Date');
              logger(calendarSelectionDetails.resource, hint: 'RESOURCE');
            },
            initialSelectedDate: date,
            initialDisplayDate: date,
            todayHighlightColor: Colors.transparent,
            allowDragAndDrop: false,
            appointmentBuilder: (_, calendarAppointmentDetails) {
              final appointment = calendarAppointmentDetails.appointments
                  .toList()
                  .first as Appointment?;
              final ap = appointment?.id as AppointmentIdMd?;
              if (ap == null) {
                return const SizedBox();
              }
              final user = ap.user;
              final location = ap.location;
              //TODO: To enable tooltip, comment the below code and use Tooltip widget
              // padding: const EdgeInsets.all(4),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              // border: Border.all(
              //   width: 1,
              //   color: ThemeColors.gray10,
              // ),
              // ),
              // richMessage: TextSpan(children: [
              //   WidgetSpan(
              //       child: SizedBox(
              //     width: 300,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         KText(
              //           isSelectable: false,
              //           text:
              //               "${DateFormat('ha').format(appointment!.startTime)} - ${DateFormat('ha').format(appointment.endTime)}",
              //           fontSize: 12,
              //           fontWeight: FWeight.bold,
              //         ),
              //         KText(
              //           isSelectable: false,
              //           text: location.name ?? "-",
              //           fontSize: 12,
              //           fontWeight: FWeight.bold,
              //         ),
              //       ],
              //     ),
              //   )),
              // ]),
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: user.userRandomBgColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          isSelectable: false,
                          text:
                              "${DateFormat('h:m a').format(appointment!.startTime)} - ${DateFormat('h:m a').format(appointment.endTime)}",
                          fontSize: 12,
                          fontWeight: FWeight.bold,
                        ),
                        KText(
                          isSelectable: false,
                          text: location.name ?? "-",
                          fontSize: 12,
                          fontWeight: FWeight.bold,
                        ),
                      ],
                    ),
                    IconButton(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () async {},
                        icon: const HeroIcon(
                          HeroIcons.moreVertical,
                          size: 24.0,
                          color: Colors.white,
                        )),
                  ],
                ),
              );
            },
          );
        });
  }

  int visibleResourceCount(ScheduleState scheduleState) {
    final len = scheduleState.users.length;
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
        return 9;
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

  CalendarDataSource getDataSource(ScheduleState state) {
    return _ShiftDataSource(state.getShifts, state.users);
  }
}

class _ShiftDataSource extends CalendarDataSource {
  _ShiftDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

// return StoreConnector<AppState, AppState>(
// converter: (store) => store.state,
// builder: (context, state) {
// final u = state.usersState.usersList.data ?? [];
// final l = state.generalState.locationItems.data ?? [];
// final sh = state.generalState.paramList.data?.shifts ?? [];
// return GetBuilder<SchedulingController>(
// id: 'SchedulingPage',
// builder: (controller) {
// final users = [
// UserRes(
// username: "All",
// loginRequired: false,
// locationAdmin: false,
// lastStatus: "",
// lastName: "All",
// groupAdmin: false,
// fullname: "All",
// firstName: "All",
// id: -1,
// title: ""),
// ...u
// ];
//
// final locations = [LocationItemMd(name: "All"), ...l];
// final shifts = [...sh];
// return PageWrapper(
// child: SpacedColumn(verticalSpace: 16.0, children: [
// const PagesTitleWidget(
// title: 'Schedule',
// ),
// TableWrapperWidget(
// child: Column(
// children: [
// Padding(
// padding: const EdgeInsets.all(16),
// child: Row(
// children: [
// SpacedRow(
// horizontalSpace: 16,
// children: [
// if (controller.sidebarType == SidebarType.user)
// DropdownWidget1(
// dropdownOptionsWidth: 250,
// dropdownBtnWidth: 250,
// hintText: "User",
// items:
// users.map((e) => e.fullname).toList(),
// objItems: users,
// customItemIcons: controller.filteredUsers
//     .map((key, value) =>
// MapEntry(key, HeroIcons.check)),
// value: controller.filteredUsers.isEmpty
// ? "All"
//     : controller.filteredUsers.values.first
//     .fullname,
// onChangedWithObj: (p0) {
// controller.addFilteredUser(
// users.indexOf(p0.item), p0);
// },
// ),
// if (controller.sidebarType ==
// SidebarType.location)
// DropdownWidget1(
// dropdownOptionsWidth: 400,
// dropdownBtnWidth: 250,
// hintText: "Location",
// items:
// locations.map((e) => e.name).toList(),
// objItems: locations,
// customItemIcons: controller
//     .filteredLocations
//     .map((key, value) =>
// MapEntry(key, HeroIcons.check)),
// value: controller.filteredLocations.isEmpty
// ? "All"
//     : controller.filteredLocations.values
//     .first.name,
// onChangedWithObj: (p0) {
// controller.addFilteredLocation(
// locations.indexOf(p0.item), p0);
// },
// ),
// DropdownWidget1(
// dropdownOptionsWidth: 150,
// dropdownBtnWidth: 150,
// hintText: "Time View",
// items: [
// ScheduleType.day.name,
// ScheduleType.week.name,
// ScheduleType.month.name,
// ],
// value: controller.scheduleType.name,
// onChanged: controller.setScheduleType,
// ),
// if (controller.scheduleType ==
// ScheduleType.month)
// Row(
// children: [
// IconButton(
// onPressed: () {
// //Decrement month
// controller.decrementMonth();
// },
// icon: const HeroIcon(
// HeroIcons.arrowLeft)),
// Text(
// '${DateFormat("MMMM").format(controller.selectedDate)}'),
// IconButton(
// onPressed: () {
// //Increment month
// controller.incrementMonth();
// },
// icon: const HeroIcon(
// HeroIcons.arrowRight)),
// ],
// )
// ],
// ),
// const Spacer(),
// Row(
// children: [
// if (controller.scheduleType != ScheduleType.day)
// ButtonLargeSecondary(
// text:
// controller.sidebarType.name.capitalize!,
// leftIcon: const HeroIcon(HeroIcons.loop),
// onPressed: () {
// controller.setSidebarType();
// },
// ),
// if (kDebugMode)
// ButtonLargeSecondary(
// text: 'Add monthly Cell',
// leftIcon: const HeroIcon(HeroIcons.add),
// onPressed: () {
// controller.addMonthlyCell(
// controller.monthlyCells.length + 1);
// },
// ),
// ],
// ),
// ],
// ),
// ),
// CustomGridWidget(
// config: controller.config,
// sidebar: controller.sidebar,
// cells: controller.cells),
// ],
// ),
// ),
// ]),
// );
// },
// );
// },
// );
