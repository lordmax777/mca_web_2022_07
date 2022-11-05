import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:mix/mix.dart';

import '../../models/user_details_md.dart';

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

// class UserDetailSaveMd {
//   TextEditingController username;
//   TextEditingController upass;
//   TextEditingController upassRepeat;
//   CodeMap title;
//   TextEditingController firstName;
//   TextEditingController lastName;
//   DateTime? birthdate;
//   CodeMap? nationalityCountryCode;
//   String? religionId;
//   String? ethnicId;
//   CodeMap? maritalStatusCode;
//   TextEditingController nationalInsuranceNo;
//   TextEditingController phoneLandline;
//   TextEditingController phoneMobile;
//   String? nextOfKinName;
//   String? nextOfKinPhone;
//   String? nextOfKinRelation;
//   TextEditingController addressLine1;
//   String? addressLine2;
//   TextEditingController addressCity;
//   String? addressCountry;
//   TextEditingController addressPostcode;
//   TextEditingController payrollCode;
//   TextEditingController notes;
//   CodeMap? isActivate;
//   TextEditingController exEmail;
//   double? latitude;
//   double? longitude;
//   CodeMap? languageCode;
//   CodeMap? roleCode;
//   CodeMap? groupId;
//   bool? isGrouoAdmin;
//   CodeMap? locationId;
//   String? locationAdmin;
//   bool loginRequired;
//   LoginMethds loginMethods;
//   String? photo;

//   static UserDetailSaveMd init() {
//     return UserDetailSaveMd(
//       nationalInsuranceNo: TextEditingController(),
//       payrollCode: TextEditingController(),
//       upass: TextEditingController(),
//       upassRepeat: TextEditingController(),
//       username: TextEditingController(),
//       firstName: TextEditingController(),
//       notes: TextEditingController(),
//       phoneLandline: TextEditingController(),
//       phoneMobile: TextEditingController(),
//       exEmail: TextEditingController(),
//       lastName: TextEditingController(),
//       addressLine1: TextEditingController(),
//       addressCity: TextEditingController(),
//       addressPostcode: TextEditingController(),
//       title: CodeMap(code: null, name: null),
//       loginMethods: LoginMethds(),
//       loginRequired: false,
//     );
//   }

//   static UserDetailSaveMd fromUserDetails(UserDetailsMd userDetailsMd) {
//     final general = appStore.state.generalState.paramList.data!;
//     final loginms = userDetailsMd.account.login_methods
//         .replaceAll(" ", "")
//         .split(',')
//         .map((e) => e.toLowerCase())
//         .toList();
//     return UserDetailSaveMd(
//         loginRequired: userDetailsMd.account.login_required,
//         loginMethods: LoginMethds(
//           api: loginms.contains('api'),
//           mobile: loginms.contains('mobile'),
//           web: loginms.contains('web'),
//           mobileAdmin: loginms.contains('mobileadmin'),
//           tablet: loginms.contains('tablet'),
//         ),
//         nationalInsuranceNo: TextEditingController(),
//         exEmail: TextEditingController(),
//         payrollCode: TextEditingController(),
//         upass: TextEditingController(),
//         upassRepeat: TextEditingController(),
//         username: userDetailsMd.usernam,
//         notes: TextEditingController(text: userDetailsMd.notes),
//         phoneLandline:
//             TextEditingController(text: userDetailsMd.phones.landline),
//         phoneMobile: TextEditingController(text: userDetailsMd.phones.mobile),
//         addressCity: TextEditingController(text: userDetailsMd.address.city),
//         addressLine1: TextEditingController(text: userDetailsMd.address.line1),
//         addressPostcode:
//             TextEditingController(text: userDetailsMd.address.postcode),
//         firstName: TextEditingController(text: userDetailsMd.first_name),
//         lastName: TextEditingController(text: userDetailsMd.last_name),
//         title: CodeMap(
//             name: userDetailsMd.title,
//             code: Constants.userTitleTypes.entries
//                 .firstWhere((element) => element.value == userDetailsMd.title)
//                 .key),
//         birthdate: userDetailsMd.date_of_birth != null
//             ? DateTime.tryParse(userDetailsMd.date_of_birth!.date)
//             : null,
//         nationalityCountryCode: CodeMap(
//             name: userDetailsMd.nationality,
//             code: general.countries
//                 .firstWhere(
//                     (element) => element.name == userDetailsMd.nationality)
//                 .code),
//         maritalStatusCode: CodeMap(
//             name: userDetailsMd.marital_status,
//             code: Constants.userMartialStatusTypes.entries
//                 .firstWhere(
//                     (element) => element.value == userDetailsMd.marital_status)
//                 .key),
//         isActivate: CodeMap(
//           name: Constants.userAccountStatusTypes[userDetailsMd.account.active],
//           code: userDetailsMd.account.active ? 1.toString() : 0.toString(),
//         ));
//   }

