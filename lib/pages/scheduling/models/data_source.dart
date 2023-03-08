import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';

class ShiftDataSource extends CalendarDataSource {
  final List<Appointment> source;
  final List<CalendarResource>? resourceColl;
  ShiftDataSource(this.source, this.resourceColl);

  @override
  List<dynamic> get appointments => source;

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
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    final apps = await appStore.dispatch(SCFetchShiftMonthAction(
      startDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
      endDate: DateTime(DateTime.now().year, DateTime.now().month, 30),
    ));
    appointments.addAll(apps);
    notifyListeners(CalendarDataSourceAction.add, apps);
  }
}
