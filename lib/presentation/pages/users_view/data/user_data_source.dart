import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/utils/utils.dart';

class UserDataSource extends Equatable {
  final Personal personal;
  final RoleDepartmentLoginOptions roleDepartmentLoginOptions;
  final Address address;
  final Religion religion;
  final NextOfKin nextOfKin;

  const UserDataSource({
    required this.personal,
    required this.roleDepartmentLoginOptions,
    required this.address,
    required this.religion,
    required this.nextOfKin,
  });

  @override
  List<Object?> get props => [
        personal,
        roleDepartmentLoginOptions,
        address,
        religion,
        nextOfKin,
      ];

  //copyWith
  UserDataSource copyWith({
    Personal? personal,
    RoleDepartmentLoginOptions? roleDepartmentLoginOptions,
    Address? address,
    Religion? religion,
    NextOfKin? nextOfKin,
  }) {
    return UserDataSource(
      personal: personal ?? this.personal,
      roleDepartmentLoginOptions:
          roleDepartmentLoginOptions ?? this.roleDepartmentLoginOptions,
      address: address ?? this.address,
      religion: religion ?? this.religion,
      nextOfKin: nextOfKin ?? this.nextOfKin,
    );
  }

  //factory init
  factory UserDataSource.init({List<LoginMethodMd>? loginMethods}) {
    return UserDataSource(
      religion: const Religion(),
      personal: Personal(
        dateOfBirth: kDebugMode ? DateTime(2000, 05, 22) : null,
        phoneLandline: TextEditingController(
            text: kDebugMode ? "phonelandline202306" : null),
        payrollCode: TextEditingController(
            text: kDebugMode ? "payrollcode202306" : null),
        firstName: TextEditingController(
          text: kDebugMode ? "firstName202306" : null,
        ),
        email: TextEditingController(
          text: kDebugMode ? "email202306@gmail.com" : null,
        ),
        password: TextEditingController(
          text: kDebugMode ? "password202306" : null,
        ),
        confirmPassword: TextEditingController(
          text: kDebugMode ? "password202306" : null,
        ),
        lastName: TextEditingController(
          text: kDebugMode ? "lastName202306" : null,
        ),
        phoneNumber: TextEditingController(
          text: kDebugMode ? "phoneNumber202306" : null,
        ),
        username: TextEditingController(text: "* Auto Generated *"),
      ),
      roleDepartmentLoginOptions: RoleDepartmentLoginOptions(
        notes: TextEditingController(
          text: kDebugMode ? "notes202306" : null,
        ),
        nationalInsuranceNumber: TextEditingController(
          text: kDebugMode ? "nationalInsuranceNumber202306" : null,
        ),
        loginMethods: [if (loginMethods != null) ...loginMethods],
      ),
      address: Address(
        line1: TextEditingController(
          text: kDebugMode ? "line1202306" : null,
        ),
        line2: TextEditingController(
          text: kDebugMode ? "line2202306" : null,
        ),
        city: TextEditingController(
          text: kDebugMode ? "city202306" : null,
        ),
        county: TextEditingController(
          text: kDebugMode ? "county202306" : null,
        ),
        postcode: TextEditingController(
          text: kDebugMode ? "202306" : null,
        ),
      ),
      nextOfKin: NextOfKin(
        phoneNumber: TextEditingController(
          text: kDebugMode ? "phoneNumber202306" : null,
        ),
        name: TextEditingController(
          text: kDebugMode ? "name202306" : null,
        ),
        relationship: TextEditingController(
          text: kDebugMode ? "relationship202306" : null,
        ),
      ),
    );
  }

  void dispose() {
    personal.dispose();
    roleDepartmentLoginOptions.dispose();
    address.dispose();
    religion.dispose();
    nextOfKin.dispose();
  }

  //Validate
  bool isValid(BuildContext context, bool isCreate) {
    if (!personal.isValid(context, isCreate) ||
        !roleDepartmentLoginOptions.isValid(context) ||
        !address.isValid(context)) {
      return false;
    }
    return true;
  }

