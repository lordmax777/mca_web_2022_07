import 'package:equatable/equatable.dart';

final class UserPreferredShiftMd extends Equatable {
  //{
  //                     "id": 139,
  //                     "dayId": 2,
  //                     "weekId": 2,
  //                     "day": "Tuesday",
  //                     "hours": 5,
  //                     "start": {
  //                         "date": "1970-01-01 18:00:00.000000",
  //                         "timezone_type": 3,
  //                         "timezone": "UTC"
  //                     },
  //                     "finish": {
  //                         "date": "1970-01-01 23:00:00.000000",
  //                         "timezone_type": 3,
  //                         "timezone": "UTC"
  //                     },
  //                     "location": "Sam Bavishi",
  //                     "title": "evening"
  //                 }
  final int id;
  final int dayId;
  final int weekId;
  final String day;
  final num hours;
  final String start;
  DateTime? get startDate => DateTime.tryParse(start);
  final String finish;
  DateTime? get finishDate => DateTime.tryParse(finish);
  final String location;
  final String title;

  const UserPreferredShiftMd({
    required this.id,
    required this.dayId,
    required this.weekId,
    required this.day,
    required this.hours,
    required this.start,
    required this.finish,
    required this.location,
    required this.title,
  });

  @override
  List<Object?> get props => [
        id,
        dayId,
        weekId,
        day,
        hours,
        start,
        finish,
        location,
        title,
      ];

  //from json
  factory UserPreferredShiftMd.fromJson(Map<String, dynamic> json) =>
      UserPreferredShiftMd(
        id: json['id'] as int,
        dayId: json['dayId'] ?? 0,
        weekId: json['weekId'] ?? 0,
        day: json['day'] ?? "",
        hours: json['hours'] ?? 0,
        start: json['start']?['date'] ?? "",
        finish: json['finish']?['date'] ?? "",
        location: json['location'] ?? "",
        title: json['title'] ?? "",
      );
}
