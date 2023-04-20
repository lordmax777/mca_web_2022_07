import 'package:mca_web_2022_07/manager/models/location_item_md.dart';

class ClientInfoMd {
  // {
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
  final String startDate;
  final String? endDate;
  final double creditLimit;
  final String? invoices;
  final String? payments;
  final Address address;
  final String? companyRegNumber;
  final String? VATnumber;
  final bool VATcalc;
  final String currencyId;
  final String paymentMethodId;
  final int payingDays;

  ClientInfoMd({
    required this.id,
    required this.name,
    this.contact,
    this.company,
    required this.active,
    required this.notes,
    this.email,
    this.phone,
    this.fax,
    required this.startDate,
    this.endDate,
    required this.creditLimit,
    this.invoices,
    this.payments,
    required this.address,
    this.companyRegNumber,
    this.VATnumber,
    required this.VATcalc,
    required this.currencyId,
    required this.paymentMethodId,
    required this.payingDays,
  });

  factory ClientInfoMd.fromJson(Map<String, dynamic> json) {
    return ClientInfoMd(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      company: json['company'],
      active: json['active'],
      notes: json['notes'],
      email: json['email'],
      phone: json['phone'],
      fax: json['fax'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      creditLimit: json['creditLimit'],
      invoices: json['invoices'],
      payments: json['payments'],
      address: Address.fromJson(json['address']),
      companyRegNumber: json['companyRegNumber'],
      VATnumber: json['VATnumber'],
      VATcalc: json['VATcalc'],
      currencyId: json['currencyId'],
      paymentMethodId: json['paymentMethodId'],
      payingDays: json['payingDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'company': company,
      'active': active,
      'notes': notes,
      'email': email,
      'phone': phone,
      'fax': fax,
      'startDate': startDate,
      'endDate': endDate,
      'creditLimit': creditLimit,
      'invoices': invoices,
      'payments': payments,
      'address': address.toJson(),
      'companyRegNumber': companyRegNumber,
      'VATnumber': VATnumber,
      'VATcalc': VATcalc,
      'currencyId': currencyId,
      'paymentMethodId': paymentMethodId,
      'payingDays': payingDays,
    };
  }
}