  factory UserDataSource.fromJson(
    Map<String, dynamic> json, {
    required List<CountryMd> countries,
    required List<MaritalStatusMd> maritalStatuses,
    required List<UserTitleMd> userTitles,
    required List<RoleMd> roles,
    required List<EthnicMd> ethnics,
    required List<ReligionMd> religions,
    required List<GroupMd> departments,
    required List<LocationShortMd> locations,
    required List<LanguageMd> languages,
    required List<LoginMethodMd> loginMethods,
  }) {
    return UserDataSource(
      personal: Personal.fromJson(
          json['details'], countries, maritalStatuses, userTitles),
      address: Address.fromJson(json['details'], countries: countries),
      nextOfKin: NextOfKin.fromJson(json['details']),
      religion: Religion.fromJson(json['details'], religions, ethnics),
      roleDepartmentLoginOptions: RoleDepartmentLoginOptions.fromJson(
          json['details'],
          roles,
          departments,
          locations,
          languages,
          loginMethods),
    );
  }
}

final class Personal extends Equatable {
  final int? id;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController phoneNumber;
  final TextEditingController phoneLandline;
  final TextEditingController username;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final TextEditingController payrollCode;
  final UserTitleMd? userTitle;
  final MaritalStatusMd? maritalStatus;
  final CountryMd? nationality;
  final DateTime? dateOfBirth;
  final bool isActive;

  const Personal({
    this.id,
    this.dateOfBirth,
    this.isActive = true,
    this.userTitle,
    this.maritalStatus,
    this.nationality,
    required this.email,
    required this.phoneLandline,
    required this.password,
    required this.confirmPassword,
    required this.payrollCode,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.username,
  });

  //copyWith
  Personal copyWith({
    int? id,
    UserTitleMd? userTitle,
    MaritalStatusMd? maritalStatus,
    CountryMd? nationality,
    DateTime? dateOfBirth,
    bool? isActive,
  }) {
    return Personal(
      id: id ?? this.id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      payrollCode: payrollCode,
      phoneLandline: phoneLandline,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      nationality: nationality ?? this.nationality,
      userTitle: userTitle ?? this.userTitle,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phoneNumber,
        maritalStatus,
        nationality,
        userTitle,
        dateOfBirth,
        isActive,
        username,
        password,
        confirmPassword,
        payrollCode,
        phoneLandline,
        id,
      ];

  //Validate
  bool isValid(BuildContext context, bool isCreate) {
    if (!isCreate) {
      if (firstName.text.isEmpty || lastName.text.isEmpty) {
        context.showError(
            "Please fill in ${firstName.text.isEmpty ? "first name, " : ""}${lastName.text.isEmpty ? "last name, " : ""}");
        return false;
      } else {
        return true;
      }
    }

    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      context.showError(
          "Please fill in ${firstName.text.isEmpty ? "first name, " : ""}${lastName.text.isEmpty ? "last name, " : ""}${password.text.isEmpty ? "password, " : ""}${confirmPassword.text.isEmpty ? "confirm password, " : ""}");
      return false;
    }
    return true;
  }

  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phoneNumber.dispose();
    username.dispose();
    password.dispose();
    confirmPassword.dispose();
    payrollCode.dispose();
  }

  //fromJson
  factory Personal.fromJson(
      Map<String, dynamic> json,
      List<CountryMd> countries,
      List<MaritalStatusMd> maritalStatuses,
      List<UserTitleMd> userTitles) {
    return Personal(
      id: null,
      username: TextEditingController(),
      password: TextEditingController(),
      email: TextEditingController(text: json['email']),
      confirmPassword: TextEditingController(),
      isActive: json['account'] is String ? false : json['account']['active'],
      payrollCode: TextEditingController(
          text: json['payroll'] is String
              ? null
              : json['payroll']['payroll_code']),
      firstName: TextEditingController(text: json['first_name']),
      lastName: TextEditingController(text: json['last_name']),
      phoneNumber: TextEditingController(text: json['phones']['mobile']),
      phoneLandline: TextEditingController(text: json['phones']['landline']),
      nationality: countries
          .firstWhereOrNull((element) => element.name == json['nationality']),
      maritalStatus: maritalStatuses.firstWhereOrNull(
          (element) => element.name == json['marital_status']),
      userTitle: userTitles
          .firstWhereOrNull((element) => element.name == json['title']),
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth']['date'])
          : null,
    );
  }
}

