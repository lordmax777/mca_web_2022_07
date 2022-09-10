import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';

@immutable
class SavedUserState {
  TextEditingController username;
  TextEditingController upass;
  TextEditingController upassRepeat;
  CodeMap title;
  TextEditingController firstName;
  TextEditingController lastName;
  DateTime? birthdate;
  CodeMap nationalityCountryCode;
  CodeMap religionId;
  CodeMap ethnicId;
  CodeMap maritalStatusCode;
  TextEditingController nationalInsuranceNo;
  TextEditingController phoneLandline;
  TextEditingController phoneMobile;
  TextEditingController nextOfKinName;
  TextEditingController nextOfKinPhone;
  TextEditingController nextOfKinRelation;
  TextEditingController addressLine1;
  String addressLine2;
  TextEditingController addressCity;
  CodeMap addressCountry;
  TextEditingController addressPostcode;
  TextEditingController payrollCode;
  TextEditingController notes;
  CodeMap isActivate;
  TextEditingController exEmail;
  double latitude;
  double longitude;
  CodeMap languageCode;
  CodeMap roleCode;
  CodeMap groupId;
  bool isGrouoAdmin;
  CodeMap locationId;
  bool locationAdmin;
  bool loginRequired;
  LoginMethds loginMethods;
  String? photo;
  TextEditingController county;

  SavedUserState({
    required this.username,
    required this.upass,
    required this.upassRepeat,
    required this.county,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.nationalityCountryCode,
    required this.religionId,
    required this.ethnicId,
    required this.maritalStatusCode,
    required this.nationalInsuranceNo,
    required this.phoneLandline,
    required this.phoneMobile,
    required this.nextOfKinName,
    required this.nextOfKinPhone,
    required this.nextOfKinRelation,
    required this.addressLine1,
    required this.addressLine2,
    required this.addressCity,
    required this.addressCountry,
    required this.addressPostcode,
    required this.payrollCode,
    required this.notes,
    required this.isActivate,
    required this.exEmail,
    required this.latitude,
    required this.longitude,
    required this.languageCode,
    required this.roleCode,
    required this.groupId,
    required this.isGrouoAdmin,
    required this.locationId,
    required this.locationAdmin,
    required this.loginRequired,
    required this.loginMethods,
    required this.photo,
  });

  factory SavedUserState.initial() {
    return SavedUserState(
      username: TextEditingController(),
      upass: TextEditingController(),
      upassRepeat: TextEditingController(),
      title: CodeMap(code: null, name: null),
      firstName: TextEditingController(),
      lastName: TextEditingController(),
      birthdate: null,
      nationalityCountryCode: CodeMap(code: null, name: null),
      addressCity: TextEditingController(),
      addressLine1: TextEditingController(),
      addressPostcode: TextEditingController(),
      addressCountry: CodeMap(code: null, name: null),
      addressLine2: '',
      exEmail: TextEditingController(),
      ethnicId: CodeMap(code: null, name: null),
      groupId: CodeMap(code: null, name: null),
      isActivate: CodeMap(code: null, name: null),
      isGrouoAdmin: false,
      languageCode: CodeMap(code: null, name: null),
      locationAdmin: false,
      locationId: CodeMap(code: null, name: null),
      loginMethods: LoginMethds(),
      loginRequired: false,
      maritalStatusCode: CodeMap(code: null, name: null),
      notes: TextEditingController(),
      nextOfKinName: TextEditingController(),
      nextOfKinPhone: TextEditingController(),
      nextOfKinRelation: TextEditingController(),
      payrollCode: TextEditingController(),
      phoneLandline: TextEditingController(),
      phoneMobile: TextEditingController(),
      photo: null,
      religionId: CodeMap(code: null, name: null),
      latitude: 0,
      longitude: 0,
      nationalInsuranceNo: TextEditingController(),
      roleCode: CodeMap(code: null, name: null),
      county: TextEditingController(),
    );
  }

