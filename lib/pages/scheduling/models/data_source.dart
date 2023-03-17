import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';

class ShiftDataSource extends CalendarDataSource {
  final List<AppointmentIdMd1> source;
  final List<CalendarResource>? resourceColl;
  ShiftDataSource(this.source, this.resourceColl);

  @override
  List<AppointmentIdMd1> get appointments => source;

  @override
  List<CalendarResource>? get resources => resourceColl;

  @override
  DateTime getStartTime(int index) {
    return source[index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].endTime;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    final List<AppointmentIdMd1> apps =
        await appStore.dispatch(SCFetchShiftMonthAction(
      startDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 7),
      endDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
    ));
    appointments.addAll(apps);
    notifyListeners(CalendarDataSourceAction.add, apps);
  }
}
