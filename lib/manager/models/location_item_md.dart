import 'package:mca_web_2022_07/manager/models/users_list.dart';

import '../../pages/scheduling/popup_forms/client_form.dart';
import '../general_controller.dart';
import 'company_md.dart';

class LocationAddress {
  int id;
  String name;
  bool anywhere;
  Address address;
  Phone phone;
  String? email;
  bool active;
  bool fixedipaddress;
  List<IpAddress> ipaddress;
  List<Members> members;

  LocationAddress(
      {required this.id,
      required this.name,
      required this.anywhere,
      required this.address,
      required this.phone,
      this.email,
      required this.active,
      required this.fixedipaddress,
      required this.ipaddress,
      required this.members});

  factory LocationAddress.fromJson(Map<String, dynamic> json) {
    try {
      return LocationAddress(
        id: json['id'],
        name: json['name'],
        anywhere: json['anywhere'],
        address: Address.fromJson(json['address']),
        phone: Phone.fromJson(json['phone']),
        email: json['email'],
        active: json['active'] ?? false,
        fixedipaddress: json['fixedipaddress'] ?? false,
        ipaddress: json['ipaddress'] != null
            ? (json['ipaddress'] as List)
                .map((e) => IpAddress.fromJson(e))
                .toList()
            : [],
        members: json['members'] != null
            ? (json['members'] as List).map((e) => Members.fromJson(e)).toList()
            : [],
      );
    } on TypeError catch (e) {
      print("LocationAddress.fromJson: ${e.stackTrace}");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['anywhere'] = anywhere;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['active'] = active;
    data['fixedipaddress'] = fixedipaddress;
    data['members'] = members.map((v) => v.toJson()).toList();
    data['ipaddress'] = ipaddress.map((v) => v.toJson()).toList();
    return data;
  }

  factory LocationAddress.all() {
    return LocationAddress(
      name: "All",
      id: 0,
      anywhere: false,
      address: Address.init(),
      phone: Phone.init(),
      active: false,
      ipaddress: [],
      fixedipaddress: false,
      members: [],
    );
  }

  // init
  factory LocationAddress.init(
      {int? id,
      String? name,
      bool? anywhere,
      Address? address,
      Phone? phone,
      String? email,
      bool? active,
      bool? fixedipaddress,
      List<IpAddress>? ipaddress,
      List<Members>? members}) {
    return LocationAddress(
      id: id ?? -10,
      name: name ?? "",
      anywhere: anywhere ?? false,
      address: address ?? Address.init(),
      phone: phone ?? Phone.init(),
      email: email ?? "",
      active: active ?? false,
      fixedipaddress: fixedipaddress ?? false,
      ipaddress: ipaddress ?? [],
      members: members ?? [],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationAddress &&
        other.id == id &&
        other.name == name &&
        other.anywhere == anywhere &&
        other.address == address &&
        other.phone == phone &&
        other.email == email &&
        other.active == active &&
        other.fixedipaddress == fixedipaddress &&
        other.ipaddress == ipaddress &&
        other.members == members;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        anywhere.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        active.hashCode ^
        fixedipaddress.hashCode ^
        ipaddress.hashCode ^
        members.hashCode;
  }
}

class Address {
  String line1;
  String line2;
  String city;
  String county;
  String country;
  String postcode;
  num latitude;
  num longitude;
  num radius;

  Address(
      {required this.line1,
      required this.line2,
      required this.city,
      required this.county,
      required this.country,
      required this.postcode,
      required this.latitude,
      required this.longitude,
      required this.radius});

  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        line1: json['line1'],
        line2: json['line2'],
        city: json['city'],
        county: json['county'],
        country: json['country'],
        postcode: json['postcode'],
        latitude: json['latitude'] ?? 0,
        longitude: json['longitude'] ?? 0,
        radius: json['radius'] ?? 0,
      );
    } on TypeError catch (e) {
      print("Address.fromJson: ${e.stackTrace}");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line1'] = line1;
    data['line2'] = line2;
    data['city'] = city;
    data['county'] = county;
    data['country'] = country;
    data['postcode'] = postcode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['radius'] = radius;
    return data;
  }

  // init
  factory Address.init({String? postcode}) {
    CompanyMd companyInfo = GeneralController.to.companyInfo;

    return Address(
        line1: "",
        line2: "",
        city: "",
        county: "",
        country: companyInfo.country,
        postcode: postcode ?? "",
        latitude: 0,
        longitude: 0,
        radius: 0);
  }