final class RoleDepartmentLoginOptions extends Equatable {
  final RoleMd? role;
  final GroupMd? department;
  final LocationShortMd? location;
  final LanguageMd? language;
  final TextEditingController notes;
  final TextEditingController nationalInsuranceNumber;
  final bool isDepartmentManager;
  final bool isLocationManager;
  final List<LoginMethodMd> loginMethods;

  const RoleDepartmentLoginOptions({
    this.role,
    this.department,
    this.location,
    this.language,
    required this.notes,
    required this.nationalInsuranceNumber,
    this.isDepartmentManager = false,
    this.isLocationManager = false,
    required this.loginMethods,
  });

  //copyWith
  RoleDepartmentLoginOptions copyWith({
    RoleMd? role,
    GroupMd? department,
    LocationShortMd? location,
    LanguageMd? language,
    bool? isDepartmentManager,
    bool? isLocationManager,
    List<LoginMethodMd>? loginMethods,
  }) {
    return RoleDepartmentLoginOptions(
      notes: notes,
      nationalInsuranceNumber: nationalInsuranceNumber,
      role: role ?? this.role,
      department: department ?? this.department,
      location: location ?? this.location,
      language: language ?? this.language,
      isDepartmentManager: isDepartmentManager ?? this.isDepartmentManager,
      isLocationManager: isLocationManager ?? this.isLocationManager,
      loginMethods: loginMethods ?? this.loginMethods,
    );
  }

  @override
  List<Object?> get props => [
        role,
        department,
        location,
        language,
        notes,
        nationalInsuranceNumber,
        isDepartmentManager,
        isLocationManager,
        loginMethods,
      ];

  //Validate
  bool isValid(BuildContext context) {
    if (role == null) {
      context.showError("Please select role");
      return false;
    }
    return true;
  }

  void dispose() {
    notes.dispose();
    nationalInsuranceNumber.dispose();
  }

  //fromJson
  factory RoleDepartmentLoginOptions.fromJson(
      Map<String, dynamic> json,
      List<RoleMd> roles,
      List<GroupMd> departments,
      List<LocationShortMd> locations,
      List<LanguageMd> languages,
      List<LoginMethodMd> loginMethods) {
    final String loginMs =
        json['account'] is String ? "" : json['account']['login_methods'];
    final loginMethodMds = loginMs.split(",").map((e) => e.trim()).toList();
    final List<LoginMethodMd> lm = [...loginMethods]
      ..removeWhere((element) => !loginMethodMds.contains(element.name));

    return RoleDepartmentLoginOptions(
      nationalInsuranceNumber: TextEditingController(
          text: json['payroll'] is String
              ? null
              : json['payroll']['national_insurance']),
      role: json['account'] is String
          ? null
          : roles.firstWhereOrNull(
              (element) => element.code == json['account']['role']),
      department: json['account'] is String
          ? null
          : departments.firstWhereOrNull(
              (element) => element.name == json['account']['group']),
      location: json['account'] is String
          ? null
          : locations.firstWhereOrNull(
              (element) => element.name == json['account']['location']),
      language: json['account'] is String
          ? null
          : languages.firstWhereOrNull(
              (element) => element.code == json['account']['locale']),
      notes: TextEditingController(text: json['notes']),
      isDepartmentManager:
          json['account'] is String ? null : json['account']['group_admin'],
      isLocationManager:
          json['account'] is String ? null : json['account']['location_admin'],
      loginMethods: lm,
    );
  }
}

final class Address extends Equatable {
  final TextEditingController line1;
  final TextEditingController line2;
  final TextEditingController city;
  final TextEditingController county;
  final TextEditingController postcode;
  final CountryMd? country;
  final int? locationId;

