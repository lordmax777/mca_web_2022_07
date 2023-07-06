import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/data/models/quote_md.dart';

final class LocationMd extends Equatable {
  //{
  //     "id": 307,
  //     "name": "1 Centric close,Flat 47,NW1 7EP",
  //     "anywhere": false,
  //     "address": {
  //         "line1": "Flat 47 1 Centric Close",
  //         "line2": "",
  //         "city": "",
  //         "county": "",
  //         "country": "GB",
  //         "postcode": "NW1 7EP",
  //         "latitude": 51.5394871,
  //         "longitude": -0.1483199,
  //         "radius": 300
  //     },
  //     "phone": {
  //         "landline": "",
  //         "mobile": "",
  //         "fax": ""
  //     },
  //     "email": "htyu",
  //     "active": true,
  //     "fixedipaddress": false,
  //     "ipaddress": null,
  //     "members": [],
  //     "sendChecklist": true
  // }
  final int id;
  final String name;
  final bool anywhere;
  final AddressMd address;
  final PhoneMd phone;
  final String email;
  final bool active;
  final bool fixedipaddress;
  final List<IpAddressMd> ipaddress;
  final List<MemberMd> members;
  final bool sendChecklist;

  const LocationMd({
    required this.id,
    required this.name,
    required this.anywhere,
    required this.address,
    required this.phone,
    required this.email,
    required this.active,
    required this.fixedipaddress,
    required this.ipaddress,
    required this.members,
    required this.sendChecklist,
  });

  factory LocationMd.fromJson(Map<String, dynamic> json) => LocationMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        anywhere: json['anywhere'] ?? false,
        address: AddressMd.fromJson(json['address']),
        phone: PhoneMd.fromJson(json['phone']),
        email: json['email'] ?? "",
        active: json['active'] ?? false,
        fixedipaddress: json['fixedipaddress'] ?? false,
        ipaddress: json['ipaddress'] == null
            ? []
            : (json['ipaddress'] as List<dynamic>)
                .map((e) => IpAddressMd.fromJson(e as Map<String, dynamic>))
                .toList(),
        members: (json['members'] as List<dynamic>)
            .map((e) => MemberMd.fromJson(e as Map<String, dynamic>))
            .toList(),
        sendChecklist: json['sendChecklist'] ?? false,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        anywhere,
        address,
        phone,
        email,
        active,
        fixedipaddress,
        ipaddress,
        members,
        sendChecklist
      ];

  //toJson
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "anywhere": anywhere,
        // "address": address.toJson(),
        // "phone": phone.toJson(),
        "email": email,
        "active": active,
        "fixedipaddress": fixedipaddress,
        // "ipaddress": ipaddress.map((e) => e.toJson()).toList(),
        // "members": members.map((e) => e.toJson()).toList(),
        "sendChecklist": sendChecklist
      };
}

final class AddressMd extends Equatable {
  //     "address": {
  //         "line1": "Flat 47 1 Centric Close",
  //         "line2": "",
  //         "city": "",
  //         "county": "",
  //         "country": "GB",
  //         "postcode": "NW1 7EP",
  //         "latitude": 51.5394871,
  //         "longitude": -0.1483199,
  //         "radius": 300
  //     },
  final String line1;
  final String line2;
  final String city;
  final String county;
  final String country;

  CountryMd? getCountryMd(List<CountryMd> countries) =>
      countries.firstWhereOrNull((element) => element.code == country);
  final String postcode;
  final num? latitude;
  final num? longitude;
  final num? radius;

  const AddressMd({
    required this.line1,
    required this.line2,
    required this.city,
    required this.county,
    required this.country,
    required this.postcode,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory AddressMd.fromJson(Map<String, dynamic> json) => AddressMd(
        line1: json['line1'] ?? "",
        line2: json['line2'] ?? "",
        city: json['city'] ?? "",
        county: json['county'] ?? "",
        country: json['country'] ?? "",
        postcode: json['postcode'] ?? "",
        latitude: json['latitude'],
        longitude: json['longitude'],
        radius: json['radius'],
      );

  @override
  List<Object?> get props => [
        line1,
        line2,
        city,
        county,
        country,
        postcode,
        latitude,
        longitude,
        radius,
      ];

  String toAddressStr() {
    return "$line1, ${line2.isNotEmpty ? "$line2, " : ""}${city.isNotEmpty ? "$city, " : ""}${county.isNotEmpty ? "$county, " : ""}${postcode.isNotEmpty ? "$postcode, " : ""}${country.isNotEmpty ? "$country, " : ""}";
  }
}

final class PhoneMd extends Equatable {
  //     "phone": {
  //         "landline": "",
  //         "mobile": "",
  //         "fax": ""
  //     },

  final String landline;
  final String mobile;
  final String fax;

  const PhoneMd({
    required this.landline,
    required this.mobile,
    required this.fax,
  });

  factory PhoneMd.fromJson(Map<String, dynamic> json) => PhoneMd(
        landline: json['landline'] ?? "",
        mobile: json['mobile'] ?? "",
        fax: json['fax'] ?? "",
      );

  @override
  List<Object?> get props => [
        landline,
        mobile,
        fax,
      ];
}

final class MemberMd extends Equatable {
  // {
  //                 "name": "Cleaners",
  //                 "min": 1,
  //                 "max": null
  //             }

  final String name;
  final int min;
  final int? max;

  const MemberMd({
    required this.name,
    required this.min,
    required this.max,
  });

  factory MemberMd.fromJson(Map<String, dynamic> json) => MemberMd(
        name: json['name'] ?? "",
        min: json['min'] ?? 0,
        max: json['max'] as int?,
      );

  @override
  List<Object?> get props => [
        name,
        min,
        max,
      ];
}

final class IpAddressMd extends Equatable {
  //{
  //                 "id": 43,
  //                 "locationId": 326,
  //                 "ipAddress": "1.2.3.4",
  //                 "startTime": {
  //                     "date": "2022-10-19 17:56:46.000000",
  //                     "timezone_type": 3,
  //                     "timezone": "Europe/London"
  //                 },
  //                 "endTime": null
  //             }
  final int id;

  final String ipAddress;
  final String date;

  DateTime get startTime => DateTime.parse(date);
  final num timezone_type;
  final String timezone;
  final String? endTime;

  DateTime? get endTimeDate =>
      endTime != null ? DateTime.parse(endTime!) : null;

  const IpAddressMd({
    required this.id,
    required this.ipAddress,
    required this.date,
    required this.timezone_type,
    required this.timezone,
    required this.endTime,
  });

  factory IpAddressMd.fromJson(Map<String, dynamic> json) => IpAddressMd(
        id: json['id'] as int,
        ipAddress: json['ipAddress'] ?? "",
        date: json['startTime']?['date'] ?? "",
        timezone_type: json['startTime']?['timezone_type'] ?? 0,
        timezone: json['startTime']?['timezone'] ?? "",
        endTime: json['endTime'],
      );

  @override
  List<Object?> get props => [
        id,
        ipAddress,
        date,
        timezone_type,
        timezone,
        endTime,
      ];
}
