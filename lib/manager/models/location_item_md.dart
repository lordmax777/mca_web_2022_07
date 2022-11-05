import '../../utils/log_tester.dart';

class LocationItemMd {
  int? id;
  String? name;
  bool? anywhere;
  Address? address;
  Phone? phone;
  String? email;
  bool? active;
  bool? fixedipaddress;
  String? ipaddress;
  List<Members>? members;

  LocationItemMd(
      {this.id,
      this.name,
      this.anywhere,
      this.address,
      this.phone,
      this.email,
      this.active,
      this.fixedipaddress,
      this.ipaddress,
      this.members});

  LocationItemMd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    anywhere = json['anywhere'];
    address = Address.fromJson(json['address']);
    phone = Phone.fromJson(json['phone']);
    email = json['email'];
    active = json['active'];
    fixedipaddress = json['fixedipaddress'];
    ipaddress = json['ipaddress'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
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
    data['ipaddress'] = ipaddress;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  String? line1;
  String? line2;
  String? city;
  String? county;
  String? country;
  String? postcode;
  num? latitude;
  num? longitude;
  num? radius;

  Address(
      {this.line1,
      this.line2,
      this.city,
      this.county,
      this.country,
      this.postcode,
      this.latitude,
      this.longitude,
      this.radius});

  Address.fromJson(Map<String, dynamic> json) {
    line1 = json['line1'];
    line2 = json['line2'];
    city = json['city'];
    county = json['county'];
    country = json['country'];
    postcode = json['postcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
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
}

class Phone {
  String? landline;
  String? mobile;
  String? fax;

  Phone({this.landline, this.mobile, this.fax});

  Phone.fromJson(Map<String, dynamic> json) {
    landline = json['landline'];
    mobile = json['mobile'];
    fax = json['fax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['landline'] = landline;
    data['mobile'] = mobile;
    data['fax'] = fax;
    return data;
  }
}

class Members {
  String? name;
  int? min;
  int? max;

  Members({this.name, this.min, this.max});

  Members.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['min'] = min;
    data['max'] = max;
    return data;
  }
}
