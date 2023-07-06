import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/data/data.dart';

final class CompanyInfoMd extends Equatable {
  //{
  //     "name": "BandM TEST",
  //     "domain": "timesheet.skillfill.co.uk",
  //     "timezone": "Europe/London",
  //     "country": "GB",
  //     "currency": {
  //         "code": "GBP",
  //         "sign": "£",
  //         "signFront": true,
  //         "digits": 2
  //     },
  //     "payment_method_id": 3,
  //     "paying_days": 30,
  //     "type": "png",
  //     "rotalength": 2,
  //     "auto_logout": 5,
  //     "auto_sign_out": 35,
  //     "time_validity": 120,
  //     "max_attempts": 3,
  //     "colour_schema_id": 1,
  //     "company_email": "",
  //     "ahe": 1,
  //     "ahew": 5.6,
  //     "hct": 1,
  //     "yearstart": "2018-01-01",
  //     "paid_sickness": 0,
  //     "piw": 8,
  //     "min_rest": 0,
  //     "lunchtime": 0,
  //     "lunchtime_unpaid": 0,
  //     "rounding": 1,
  //     "grace": 15,
  //     "breaks": 0,
  //     "break_time": 0,
  //     "break_time_total": 30,
  //     "min_hours_for_lunch": 6,
  //     "late_reminders": "10",
  //     "long_break_reminders": "15",
  //     "sign_out_reminders": "30",
  //     "photo_required": false,
  //     "strict_location": true,
  //     "undo_time": 120,
  //     "locale": "en",
  //     "status": true,
  //     "show_title": false,
  //     "special_word": "shift"
  // }

  final String name;
  final String domain;
  final String timezone;
  final CurrencyMd currency;
  final num paymentMethodId;
  PaymentMethodMd? paymentMethodMd(List<PaymentMethodMd> list) =>
      list.firstWhereOrNull((element) => element.id == paymentMethodId);
  final num payingDays;
  final String logo;
  Uint8List get logoBytes => base64Decode(logo);
  final String type;
  final num rotalength;
  final num autoLogout;
  final num autoSignOut;
  final num timeValidity;
  final num maxAttempts;
  final num colourSchemaId;
  ColorSchemeMd? colourSchemaMd(List<ColorSchemeMd> list) =>
      list.firstWhereOrNull((element) => element.id == colourSchemaId);
  final String companyEmail;
  final num ahe;
  final num ahew;
  final num hct;
  final String yearstart;
  final num paidSickness;
  final num piw;
  final num minRest;
  final num lunchtime;
  final num lunchtimeUnpaid;
  final num rounding;
  final num grace;
  final num breaks;
  final num breakTime;
  final num breakTimeTotal;
  final num minHoursForLunch;
  final String lateReminders;
  final String longBreakReminders;
  final String signOutReminders;
  final bool photoRequired;
  final bool strictLocation;
  final num undoTime;
  final String locale;
  final bool status;
  final bool showTitle;
  final String specialWord;
  final String country;
  CountryMd? countryMd(List<CountryMd> list) =>
      list.firstWhereOrNull((element) => element.code == country);

  List<int> get weeks =>
      List<int>.generate(rotalength.toInt(), (index) => index + 1);

  const CompanyInfoMd({
    required this.name,
    required this.domain,
    required this.timezone,
    required this.currency,
    required this.paymentMethodId,
    required this.payingDays,
    required this.logo,
    required this.type,
    required this.rotalength,
    required this.autoLogout,
    required this.autoSignOut,
    required this.timeValidity,
    required this.maxAttempts,
    required this.colourSchemaId,
    required this.companyEmail,
    required this.ahe,
    required this.ahew,
    required this.hct,
    required this.yearstart,
    required this.paidSickness,
    required this.piw,
    required this.minRest,
    required this.lunchtime,
    required this.lunchtimeUnpaid,
    required this.rounding,
    required this.grace,
    required this.breaks,
    required this.breakTime,
    required this.breakTimeTotal,
    required this.minHoursForLunch,
    required this.lateReminders,
    required this.longBreakReminders,
    required this.signOutReminders,
    required this.photoRequired,
    required this.strictLocation,
    required this.undoTime,
    required this.locale,
    required this.status,
    required this.showTitle,
    required this.specialWord,
    required this.country,
  });

  @override
  List<Object?> get props => [
        name,
        domain,
        timezone,
        currency,
        paymentMethodId,
        payingDays,
        logo,
        type,
        rotalength,
        autoLogout,
        autoSignOut,
        timeValidity,
        maxAttempts,
        colourSchemaId,
        companyEmail,
        ahe,
        ahew,
        hct,
        yearstart,
        paidSickness,
        piw,
        minRest,
        lunchtime,
        lunchtimeUnpaid,
        rounding,
        grace,
        breaks,
        breakTime,
        breakTimeTotal,
        minHoursForLunch,
        lateReminders,
        longBreakReminders,
        signOutReminders,
        photoRequired,
        strictLocation,
        undoTime,
        locale,
        status,
        showTitle,
        specialWord,
        country,
      ];

  factory CompanyInfoMd.fromJson(Map<String, dynamic> json) => CompanyInfoMd(
        name: json['name'] ?? "",
        domain: json['domain'] ?? '',
        timezone: json['timezone'] ?? '',
        currency: CurrencyMd.fromJson(json['currency'] ?? {}),
        paymentMethodId: json['payment_method_id'] ?? 0,
        payingDays: json['paying_days'] ?? 0,
        logo: json['logo'] ?? '',
        type: json['type'] ?? '',
        rotalength: json['rotalength'] ?? 0,
        autoLogout: json['auto_logout'] ?? 0,
        autoSignOut: json['auto_sign_out'] ?? 0,
        timeValidity: json['time_validity'] ?? 0,
        maxAttempts: json['max_attempts'] ?? 0,
        colourSchemaId: json['colour_schema_id'] ?? 0,
        companyEmail: json['company_email'] ?? '',
        ahe: json['ahe'] ?? 0,
        ahew: json['ahew'] ?? 0,
        hct: json['hct'] ?? 0,
        yearstart: json['yearstart'] ?? '',
        paidSickness: json['paid_sickness'] ?? 0,
        piw: json['piw'] ?? 0,
        minRest: json['min_rest'] ?? 0,
        lunchtime: json['lunchtime'] ?? 0,
        lunchtimeUnpaid: json['lunchtime_unpaid'] ?? 0,
        rounding: json['rounding'] ?? 0,
        grace: json['grace'] ?? 0,
        breaks: json['breaks'] ?? 0,
        breakTime: json['break_time'] ?? 0,
        breakTimeTotal: json['break_time_total'] ?? 0,
        minHoursForLunch: json['min_hours_for_lunch'] ?? 0,
        lateReminders: json['late_reminders'] ?? '',
        longBreakReminders: json['long_break_reminders'] ?? '',
        signOutReminders: json['sign_out_reminders'] ?? '',
        photoRequired: json['photo_required'] ?? false,
        strictLocation: json['strict_location'] ?? false,
        undoTime: json['undo_time'] ?? 0,
        locale: json['locale'] ?? '',
        status: json['status'] ?? false,
        showTitle: json['show_title'] ?? false,
        specialWord: json['special_word'] ?? "property",
        country: json['country'] ?? '',
      );

  //init
  factory CompanyInfoMd.init() => CompanyInfoMd.fromJson(const {});
}
