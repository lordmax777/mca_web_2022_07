import 'package:collection/collection.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';

class AllocationModel {
  int id;
  String date;
  DateTime get dateAsDateTime => Constants.isoDateTime(date);
  ListShift shift;
  PropertiesMd get property => shift.property;
  bool published;
  UserRes? user;
  // JobModel job;

  AllocationModel({
    required this.shift,
    this.user,
    this.published = false,
    required this.id,
    required this.date,
    // required this.job,
  });

  factory AllocationModel.fromJson(Map<String, dynamic> json) {
    try {
      final int shiftId = json['shiftId'];
      final ListShift shift =
          appStore.state.generalState.shifts.firstWhere((e) => e.id == shiftId);
      final String date = json['date'];
      final int id = json['id'];
      final bool published = json['published'];
      final int? userId = json['userId'];
      final UserRes? user = appStore.state.usersState.users
          .firstWhereOrNull((e) => e.id == userId);
      //TODO: Add job
      // final JobModel job = JobModel.fromJson(json['job']);
      return AllocationModel(
        shift: shift,
        date: date,
        id: id,
        published: published,
        user: user,
        // job: job,
      );
    } on Exception catch (e) {
      print("AllocationModel.fromJson: $e");
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AllocationModel &&
        other.id == id &&
        other.date == date &&
        other.shift == shift &&
        other.published == published &&
        other.user == user;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      shift.hashCode ^
      published.hashCode ^
      user.hashCode;
}
