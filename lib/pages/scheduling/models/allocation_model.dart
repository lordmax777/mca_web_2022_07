import 'package:collection/collection.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/sets/app_state.dart';

class AllocationModel {
  int id;
  String date;
  DateTime get dateAsDateTime => Constants.isoDateTime(date);
  ListShift shift;
  late final LocationAddress location;
  PropertiesMd get property => shift.property;
  bool published;
  UserRes? user;
  int guests;
  PropertyDetailsMd propertyDetails = PropertyDetailsMd.init();

  AllocationModel({
    required this.shift,
    this.user,
    this.guests = 0,
    this.published = false,
    required this.id,
    required this.date,
  }) {
    location = shift.location;
  }

  factory AllocationModel.fromJson(Map<String, dynamic> json,
      {required List<ListShift> shifts, List<UserRes>? users}) {
    try {
      final int shiftId = json['shiftId'];
      final ListShift shift = shifts.firstWhere((e) => e.id == shiftId);
      final String date = json['date'];
      final int id = json['id'];
      final bool published = json['published'];
      final int? userId = json['userId'];
      final int guests = json['guests'];
      final UserRes? user = users?.firstWhereOrNull((e) => e.id == userId);
      return AllocationModel(
        shift: shift,
        date: date,
        id: id,
        published: published,
        user: user,
        guests: guests,
      );
    } on Exception catch (e) {
      print("AllocationModel.fromJson: $e");
      rethrow;
    }
  }

  //copyWith
  AllocationModel copyWith() {
    final alloc = AllocationModel(
      id: id,
      date: date,
      shift: shift.copyWith(),
      published: published,
      user: user?.copyWith(),
      guests: guests,
    );
    alloc.propertyDetails = propertyDetails;
    return alloc;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AllocationModel &&
        other.id == id &&
        other.date == date &&
        other.shift == shift &&
        other.published == published &&
        other.user == user &&
        other.location == location &&
        other.property == property &&
        other.guests == guests &&
        other.propertyDetails == propertyDetails;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      shift.hashCode ^
      published.hashCode ^
      user.hashCode ^
      location.hashCode ^
      property.hashCode ^
      guests.hashCode ^
      propertyDetails.hashCode;
}