  final double? latitude;
  final double? longitude;

  const Address({
    required this.line1,
    required this.line2,
    required this.city,
    required this.county,
    required this.postcode,
    this.country,
    this.locationId,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        line1,
        line2,
        city,
        county,
        postcode,
        country,
        locationId,
        latitude,
        longitude,
      ];

  //copyWith
  Address copyWith({
    CountryMd? country,
    double? latitude,
    double? longitude,
    int? locationId,
  }) {
    return Address(
      line1: line1,
      line2: line2,
      city: city,
      county: county,
      postcode: postcode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      locationId: locationId ?? this.locationId,
      longitude: longitude ?? this.longitude,
    );
  }

  //Validate
  bool isValid(BuildContext context) {
    if (line1.text.isEmpty ||
        city.text.isEmpty ||
        postcode.text.isEmpty ||
        country == null) {
      context.showError(
          "Please fill ${line1.text.isEmpty ? "address line 1, " : ""}${city.text.isEmpty ? "city, " : ""}${postcode.text.isEmpty ? "postcode, " : ""}${country == null ? "country, " : ""}");
      return false;
    }
    return line1.text.isNotEmpty &&
        city.text.isNotEmpty &&
        postcode.text.isNotEmpty &&
        country != null;
  }

  void dispose() {
    line1.dispose();
    line2.dispose();
    city.dispose();
    county.dispose();
    postcode.dispose();
  }

  //from json
  factory Address.fromJson(Map<String, dynamic> json,
      {required List<CountryMd> countries}) {
    return Address(
      line1: TextEditingController(
          text: json['address'] is String ? null : json['address']['line1']),
      line2: TextEditingController(
          text: json['address'] is String ? null : json['address']['line2']),
      city: TextEditingController(
          text: json['address'] is String ? null : json['address']['city']),
      county: TextEditingController(
          text: json['address'] is String ? null : json['address']['county']),
      postcode: TextEditingController(
          text: json['address'] is String ? null : json['address']['postcode']),
      country: json['address'] is String
          ? null
          : countries.firstWhereOrNull(
              (element) => element.name == json['address']['country']),
    );
  }
}

final class Religion extends Equatable {
  final EthnicMd? ethnicMd;
  final ReligionMd? religionMd;

  const Religion({
    this.ethnicMd,
    this.religionMd,
  });

  @override
  List<Object?> get props => [
        ethnicMd,
        religionMd,
      ];

  //copyWith
  Religion copyWith({
    EthnicMd? ethnicMd,
    ReligionMd? religionMd,
  }) {
    return Religion(
      ethnicMd: ethnicMd ?? this.ethnicMd,
      religionMd: religionMd ?? this.religionMd,
    );
  }

  void dispose() {}

  //from json
  factory Religion.fromJson(Map<String, dynamic> json,
      List<ReligionMd> religions, List<EthnicMd> ethnics) {
    return Religion(
      ethnicMd:
          ethnics.firstWhereOrNull((element) => element.name == json['ethnic']),
      religionMd: religions
          .firstWhereOrNull((element) => element.name == json['religion']),
    );
  }
}

final class NextOfKin extends Equatable {
  final TextEditingController name;
  final TextEditingController relationship;
  final TextEditingController phoneNumber;

  const NextOfKin({
    required this.name,
    required this.relationship,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        name,
        relationship,
        phoneNumber,
      ];

  void dispose() {
    name.dispose();
    relationship.dispose();
    phoneNumber.dispose();
  }

  //from json
  factory NextOfKin.fromJson(Map<String, dynamic> json) {
    return NextOfKin(
      name: TextEditingController(
          text: json['next_of_kin'] is String
              ? null
              : json['next_of_kin']['name']),
      relationship: TextEditingController(
          text: json['next_of_kin'] is String
              ? null
              : json['next_of_kin']['relation']),
      phoneNumber: TextEditingController(
          text: json['next_of_kin'] is String
              ? null
              : json['next_of_kin']['phone']),
    );
  }
}
