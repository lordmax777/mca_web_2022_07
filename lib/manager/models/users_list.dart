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
  String? locationId;
  bool groupAdmin;
  bool locationAdmin;
  bool loginRequired;
  dynamic locked;
  String fullname;

  bool get isOpenShiftResource => id == -10;
  bool get isALl => id == -1;

  String get fulltitle => "$title $fullname";

  @JsonKey(ignore: true)
  late Color userRandomBgColor;

  @JsonKey(ignore: true)
  late Color foregroundColor;

  String get initials {
    try {
      return firstName[0] + lastName[0];
    } catch (e) {
      return "??";
    }
  }

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
  }) {
    userRandomBgColor = Color.fromRGBO(Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255), 1.0);
    foregroundColor = userRandomBgColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  factory UserRes.all() {
    return UserRes(
        username: "All",
        loginRequired: false,
        locationAdmin: false,
        lastStatus: "",
        lastName: "All",
        groupAdmin: false,
        fullname: "All",
        firstName: "All",
        id: -1,
        title: "");
  }

  factory UserRes.init({
    int? id,
    String? username,
    String? fullname,
    String? firstName,
    String? lastName,
  }) {
    return UserRes(
        username: username ?? "",
        loginRequired: false,
        locationAdmin: false,
        lastStatus: "",
        lastName: lastName ?? "",
        groupAdmin: false,
        fullname: fullname ?? "",
        firstName: firstName ?? "",
        id: id ?? -1,
        title: "");
  }

  factory UserRes.openShiftResource() {
    return UserRes.init(
      id: -10,
      firstName: "Open",
      fullname: "Open Shift",
      lastName: "Shift",
      username: "Open Shift",
    );
  }

  factory UserRes.fromJson(Map<String, dynamic> json) =>
      _$UserResFromJson(json);

  Map<String, dynamic> toJson() => _$UserResToJson(this);

  @override
  String toString() {
    return fullname;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRes &&
        other.id == id &&
        other.username == username &&
        other.title == title &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.lastTime == lastTime &&
        other.lastStatus == lastStatus &&
        other.lastIpAddress == lastIpAddress &&
        other.lastLocationId == lastLocationId &&
        other.lastLatitude == lastLatitude &&
        other.lastLongitude == lastLongitude &&
        other.payrollCode == payrollCode &&
        other.lastComment == lastComment &&
        other.groupId == groupId &&
        other.locationId == locationId &&
        other.groupAdmin == groupAdmin &&
        other.locationAdmin == locationAdmin &&
        other.loginRequired == loginRequired &&
        other.locked == locked &&
        other.fullname == fullname;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        title.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        lastTime.hashCode ^
        lastStatus.hashCode ^
        lastIpAddress.hashCode ^
        lastLocationId.hashCode ^
        lastLatitude.hashCode ^
        lastLongitude.hashCode ^
        payrollCode.hashCode ^
        lastComment.hashCode ^
        groupId.hashCode ^
        locationId.hashCode ^
        groupAdmin.hashCode ^
        locationAdmin.hashCode ^
        loginRequired.hashCode ^
        locked.hashCode ^
        fullname.hashCode;
  }
}

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

  factory LastTime.fromJson(Map<String, dynamic> json) {
    try {
      return LastTime(
        date: json['date'] as String,
        timezone_type: json['timezone_type'] as int,
        timezone: json['timezone'] as String,
      );
    } on TypeError catch (e) {
      print("LasTime.fromJson: ${e.stackTrace}");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$LastTimeToJson(this);

  @override
  String toString() {
    return 'LastTime(date: $date, timezone_type: $timezone_type, timezone: $timezone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LastTime &&
        other.date == date &&
        other.timezone_type == timezone_type &&
        other.timezone == timezone;
  }

  @override
  int get hashCode {
    return date.hashCode ^ timezone_type.hashCode ^ timezone.hashCode;
  }
}
