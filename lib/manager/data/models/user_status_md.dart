import 'package:equatable/equatable.dart';

final class UserStatusMd extends Equatable {
  //{
  //         "id": 2,
  //         "name": "Signed out",
  //         "comment": "",
  //         "latitude": 51.536129945627,
  //         "longitude": -0.13886426040494,
  //         "within_range": true,
  //         "shift": "Flat 3",
  //         "location": "Camden NW1 0JN",
  //         "mode": "APP",
  //         "timestamp": "2019-07-28 14:41:11",
  //         "created_on": "2019-07-28 14:41:11"
  //     }

  final int id;
  final String name;
  final String comment;
  final num? latitude;
  final num? longitude;
  final bool withinRange;
  final String shift;
  final String location;
  final String mode;
  final String timestamp;
  DateTime? get timestampDt => DateTime.tryParse(timestamp);
  final String createdOn;
  DateTime? get createdOnDt => DateTime.tryParse(createdOn);

  const UserStatusMd({
    required this.id,
    required this.name,
    required this.comment,
    required this.latitude,
    required this.longitude,
    required this.withinRange,
    required this.shift,
    required this.location,
    required this.mode,
    required this.timestamp,
    required this.createdOn,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        comment,
        latitude,
        longitude,
        withinRange,
        shift,
        location,
        mode,
        timestamp,
        createdOn,
      ];

  //from json
  factory UserStatusMd.fromJson(Map<String, dynamic> json) => UserStatusMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        comment: json['comment'] ?? "",
        latitude: json['latitude'],
        longitude: json['longitude'],
        withinRange: json['within_range'] ?? false,
        shift: json['shift'] ?? "",
        location: json['location'] ?? "",
        mode: json['mode'] ?? "",
        timestamp: json['timestamp'] ?? "",
        createdOn: json['created_on'] ?? "",
      );
}