  SavedUserState copyWith({
    TextEditingController? username,
    TextEditingController? upass,
    TextEditingController? upassRepeat,
    CodeMap? title,
    TextEditingController? firstName,
    TextEditingController? lastName,
    DateTime? birthdate,
    CodeMap? nationalityCountryCode,
    CodeMap? religionId,
    CodeMap? ethnicId,
    CodeMap? maritalStatusCode,
    TextEditingController? nationalInsuranceNo,
    TextEditingController? phoneLandline,
    TextEditingController? phoneMobile,
    TextEditingController? nextOfKinName,
    TextEditingController? nextOfKinPhone,
    TextEditingController? nextOfKinRelation,
    TextEditingController? addressLine1,
    String? addressLine2,
    TextEditingController? addressCity,
    CodeMap? addressCountry,
    TextEditingController? addressPostcode,
    TextEditingController? payrollCode,
    TextEditingController? notes,
    CodeMap? isActivate,
    TextEditingController? exEmail,
    double? latitude,
    double? longitude,
    CodeMap? languageCode,
    CodeMap? roleCode,
    CodeMap? groupId,
    bool? isGrouoAdmin,
    CodeMap? locationId,
    bool? locationAdmin,
    bool? loginRequired,
    LoginMethds? loginMethods,
    String? photo,
    TextEditingController? county,
  }) {
    return SavedUserState(
      username: username ?? this.username,
      upass: upass ?? this.upass,
      upassRepeat: upassRepeat ?? this.upassRepeat,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      nationalityCountryCode:
          nationalityCountryCode ?? this.nationalityCountryCode,
      addressCity: addressCity ?? this.addressCity,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressPostcode: addressPostcode ?? this.addressPostcode,
      addressCountry: addressCountry ?? this.addressCountry,
      addressLine2: addressLine2 ?? this.addressLine2,
      exEmail: exEmail ?? this.exEmail,
      ethnicId: ethnicId ?? this.ethnicId,
      groupId: groupId ?? this.groupId,
      isActivate: isActivate ?? this.isActivate,
      isGrouoAdmin: isGrouoAdmin ?? this.isGrouoAdmin,
      languageCode: languageCode ?? this.languageCode,
      locationAdmin: locationAdmin ?? this.locationAdmin,
      locationId: locationId ?? this.locationId,
      loginMethods: loginMethods ?? this.loginMethods,
      loginRequired: loginRequired ?? this.loginRequired,
      maritalStatusCode: maritalStatusCode ?? this.maritalStatusCode,
      notes: notes ?? this.notes,
      nextOfKinName: nextOfKinName ?? this.nextOfKinName,
      nextOfKinPhone: nextOfKinPhone ?? this.nextOfKinPhone,
      nextOfKinRelation: nextOfKinRelation ?? this.nextOfKinRelation,
      payrollCode: payrollCode ?? this.payrollCode,
      phoneLandline: phoneLandline ?? this.phoneLandline,
      phoneMobile: phoneMobile ?? this.phoneMobile,
      photo: photo,
      religionId: religionId ?? this.religionId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      nationalInsuranceNo: nationalInsuranceNo ?? this.nationalInsuranceNo,
      roleCode: roleCode ?? this.roleCode,
      county: county ?? this.county,
    );
  }
}

class UpdateSavedUserStateAction {
  TextEditingController? username;
  TextEditingController? upass;
  TextEditingController? upassRepeat;
  CodeMap? title;
  TextEditingController? firstName;
  TextEditingController? lastName;
  DateTime? birthdate;
  CodeMap? nationalityCountryCode;
  CodeMap? religionId;
  CodeMap? ethnicId;
  CodeMap? maritalStatusCode;
  TextEditingController? nationalInsuranceNo;
  TextEditingController? phoneLandline;
  TextEditingController? phoneMobile;
  TextEditingController? nextOfKinName;
  TextEditingController? nextOfKinPhone;
  TextEditingController? nextOfKinRelation;
  TextEditingController? addressLine1;
  String? addressLine2;
  TextEditingController? addressCity;
  CodeMap? addressCountry;
  TextEditingController? addressPostcode;
  TextEditingController? payrollCode;
  TextEditingController? notes;
  CodeMap? isActivate;
  TextEditingController? exEmail;
  double? latitude;
  double? longitude;
  CodeMap? languageCode;
  CodeMap? roleCode;
  CodeMap? groupId;
  bool? isGrouoAdmin;
  CodeMap? locationId;
  bool? locationAdmin;
  bool? loginRequired;
  LoginMethds? loginMethods;
  String? photo;
  TextEditingController? county;

  bool isInit;
  UpdateSavedUserStateAction({
    this.isInit = false,
    this.username,
    this.upass,
    this.upassRepeat,
    this.title,
    this.firstName,
    this.lastName,
    this.birthdate,
    this.nationalityCountryCode,
    this.religionId,
    this.ethnicId,
    this.maritalStatusCode,
    this.nationalInsuranceNo,
    this.phoneLandline,
    this.phoneMobile,
    this.nextOfKinName,
    this.nextOfKinPhone,
    this.nextOfKinRelation,
    this.addressLine1,
    this.addressLine2,
    this.addressCity,
    this.addressCountry,
    this.addressPostcode,
    this.payrollCode,
    this.notes,
    this.isActivate,
    this.exEmail,
    this.latitude,
    this.longitude,
    this.languageCode,
    this.roleCode,
    this.groupId,
    this.isGrouoAdmin,
    this.locationId,
    this.locationAdmin,
    this.loginRequired,
    this.loginMethods,
    this.photo,
    this.county,
  }) {
    appStore.dispatch(UpdateUsersStateAction(isInit: isInit));
  }
}
