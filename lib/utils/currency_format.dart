import 'package:intl/intl.dart';

import '../manager/general_controller.dart';
import '../manager/models/company_md.dart';

class CurrencyFormatter {
  int decimalPoints;
  bool withSymbol;
  CurrencyFormatter({this.decimalPoints = 0, this.withSymbol = true});
  CompanyMd get company => GeneralController.to.companyInfo;
  Currency? get currency => company.currency;

  //Company Currency formatter
  NumberFormat get companyCurrency {
    final String? symbol = currency?.sign;
    final int decimalDigits = currency?.digits ?? 0;
    final bool isRightSymbol = !(currency?.signFront ?? false);
    final String format = isRightSymbol ? "#,###.## \u00A4" : "\u00A4 #,###.##";
    return NumberFormat.currency(
        locale: company.locale,
        decimalDigits: decimalDigits,
        symbol: symbol ?? '',
        customPattern: format);
  }
}

String currencyFormatter(num number,
    {CurrencyLocale locale = CurrencyLocale.UK,
    int decimalPoints = 0,
    bool withSymbol = true}) {
  return CurrencyFormatter(decimalPoints: decimalPoints, withSymbol: withSymbol)
      .companyCurrency
      .format(number)
      .toString();
}

enum CurrencyLocale { EN, UK }
