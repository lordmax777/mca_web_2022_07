import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

@immutable
class StateValue<T> {
  ErrorModel error;
  T? data;

  StateValue({this.data, required this.error});
}

class ErrorModel<T> {
  ///If needs to save data before fail
  dynamic data;
  //isError boolean value is to check if fail or not.
  ///This will help to show proper data after checking the above condition.
  ///By Default it is true
  bool isError;

  ///Error Message in order to show it to the UI
  String? errorMessage;

  ///Error Code is to handle the error by code or show to the UI
  int? errorCode;
  //Retries is incremented every time it fails. If isError == true, make it 0!
  ///By Default it is 0
  int retries;

  T? action;

  bool isLoading;

  Response<dynamic>? rawError;

  ErrorModel({
    this.isError = true,
    this.errorMessage,
    this.action,
    this.isLoading = false,
    this.errorCode,
    this.data,
    this.retries = 0,
    this.rawError,
  });
}

class UserDetailSaveMd {
  String? username;
  String? upass;
  String? title;
  TextEditingController firstName;
  TextEditingController lastName;
  DateTime? birthdate;
  Map<String, String>? nationalityCountryCode;
  String? religionId;
  String? ethnicId;
  String? maritalStatusCode;
  String? nationalInsuranceNo;
  String? phoneLandline;
  String? phoneMobile;
  String? nextOfKinName;
  String? nextOfKinPhone;
  String? nextOfKinRelation;
  TextEditingController addressLine1;
  String? addressLine2;
  TextEditingController addressCity;
  String? addressCountry;
  TextEditingController addressPostcode;
  String? payrollCode;
  String? notes;
  bool? isActivate;
  String? exEmail;
  double? latitude;
  double? longitude;
  String? languageCode;
  String? roleCode;
  String? groupId;
  bool? isGrouoAdmin;
  String? locationId;
  String? locationAdmin;
  bool? loginRequired;
  List<int>? loginMethods;

  UserDetailSaveMd({
    this.username,
    this.upass,
    this.title,
    required this.firstName,
    required this.lastName,
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
    required this.addressLine1,
    this.addressLine2,
    required this.addressCity,
    this.addressCountry,
    required this.addressPostcode,
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
  });
}
