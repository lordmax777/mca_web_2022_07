import 'package:mca_dashboard/presentation/pages/properties_view/data/shift_details.dart';

class GetPropertiesAction {
  const GetPropertiesAction();
}

final class DeletePropertyAction {
  final int id;
  const DeletePropertyAction(this.id);
}

final class PostPropertyAction {
  final ShiftDetailsData model;
  const PostPropertyAction(this.model);
}

final class GetPropertySpecialRatesAction {
  final int shiftId;

  const GetPropertySpecialRatesAction(this.shiftId);
}

final class PostPropertySpecialRatesAction {
  final int? shiftId;
  final CustomRate rate;

  const PostPropertySpecialRatesAction(this.shiftId, this.rate);
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
