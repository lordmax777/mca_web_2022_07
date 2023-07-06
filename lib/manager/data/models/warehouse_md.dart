import 'package:equatable/equatable.dart';

import '../../../utils/global_functions.dart';

final class WarehouseMd extends Equatable {
  //{
  //             "id": 113,
  //             "active": true,
  //             "name": "Castle Road TEST SH NW1 8PR",
  //             "contactName": "Shohjahon test 2",
  //             "contactEmail": "jko@gmail.com",
  //             "sendReport": false,
  //             "properties": [
  //                 {
  //                     "id": 395,
  //                     "locationName": "Castle Road TEST SH NW1 8PR",
  //                     "propertyName": "Shohjahon test 2"
  //                 }
  //             ]
  //         }

  final int id;
  final bool active;
  final String name;
  final String contactName;
  final String contactEmail;
  final bool sendReport;
  final List<WarehousePropertyMd> properties;

  const WarehouseMd({
    required this.id,
    required this.active,
    required this.name,
    required this.contactName,
    required this.contactEmail,
    required this.sendReport,
    required this.properties,
  });

  @override
  List<Object?> get props => [
        id,
        active,
        name,
        contactName,
        contactEmail,
        sendReport,
        properties,
      ];

//from json
  factory WarehouseMd.fromJson(Map<String, dynamic> json) {
    return WarehouseMd(
      id: json['id'],
      active: json['active'] ?? false,
      name: json['name'] ?? '',
      contactName: json['contactName'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      sendReport: json['sendReport'] ?? false,
      properties: json["properties"] == null
          ? []
          : List<WarehousePropertyMd>.from(
              json["properties"].map((x) => WarehousePropertyMd.fromJson(x))),
    );
  }
}

final class WarehousePropertyMd extends Equatable {
  // {
  //                     "id": 395,
  //                     "locationName": "Castle Road TEST SH NW1 8PR",
  //                     "propertyName": "Shohjahon test 2"
  //                 }

  final int id;
  final String locationName;
  final String propertyName;

  const WarehousePropertyMd({
    required this.id,
    required this.locationName,
    required this.propertyName,
  });

  @override
  List<Object?> get props => [id, locationName, propertyName];

  //from json
  factory WarehousePropertyMd.fromJson(Map<String, dynamic> json) {
    return WarehousePropertyMd(
      id: json['id'],
      locationName: json['locationName'] ?? '',
      propertyName: json['propertyName'] ?? '',
    );
  }
}
