import 'package:json_annotation/json_annotation.dart';
part 'user_details_md.g.dart';

@JsonSerializable(anyMap: true)
class UserDetailsMd {
  String title;
  String first_name;
  String last_name;
  String? date_of_birth;
  String nationality;
  String marital_status;
  String ethnic;
  String religion;
  UserDetailsAddressMd address;
  UserDetailsPhonesMd phones;
  UserDetailsNextOfKinMd next_of_kin;
  UserDetailsPayrollMd payroll;
  UserDetailsAccountMd account;
  String notes;

  @override
  UserDetailsMd({
    required this.account,
    required this.address,
    this.date_of_birth,
    required this.ethnic,
    required this.first_name,
    required this.last_name,
    required this.marital_status,
    required this.nationality,
    required this.next_of_kin,
    required this.notes,
    required this.payroll,
    required this.phones,
    required this.religion,
    required this.title,
  });

  factory UserDetailsMd.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsMdFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsMdToJson(this);
}

@JsonSerializable(anyMap: true)
class UserDetailsAddressMd {
  String line1;
  String line2;
  String city;
  String country;
  String postcode;
  String county;

  @override
  UserDetailsAddressMd({
    required this.city,
    required this.country,
    required this.county,
    required this.line1,
    required this.line2,
    required this.postcode,
  });

  factory UserDetailsAddressMd.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsAddressMdFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsAddressMdToJson(this);
}

@JsonSerializable(anyMap: true)
class UserDetailsPhonesMd {
  String mobile;
  String landline;

  @override
  UserDetailsPhonesMd({
    required this.landline,
    required this.mobile,
  });

  factory UserDetailsPhonesMd.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsPhonesMdFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsPhonesMdToJson(this);
}

@JsonSerializable(anyMap: true)
class UserDetailsNextOfKinMd {
  String name;
  String relation;
  String phone;

  @override
  UserDetailsNextOfKinMd({
    required this.name,
    required this.phone,
    required this.relation,
  });

  factory UserDetailsNextOfKinMd.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsNextOfKinMdFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsNextOfKinMdToJson(this);
}

@JsonSerializable(anyMap: true)
class UserDetailsPayrollMd {
  String payroll_code;
  String national_insurance;

  @override
  UserDetailsPayrollMd({
    required this.payroll_code,
    required this.national_insurance,
  });

  factory UserDetailsPayrollMd.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsPayrollMdFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsPayrollMdToJson(this);
}

@JsonSerializable(anyMap: true)
class UserDetailsAccountMd {
  bool active;
  bool login_required;
  String group;
  bool group_admin;
  String location;
  bool location_admin;
  dynamic locked;
  String login_methods;

  @override
  UserDetailsAccountMd({
    required this.active,
    required this.group,
    required this.group_admin,
    required this.location,
    required this.location_admin,
    required this.login_methods,
    required this.login_required,
    this.locked,
  });

  factory UserDetailsAccountMd.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsAccountMdFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsAccountMdToJson(this);
}
