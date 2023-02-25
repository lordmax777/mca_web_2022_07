import 'dart:math';
import 'package:json_annotation/json_annotation.dart';
import '../../theme/theme.dart';
part 'users_list.g.dart';

@JsonSerializable(anyMap: true)
class UserRes {
  int id;
  String username;
  String title;
  String firstName;
  String lastName;
  LastTime? lastTime;
  String lastStatus;
  String? lastIpAddress;
  String? lastLocationId;
  double? lastLatitude;
  double? lastLongitude;
  String? payrollCode;
  String? lastComment;
  String? groupId;
  dynamic locationId;
  bool groupAdmin;
  bool locationAdmin;
  bool loginRequired;
  dynamic locked;
  String fullname;

  @JsonKey(ignore: true)
  Color userRandomBgColor = Color.fromRGBO(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 0.3);

  @override
  UserRes({
    required this.username,
    required this.title,
    required this.id,
    required this.firstName,
    required this.fullname,
    this.lastComment,
    this.lastIpAddress,
    this.lastLatitude,
    this.lastLocationId,
    this.lastLongitude,
    required this.lastName,
    required this.lastStatus,
    required this.loginRequired,
    this.payrollCode,
    this.lastTime,
    this.locked,
    this.groupId,
    required this.groupAdmin,
    required this.locationAdmin,
    this.locationId,
  });

  factory UserRes.fromJson(Map<String, dynamic> json) =>
      _$UserResFromJson(json);

  Map<String, dynamic> toJson() => _$UserResToJson(this);
}

@JsonSerializable(anyMap: true)
class LastTime {
  String date;
  int timezone_type;
  String timezone;

  @override
  LastTime({
    required this.date,
    required this.timezone,
    required this.timezone_type,
  });

  factory LastTime.fromJson(Map<String, dynamic> json) =>
      _$LastTimeFromJson(json);

  Map<String, dynamic> toJson() => _$LastTimeToJson(this);
}
