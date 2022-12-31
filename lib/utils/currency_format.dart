import 'package:intl/intl.dart';

import '../manager/general_controller.dart';
import '../manager/models/company_md.dart';

class CurrencyFormatter {
  int decimalPoints;
  bool withSymbol;
  CurrencyFormatter({this.decimalPoints = 0, this.withSymbol = true});
  // Currency? getCurrency(){
  static Currency? currency = GeneralController.to.companyInfo.currency;

  //   return currency;
  // }

  static String? symbol = currency?.sign;
  int decimalDigits = currency?.digits ?? 0;
  static bool isRightSymbol = currency?.signFront ?? false;
  String format = isRightSymbol ? "#,###.## \u00A4" : "\u00A4 #,###.##";

  //Korean currency formatter
  NumberFormat get krCurrency => NumberFormat.currency(
      locale: "ko_KR",
      decimalDigits: decimalPoints,
      customPattern: '#,##0\u00A0${withSymbol ? "원" : ""}');

  //Russian currency formatter
  NumberFormat get ruCurrency => NumberFormat.currency(
      locale: "ru_RU",
      decimalDigits: decimalPoints,
      symbol: withSymbol ? '₽' : '');

  //Kazakh currency formatter
  NumberFormat get kzCurrency => NumberFormat.currency(
      locale: "kk_KZ",
      decimalDigits: decimalPoints,
      symbol: withSymbol ? '\u20B8' : '');

  //USD currency formatter
  NumberFormat get enCurrency =>
      NumberFormat.currency(locale: "en_US", decimalDigits: decimalPoints);

  //UK currency formatter
  NumberFormat get ukCurrency => NumberFormat.currency(
      locale: "en_GB",
      decimalDigits: decimalDigits,
      symbol: symbol ?? '',
      customPattern: format);
}

String currencyFormatter(num number,
    {CurrencyLocale locale = CurrencyLocale.UK,
    int decimalPoints = 0,
    bool withSymbol = true}) {
  switch (locale) {
    case CurrencyLocale.UK:
      return CurrencyFormatter(
              decimalPoints: decimalPoints, withSymbol: withSymbol)
          .ukCurrency
          .format(number)
          .toString();

    case CurrencyLocale.EN:
      return CurrencyFormatter(
              decimalPoints: decimalPoints, withSymbol: withSymbol)
          .enCurrency
          .format(number)
          .toString();
  }
}

enum CurrencyLocale { EN, UK }
