import 'package:mca_dashboard/presentation/pages/properties_view/data/shift_details.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';

class GetPropertiesAction {
  const GetPropertiesAction();
}

final class DeletePropertyAction {
  final int id;
  const DeletePropertyAction(this.id);
}

final class PostPropertyAction {
  final int? id;
  final String title;
  final int locationId;
  final int clientId;
  final int storageId;
  final int templateId;
  final DateTime startTime;
  final DateTime finishTime;
  final DateTime? startBreak;
  final DateTime? finishBreak;
  final DateTime? fpStartTime;
  final DateTime? fpFinishTime;
  final DateTime? fpStartBreak;
  final DateTime? fpFinishBreak;
  final bool strictBreak;
  final int? minWorkTime;
  final int? minPaidTime;
  final bool? splitTime;
  final bool checklist;
  final WeekDaysMd days;
  final bool active;

  const PostPropertyAction({
    this.id,
    required this.title,
    required this.locationId,
    required this.active,
    required this.clientId,
    required this.storageId,
    required this.templateId,
    required this.startTime,
    required this.finishTime,
    this.startBreak,
    this.finishBreak,
    this.fpStartTime,
    this.fpFinishTime,
    this.fpStartBreak,
    this.fpFinishBreak,
    required this.strictBreak,
    this.minWorkTime,
    this.minPaidTime,
    this.splitTime,
    required this.checklist,
    required this.days,
  });
}

final class GetPropertySpecialRatesAction {
  final int shiftId;

  const GetPropertySpecialRatesAction(this.shiftId);
}

final class PostPropertySpecialRatesAction {
  final int? shiftId;
  final int minPaidTime;
  final double rate;
  final int minWorkTime;
  final String name;
  final bool splitTime;

  const PostPropertySpecialRatesAction(this.shiftId,
      {required this.minPaidTime,
      required this.rate,
      required this.minWorkTime,
      required this.name,
      required this.splitTime});
}

final class DeletePropertySpecialRateAction {
  final int rateId;
  final int shiftId;

  const DeletePropertySpecialRateAction(this.shiftId, this.rateId);
}

final class GetPropertyStaffAction {
  final int shiftId;

  const GetPropertyStaffAction(this.shiftId);
}

final class PostPropertyStaffAction {
  final int? shiftId;
  final int? groupId;
  final int minOfStaff;
  final int? maxOfStaff;

  const PostPropertyStaffAction(
      {this.shiftId, this.groupId, required this.minOfStaff, this.maxOfStaff});
}

final class DeletePropertyStaffAction {
  final int shiftId;
  final int groupId;

  const DeletePropertyStaffAction(this.shiftId, this.groupId);
}

//group
final class GetPropertyQualificationAction {
  final int shiftId;

  const GetPropertyQualificationAction(this.shiftId);
}

final class PostPropertyQualificationAction {
  final int? shiftId;
  final int? qualificationId;
  final int numberOfStaff;
  final int? levelId;
  const PostPropertyQualificationAction(
      {this.shiftId,
      this.qualificationId,
      required this.numberOfStaff,
      this.levelId});
}

final class DeletePropertyQualificationAction {
  final int shiftId;
  final int qualificationId;

  const DeletePropertyQualificationAction(this.shiftId, this.qualificationId);
}
