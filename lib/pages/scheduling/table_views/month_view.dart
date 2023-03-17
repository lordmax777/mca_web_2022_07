// import 'package:flutter/foundation.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import '../../../manager/redux/sets/app_state.dart';
// import '../../../manager/redux/states/schedule_state.dart';
// import '../../../theme/theme.dart';
// import '../models/data_source.dart';
//
// class MonthlyViewCalendar extends StatefulWidget {
//   const MonthlyViewCalendar({Key? key}) : super(key: key);
//
//   @override
//   State<MonthlyViewCalendar> createState() => _MonthlyViewCalendarState();
// }
//
// class _MonthlyViewCalendarState extends State<MonthlyViewCalendar> {
//   CalendarController controller = CalendarController();
//   bool isInit = true;
//
//   DateTime get date => controller.displayDate ?? DateTime.now();
//   DateTime get startDate => DateTime(date.year, date.month, 1);
//   DateTime get endDate => DateTime(
//       date.year, date.month, DateTime(date.year, date.month + 1, 0).day);
//   DateTime? oldDate;
//
//   void fetchShifts() async {
//     // if (oldDate?.month == date.month) return;
//     // await appStore.dispatch(
//     //     SCFetchShiftMonthAction(startDate: startDate, endDate: endDate));
//     oldDate = date;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     controller.addPropertyChangedListener((event) async {
//       if (event == "displayDate") {
//         if (isInit) {
//           isInit = false;
//           fetchShifts();
//           return;
//         }
//         fetchShifts();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, AppState>(
//         converter: (store) => store.state,
//         builder: (_, state) {
//           final scheduleState = state.scheduleState;
//           logger(
//               controller.getCalendarDetailsAtOffset
//                   ?.call(Offset.zero)
//                   ?.appointments,
//               hint: "build");
//           return SfCalendar(
//             view: CalendarView.month,
//             dataSource: getDataSource,
//             timeSlotViewSettings: const TimeSlotViewSettings(
//               startHour: 0,
//               endHour: 1,
//             ),
//             // minDate: startDate,
//             maxDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
//             monthViewSettings: const MonthViewSettings(
//               dayFormat: 'EEEE',
//             ),
//             viewNavigationMode: ViewNavigationMode.none,
//             dragAndDropSettings: const DragAndDropSettings(
//               allowScroll: !kDebugMode,
//               allowNavigation: !kDebugMode,
//             ),
//             controller: controller,
//             showCurrentTimeIndicator: false,
//             showDatePickerButton: true,
//             showNavigationArrow: true,
//             firstDayOfWeek: 1,
//             allowDragAndDrop: true,
//             loadMoreWidgetBuilder: loadMoreWidget,
//             appointmentBuilder: (_, calendarAppointmentDetails) {
//               logger("calendarAppointmentDetails: $calendarAppointmentDetails");
//               final appointment = calendarAppointmentDetails.appointments
//                   .toList()
//                   .first as Appointment?;
//               final ap = appointment?.id as AppointmentIdMd?;
//               if (ap == null) {
//                 return const SizedBox();
//               }
//               final isUserView =
//                   state.scheduleState.sidebarType == SidebarType.user;
//               final count = scheduleState.countSameShiftStartDate(appointment!);
//               return _appWidget(ap, count, isUserView);
//             },
//           );
//         });
//   }
//
//   Widget loadMoreWidget(
//       BuildContext context, LoadMoreCallback loadMoreAppointments) {
//     return FutureBuilder<void>(
//       future: loadMoreAppointments(),
//       builder: (context, snapShot) {
//         return Container(
//             alignment: Alignment.center,
//             child: const CircularProgressIndicator());
//       },
//     );
//   }
//
//   Widget _appWidget(AppointmentIdMd ap, int count, bool isUserView) {
//     logger("count: $count");
//     final location = ap.location;
//     final alloc = ap.property;
//     final bool isLarge = count == 1;
//     return Tooltip(
//       message: location.title ?? "-",
//       child: Container(
//         decoration: BoxDecoration(
//           color: ThemeColors.transparent,
//           border: Border.all(
//             color: ThemeColors.gray10,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(4.0),
//         ),
//         padding: EdgeInsets.symmetric(
//             horizontal: 16.0, vertical: !isLarge ? 2.0 : 6.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (!isUserView)
//               SpacedRow(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 horizontalSpace: 4,
//                 children: [
//                   HeroIcon(HeroIcons.user, size: 16 / count),
//                   SizedBox(
//                     width: 150,
//                     child: KText(
//                       isSelectable: false,
//                       text: ap.user.fullname,
//                       fontSize: 20 / count,
//                       maxLines: 1,
//                       textColor: ThemeColors.gray2,
//                       fontWeight: FWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             if (isUserView)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SpacedRow(
//                     mainAxisSize: MainAxisSize.min,
//                     horizontalSpace: 4,
//                     children: [
//                       HeroIcon(HeroIcons.pin, size: 16 / count),
//                       SizedBox(
//                         width: 150,
//                         child: KText(
//                           isSelectable: false,
//                           text: location.title ?? "-",
//                           fontSize: 14 / count,
//                           maxLines: 1,
//                           textColor: ThemeColors.gray2,
//                           fontWeight: FWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SpacedRow(
//                     mainAxisSize: MainAxisSize.min,
//                     horizontalSpace: 4,
//                     children: [
//                       HeroIcon(HeroIcons.house, size: 16 / count),
//                       SizedBox(
//                         width: 150,
//                         child: KText(
//                           maxLines: 1,
//                           isSelectable: false,
//                           text: alloc.title ?? "-",
//                           fontSize: 14 / count,
//                           textColor: ThemeColors.gray2,
//                           fontWeight: FWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             IconButton(
//                 alignment: Alignment.centerRight,
//                 padding: const EdgeInsets.all(0.0),
//                 iconSize: 24,
//                 onPressed: () async {},
//                 icon: const HeroIcon(
//                   HeroIcons.moreVertical,
//                   size: 24.0,
//                   color: ThemeColors.gray2,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   ShiftDataSource getDataSource = ShiftDataSource([], []);
// }