  Address copy() {
    return Address(
      line1: line1,
      line2: line2,
      city: city,
      county: county,
      country: country,
      postcode: postcode,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }

  // from ClientAddressForm
  // factory Address.fromClientAddressForm(ClientAddressForm clientAddressForm) {
  //   return Address(
  //     line1: clientAddressForm.addressLine1 ?? "",
  //     line2: clientAddressForm.addressLine2 ?? "",
  //     city: clientAddressForm.addressCity ?? "",
  //     county: clientAddressForm.addressCounty ?? "",
  //     country: clientAddressForm.addressCountryId ?? "",
  //     postcode: clientAddressForm.addressPostcode ?? "",
  //     latitude: clientAddressForm.latitude ?? 0,
  //     longitude: clientAddressForm.longitude ?? 0,
  //     radius: clientAddressForm.radius ?? 0,
  //   );
  // }

  // from LocationAddress
  factory Address.fromLocationAddress(LocationAddress locationAddress) {
    try {
      return Address(
        line1: locationAddress.address!.line1,
        line2: locationAddress.address!.line2,
        city: locationAddress.address!.city,
        county: locationAddress.address!.county,
        country: locationAddress.address!.country,
        postcode: locationAddress.address!.postcode,
        latitude: locationAddress.address!.latitude,
        longitude: locationAddress.address!.longitude,
        radius: locationAddress.address!.radius,
      );
    } on TypeError catch (e) {
      print("Address.fromLocationAddress:${e.stackTrace}");
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.line1 == line1 &&
        other.line2 == line2 &&
        other.city == city &&
        other.county == county &&
        other.country == country &&
        other.postcode == postcode &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radius == radius;
  }

  @override
  int get hashCode {
    return line1.hashCode ^
        line2.hashCode ^
        city.hashCode ^
        county.hashCode ^
        country.hashCode ^
        postcode.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        radius.hashCode;
  }
}

class Phone {
  String landline;
  String mobile;
  String fax;

  Phone({required this.landline, required this.mobile, required this.fax});

  factory Phone.fromJson(Map<String, dynamic> json) {
    try {
      return Phone(
        landline: json['landline'],
        mobile: json['mobile'],
        fax: json['fax'],
      );
    } on TypeError catch (e) {
      print("Phone.fromJson: ${e.stackTrace}");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['landline'] = landline;
    data['mobile'] = mobile;
    data['fax'] = fax;
    return data;
  }

  // init
  factory Phone.init() {
    return Phone(landline: "", mobile: "", fax: "");
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Phone &&
        other.landline == landline &&
        other.mobile == mobile &&
        other.fax == fax;
  }

  @override
  int get hashCode {
    return landline.hashCode ^ mobile.hashCode ^ fax.hashCode;
  }
}

class Members {
  String name;
  int min;
  int? max;

  Members({required this.name, required this.min, required this.max});

  factory Members.fromJson(Map<String, dynamic> json) {
    try {
      return Members(
        name: json['name'],
        min: json['min'],
        max: json['max'],
      );
    } on TypeError catch (e) {
      print("Memebers.fromJson: ${e.stackTrace}");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['min'] = min;
    data['max'] = max;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Members &&
        other.name == name &&
        other.min == min &&
        other.max == max;
  }

  @override
  int get hashCode {
    return name.hashCode ^ min.hashCode ^ max.hashCode;
  }
}

class IpAddress {
  //{id: 33, locationId: 167, ipAddress: 115.91.214.12, startTime: {date: 2022-11-09 06:25:49.000000, timezone_type: 3, timezone: UTC}, endTime: null}
  int id;
  String locationId;
  String ipAddress;
  LastTime startTime;
  LastTime? endTime;

  IpAddress({
    required this.id,
    required this.locationId,
    required this.ipAddress,
    required this.startTime,
    required this.endTime,
  });

  factory IpAddress.fromJson(Map<String, dynamic> json) {
    try {
      return IpAddress(
        id: json['id'],
        locationId: json['locationId'],
        ipAddress: json['ipAddress'],
        startTime: LastTime.fromJson(json['startTime']),
        endTime:
            json['endTime'] != null ? LastTime.fromJson(json['endTime']) : null,
      );
    } on TypeError catch (e) {
      print("IpAddress.fromJson: ${e.stackTrace}");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['locationId'] = locationId;
    data['ipAddress'] = ipAddress;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IpAddress &&
        other.id == id &&
        other.locationId == locationId &&
        other.ipAddress == ipAddress &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        locationId.hashCode ^
        ipAddress.hashCode ^
        startTime.hashCode ^
        endTime.hashCode;
  }
}