//   UserDetailSaveMd({
//     required this.username,
//     required this.upass,
//     required this.upassRepeat,
//     this.photo,
//     required this.title,
//     required this.firstName,
//     required this.lastName,
//     this.birthdate,
//     this.nationalityCountryCode,
//     this.religionId,
//     this.ethnicId,
//     this.maritalStatusCode,
//     required this.nationalInsuranceNo,
//     required this.phoneLandline,
//     required this.phoneMobile,
//     this.nextOfKinName,
//     this.nextOfKinPhone,
//     this.nextOfKinRelation,
//     required this.addressLine1,
//     this.addressLine2,
//     required this.addressCity,
//     this.addressCountry,
//     required this.addressPostcode,
//     required this.payrollCode,
//     required this.notes,
//     this.isActivate,
//     required this.exEmail,
//     this.latitude,
//     this.longitude,
//     this.languageCode,
//     this.roleCode,
//     this.groupId,
//     this.isGrouoAdmin,
//     this.locationId,
//     this.locationAdmin,
//     required this.loginRequired,
//     required this.loginMethods,
//   });
// }

class CodeMap {
  String? name;
  String? code;

  Map toJson() => {
        'name': name,
        'code': code,
      };

  CodeMap({required this.name, required this.code}) {
    if (code != null && code!.isEmpty) {
      code = null;
    }
    if (name != null && name!.isEmpty) {
      name = null;
    }
  }
}

class LoginMethds {
  bool web;
  bool mobile;
  bool tablet;
  bool mobileAdmin;
  bool api;

  List<int> get methodsList {
    List<int> l = [];

    if (web) {
      l.add(1);
    }
    if (mobile) {
      l.add(2);
    }
    if (tablet) {
      l.add(3);
    }
    if (mobileAdmin) {
      l.add(4);
    }
    if (api) {
      l.add(5);
    }

    return l;
  }

  String get methods {
    String list = "";

    for (var element
        in appStore.state.generalState.paramList.data!.login_methods) {
      if (element.name.toLowerCase() == 'web' && web) {
        list = list + element.id.toString();
      }
      if (element.name.toLowerCase() == 'mobile' && mobile) {
        if (web) {
          list = '$list,';
        }
        list = "$list${element.id}";
      }
      if (element.name.toLowerCase() == 'tablet' && tablet) {
        if (web || mobile) {
          list = '$list,';
        }
        list = "$list${element.id}";
      }
      if (element.name.toLowerCase().replaceAll(" ", "") == 'mobileadmin' &&
          mobileAdmin) {
        if (web || mobile || tablet) {
          list = '$list,';
        }
        list = "$list${element.id}";
      }
      if (element.name.toLowerCase() == 'api' && api) {
        if (web || mobile || tablet || mobileAdmin) {
          list = '$list,';
        }
        list = "$list${element.id}";
      }
    }

    return list;
  }

  LoginMethds({
    this.web = false,
    this.mobile = false,
    this.tablet = false,
    this.mobileAdmin = false,
    this.api = false,
  });
}
