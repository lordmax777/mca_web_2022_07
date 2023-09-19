import 'package:mca_dashboard/manager/data/models/timesheet_md.dart';
import 'package:mca_dashboard/manager/manager.dart';

class GetTimesheetAction {
  final int userId;
  final int timestamp;

  const GetTimesheetAction({
    this.userId = -1,
    required this.timestamp,
  });

  Future<Either<TimesheetMd, ErrorMd>> fetch(AppState state) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .getTimesheet(timestamp: timestamp, userId: userId);
      final timesheet = TimesheetMd.fromJson(res.data);
      return timesheet;
    });
  }
}
