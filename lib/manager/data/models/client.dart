import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/data/data.dart';

final class ClientMd extends Equatable {
  //{
  //         "id": 2,
  //         "name": "kashiba house owners 1",
  //         "contact": null,
  //         "company": "kashiba house owners",
  //         "active": true,
  //         "notes": "",
  //         "email": "dipen1005@gmail.com",
  //         "phone": "07905204344",
  //         "fax": null,
  //         "startDate": "2023-10-12",
  //         "endDate": "2024-10-11",
  //         "creditLimit": null,
  //         "invoices": 12834.6,
  //         "payments": null,
  //         "address": {
  //             "line1": "hashob",
  //             "line2": "",
  //             "city": "ksd",
  //             "county": "",
  //             "postcode": "ha62th",
  //             "country": "GB"
  //         },
  //         "companyRegNumber": null,
  //         "VATnumber": null,
  //         "VATcalc": true,
  //         "currencyId": "1",
  //         "paymentMethodId": "1",
  //         "payingDays": 30,
  //         "invoicePeriodId": "2",
  //         "invoiceDay": null
  //     }

  final int id;
  final String name;
  final String? contact;
  final String? company;
  final bool active;
  final String notes;
  final String? email;
  final String? phone;
  final String? fax;
  final String? startDate;
  DateTime? get startDateDt => DateTime.tryParse(startDate ?? '');
  final String? endDate;
  DateTime? get endDateDt => DateTime.tryParse(endDate ?? '');
  final num? creditLimit;
  final num? invoices;
  final num? payments;
  final AddressMd address;
  final String? companyRegNumber;
  final String? currencyId;
  CurrencyMd? getCurrencyMd(List<CurrencyMd> currencies) =>
      currencies.firstWhereOrNull(
          (element) => element.id == int.tryParse(currencyId ?? ""));
  final String? paymentMethodId;
  PaymentMethodMd? getPaymentMethodMd(List<PaymentMethodMd> paymentMethods) =>
      paymentMethods.firstWhereOrNull(
          (element) => element.id == int.tryParse(paymentMethodId ?? ""));
  final int payingDays;
  final String? invoicePeriodId;
  InvoicePeriod? getInvoicePeriod(List<InvoicePeriod> invoicePeriods) =>
      invoicePeriods.firstWhereOrNull(
          (element) => element.id == int.tryParse(invoicePeriodId ?? ""));
  final int? invoiceDay;

  const ClientMd({
    required this.id,
    required this.name,
    required this.contact,
    required this.company,
    required this.active,
    required this.notes,
    required this.email,
    required this.phone,
    required this.fax,
    required this.startDate,
    required this.endDate,
    required this.creditLimit,
    required this.invoices,
    required this.payments,
    required this.address,
    required this.companyRegNumber,
    required this.currencyId,
    required this.paymentMethodId,
    required this.payingDays,
    required this.invoicePeriodId,
    required this.invoiceDay,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        contact,
        company,
        active,
        notes,
        email,
        phone,
        fax,
        startDate,
        endDate,
        creditLimit,
        invoices,
        payments,
        address,
        companyRegNumber,
        currencyId,
        paymentMethodId,
        payingDays,
        invoicePeriodId,
        invoiceDay,
      ];

  //fromJson
  factory ClientMd.fromJson(Map<String, dynamic> json) {
    try {
      return ClientMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        contact: json['contact'],
        company: json['company'],
        active: json['active'] ?? false,
        notes: json['notes'] ?? "",
        email: json['email'],
        phone: json['phone'],
        fax: json['fax'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        creditLimit: json['creditLimit'],
        invoices: json['invoices'],
        payments: json['payments'],
        address:
            AddressMd.fromJson((json['address'] ?? {}) as Map<String, dynamic>),
        companyRegNumber: json['companyRegNumber'],
        currencyId: json['currencyId'],
        paymentMethodId: json['paymentMethodId'],
        payingDays: json['payingDays'] ?? 0,
        invoicePeriodId: json['invoicePeriodId'],
        invoiceDay: json['invoiceDay'],
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }
}
