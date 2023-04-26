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

  int id;
  String name;
  String? contact;
  String? company;
  bool active;
  String notes;
  String? email;
  String? phone;
  String? fax;
  String? startDate;
  String? endDate;
  num? creditLimit;
  dynamic invoices;
  dynamic payments;
  Address address;
  String? companyRegNumber;
  String? VATnumber;
  bool? VATcalc;
  String currencyId;
  String? paymentMethodId;
  int payingDays;

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
    this.startDate,
    this.endDate,
    required this.creditLimit,
    this.invoices,
    this.payments,
    required this.address,
    this.companyRegNumber,
    this.VATnumber,
    this.VATcalc,
    required this.currencyId,
    this.paymentMethodId,
    required this.payingDays,
  });

  factory ClientInfoMd.fromJson(Map<String, dynamic> json) {
    try {
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
    } on TypeError catch (e) {
      print('ClientInfoMd.fromJson: ${e.stackTrace}');
      rethrow;
    }
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

  // init
  static ClientInfoMd init() {
    return ClientInfoMd(
      id: 0,
      name: '',
      contact: '',
      company: '',
      active: true,
      notes: '',
      email: '',
      phone: '',
      fax: '',
      startDate: '',
      endDate: '',
      creditLimit: 0,
      invoices: null,
      payments: null,
      address: Address.init(),
      companyRegNumber: '',
      VATnumber: '',
      VATcalc: true,
      currencyId: '',
      paymentMethodId: '',
      payingDays: 0,
    );
  }
}
