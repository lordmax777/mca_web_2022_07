import 'package:syncfusion_flutter_calendar/calendar.dart';

Map<DateTime, List<Appointment>> dataCollection =
    <DateTime, List<Appointment>>{};

class ShiftDataSource extends CalendarDataSource<Appointment> {
  final List<Appointment> source;
  final List<CalendarResource>? resourceColl;

  ShiftDataSource(this.source, this.resourceColl);

  @override
  List<Appointment> get appointments => source;

  @override
  List<CalendarResource>? get resources => resourceColl;

  // @override
  // Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
  //   final List<Appointment> apps =
  //       await appStore.dispatch(SCFetchShiftMonthAction(
  //     startDate: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
  //     endDate: DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day),
  //   ));
  //   List<Appointment> apps2 = [];
  //
  //   //Check if the apps list is already in the appointments list,
  //   //if it is, then don't add it to the appointments list
  //   //if it isn't, then add it to the apps2 list
  //
  //   for (var i = 0; i < apps.length; i++) {
  //     if (appointments.any((element) => element.id == apps[i].id)) {
  //       continue;
  //     } else {
  //       apps2.add(apps[i]);
  //     }
  //   }
  //
  //   appointments.addAll(apps2);
  //   notifyListeners(CalendarDataSourceAction.add, apps2);
  // }
}
