import 'package:json_annotation/json_annotation.dart';

import 'users_list.dart';
part 'preffered_shift_md_md.g.dart';

@JsonSerializable(anyMap: true)
class PreferredShiftMd {
  int id;
  int dayId;
  int weekId;
  String day;
  int hours;
  LastTime start;
  LastTime finish;
  String location;
  String title;
  @override
  PreferredShiftMd({
    required this.day,
    required this.dayId,
    required this.finish,
    required this.hours,
    required this.id,
    required this.location,
    required this.start,
    required this.title,
    required this.weekId,
  });

  factory PreferredShiftMd.fromJson(Map<String, dynamic> json) =>
      _$PreferredShiftMdFromJson(json);

  Map<String, dynamic> toJson() => _$PreferredShiftMdToJson(this);
}
