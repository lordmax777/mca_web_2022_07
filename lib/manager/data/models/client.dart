import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/data/data.dart';

final class ClientMd extends Equatable {
  //{
  //         "id": 2,
  //         "name": "kashiba house owners",
  //         "contact": null,
  //         "company": null,
  //         "active": true,
  //         "notes": "",
  //         "email": null,
  //         "phone": null,
  //         "fax": null,
  //         "startDate": "2019-04-17",
  //         "endDate": null,
  //         "creditLimit": 1000,
  //         "invoices": null,
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
  //         "payingDays": 30
  //     },

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
      ];

  //fromJson
  factory ClientMd.fromJson(Map<String, dynamic> json) => ClientMd(
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
      );
}
