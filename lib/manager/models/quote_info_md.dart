import 'package:flutter/cupertino.dart';

class QuoteInfoMd {
  // {
  //         "id": 1,
  //         "customer_id": "a7ee9e90e0c7ae618bb70b2510c7a394c1234c7909d94b9bdb97392c1b6d7a4a",
  //         "name": "mhgkhgjh",
  //         "company": "test company",
  //         "contact": null,
  //         "company_reg_number": null,
  //         "vat_number": null,
  //         "vat_calc": null,
  //         "active": true,
  //         "phone": "nophone",
  //         "fax": null,
  //         "email": "imre@incze.co.uk",
  //         "address_line1": null,
  //         "address_line2": null,
  //         "address_city": null,
  //         "address_county": null,
  //         "address_country": "GB",
  //         "address_postcode": null,
  //         "notes": null,
  //         "work_address_line1": null,
  //         "work_address_line2": null,
  //         "work_address_city": null,
  //         "work_address_county": null,
  //         "work_address_country": "GB",
  //         "work_address_postcode": null,
  //         "work_start_date": "2023-04-28",
  //         "alt_work_start_date": "2023-04-30",
  //         "work_start_time": "08:00",
  //         "work_finish_time": "12:00",
  //         "work_repeat": 7,
  //         "work_days": [
  //             1,
  //             3,
  //             5,
  //             7
  //         ],
  //         "valid_until": "2023-05-20",
  //         "accepted_on": null,
  //         "quote_status": null,
  //         "quote_comments": null,
  //         "quote_value": 55.58,
  //         "quote_tax": 0,
  //         "currency_id": 1,
  //         "payment_method_id": 1,
  //         "paying_days": 21,
  //         "created_on": "2023-04-20 10:00:00",
  //         "updated_on": "2023-04-21 17:34:13",
  //         "created_by": 795,
  //         "updated_by": 779,
  //         "items": [
  //             {
  //                 "item_id": 30,
  //                 "item_name": "Cleaning Service",
  //                 "quantity": 1,
  //                 "price": 50,
  //                 "auto": true,
  //                 "notes": ""
  //             },
  //             {
  //                 "item_id": 5,
  //                 "item_name": "Kingsize duvet",
  //                 "quantity": 1,
  //                 "price": 3.5,
  //                 "auto": false,
  //                 "notes": ""
  //             },
  //             {
  //                 "item_id": 4,
  //                 "item_name": "Kingsize Sheet",
  //                 "quantity": 2,
  //                 "price": 2,
  //                 "auto": true,
  //                 "notes": ""
  //             },
  //             {
  //                 "item_id": 7,
  //                 "item_name": "Bath Towel",
  //                 "quantity": 2,
  //                 "price": 0.79,
  //                 "auto": true,
  //                 "notes": ""
  //             }
  //         ],
  //         "last_sent": "2023-04-21 10:51:45"
  //     },

  int id;
  String customerId;
  String name;
  String? company;
  bool active;
  String? phone;
  String? email;
  String? addressCountry;
  String? workAddressCountry;
  String? workStartDate;
  String? altWorkStartDate;
  String? workStartTime;
  String? workFinishTime;
  int? workRepeat;
  List<int> workDays;
  String validUntil;
  num quoteValue;
  num quoteTax;
  int currencyId;
  int paymentMethodId;
  int payingDays;
  String createdOn;
  String updatedOn;
  int createdBy;
  int updatedBy;
  List<QuoteItemMd> items;

  String? contact;
  String? companyRegNumber;
  String? vatNumber;
  String? vatCalc;
  String? fax;
  String? addressLine1;
  String? addressLine2;
  String? addressCity;
  String? addressCounty;
  String? addressPostcode;
  String? notes;
  String? workAddressLine1;
  String? workAddressLine2;
  String? workAddressCity;
  String? workAddressCounty;
  String? workAddressPostcode;
  String? acceptedOn;
  bool? quoteStatus;
  String? quoteComments;
  String? lastSent;

  QuoteInfoMd({
    required this.id,
    required this.customerId,
    required this.name,
    this.company,
    this.contact,
    this.companyRegNumber,
    this.vatNumber,
    this.vatCalc,
    required this.active,
    this.phone,
    this.fax,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.addressCity,
    this.addressCounty,
    this.addressCountry,
    this.addressPostcode,
    this.notes,
    this.workAddressLine1,
    this.workAddressLine2,
    this.workAddressCity,
    this.workAddressCounty,
    required this.workAddressCountry,
    this.workAddressPostcode,
    this.workStartDate,
    this.altWorkStartDate,
    this.workStartTime,
    this.workFinishTime,
    this.workRepeat,
    required this.workDays,
    required this.validUntil,
    this.acceptedOn,
    this.quoteStatus,
    this.quoteComments,
    required this.quoteValue,
    required this.quoteTax,
    required this.currencyId,
    required this.paymentMethodId,
    required this.payingDays,
    required this.createdOn,
    required this.updatedOn,
    required this.createdBy,
    required this.updatedBy,
    required this.items,
    this.lastSent,
  });

  // from json
  factory QuoteInfoMd.fromJson(Map<String, dynamic> json) {
    try {
      return QuoteInfoMd(
        id: json['id'],
        customerId: json['customer_id'],
        name: json['name'],
        company: json['company'],
        contact: json['contact'],
        companyRegNumber: json['company_reg_number'],
        vatNumber: json['vat_number'],
        vatCalc: json['vat_calc'],
        active: json['active'],
        phone: json['phone'],
        fax: json['fax'],
        email: json['email'],
        addressLine1: json['address_line1'],
        addressLine2: json['address_line2'],
        addressCity: json['address_city'],
        addressCounty: json['address_county'],
        addressCountry: json['address_country'],
        addressPostcode: json['address_postcode'],
        notes: json['notes'],
        workAddressLine1: json['work_address_line1'],
        workAddressLine2: json['work_address_line2'],
        workAddressCity: json['work_address_city'],
        workAddressCounty: json['work_address_county'],
        workAddressCountry: json['work_address_country'],
        workAddressPostcode: json['work_address_postcode'],
        workStartDate: json['work_start_date'],
        altWorkStartDate: json['alt_work_start_date'],
        workStartTime: json['work_start_time'],
        workFinishTime: json['work_finish_time'],
        workRepeat: json['work_repeat'],
        workDays: List<int>.from(json['work_days'].map((x) => x)),
        validUntil: json['valid_until'],
        acceptedOn: json['accepted_on'],
        quoteStatus: json['quote_status'],
        quoteComments: json['quote_comments'],
        quoteValue: json['quote_value'],
        quoteTax: json['quote_tax'],
        currencyId: json['currency_id'],
        paymentMethodId: json['payment_method_id'],
        payingDays: json['paying_days'],
        createdOn: json['created_on'],
        updatedOn: json['updated_on'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        items: List<QuoteItemMd>.from(
            json['items'].map((x) => QuoteItemMd.fromJson(x))),
        lastSent: json['last_sent'],
      );
    } on TypeError catch (e) {
      print('QuoteInfoMd.fromJson: ${e.stackTrace}');
      rethrow;
    }
  }

  // to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "name": name,
        "company": company,
        "contact": contact,
        "company_reg_number": companyRegNumber,
        "vat_number": vatNumber,
        "vat_calc": vatCalc,
        "active": active,
        "phone": phone,
        "fax": fax,
        "email": email,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "address_city": addressCity,
        "address_county": addressCounty,
        "address_country": addressCountry,
        "address_postcode": addressPostcode,
        "notes": notes,
        "work_address_line1": workAddressLine1,
        "work_address_line2": workAddressLine2,
        "work_address_city": workAddressCity,
        "work_address_county": workAddressCounty,
        "work_address_country": workAddressCountry,
        "work_address_postcode": workAddressPostcode,
        "work_start_date": workStartDate,
        "alt_work_start_date": altWorkStartDate,
        "work_start_time": workStartTime,
        "work_finish_time": workFinishTime,
        "work_repeat": workRepeat,
        "work_days": List<dynamic>.from(workDays.map((x) => x)),
        "valid_until": validUntil,
        "accepted_on": acceptedOn,
        "quote_status": quoteStatus,
        "quote_comments": quoteComments,
        "quote_value": quoteValue,
        "quote_tax": quoteTax,
        "currency_id": currencyId,
        "payment_method_id": paymentMethodId,
        "paying_days": payingDays,
        "created_on": createdOn,
        "updated_on": updatedOn,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "last_sent": lastSent,
      };

  // init
  factory QuoteInfoMd.init() {
    return QuoteInfoMd(
      id: 0,
      customerId: "",
      name: '',
      company: '',
      contact: '',
      companyRegNumber: '',
      vatNumber: '',
      vatCalc: "",
      active: true,
      phone: '',
      fax: '',
      email: '',
      addressLine1: '',
      addressLine2: '',
      addressCity: '',
      addressCounty: '',
      addressCountry: '',
      addressPostcode: '',
      notes: '',
      workAddressLine1: '',
      workAddressLine2: '',
      workAddressCity: '',
      workAddressCounty: '',
      workAddressCountry: '',
      workAddressPostcode: '',
      workStartDate: '',
      altWorkStartDate: '',
      workStartTime: '',
      workFinishTime: '',
      workRepeat: 0,
      workDays: [],
      validUntil: '',
      acceptedOn: '',
      quoteStatus: null,
      quoteComments: '',
      quoteValue: 0,
      quoteTax: 0,
      currencyId: 1,
      paymentMethodId: 1,
      payingDays: 1,
      createdOn: '',
      updatedOn: '',
      createdBy: 0,
      updatedBy: 0,
      items: [],
      lastSent: '',
    );
  }

  @override
  String toString() {
    return 'QuoteInfoMd{id: $id, customerId: $customerId, name: $name, company: $company, contact: $contact, companyRegNumber: $companyRegNumber, vatNumber: $vatNumber, vatCalc: $vatCalc, active: $active, phone: $phone, fax: $fax, email: $email, addressLine1: $addressLine1, addressLine2: $addressLine2, addressCity: $addressCity, addressCounty: $addressCounty, addressCountry: $addressCountry, addressPostcode: $addressPostcode, notes: $notes, workAddressLine1: $workAddressLine1, workAddressLine2: $workAddressLine2, workAddressCity: $workAddressCity, workAddressCounty: $workAddressCounty, workAddressCountry: $workAddressCountry, workAddressPostcode: $workAddressPostcode, workStartDate: $workStartDate, altWorkStartDate: $altWorkStartDate, workStartTime: $workStartTime, workFinishTime: $workFinishTime, workRepeat: $workRepeat, workDays: $workDays, validUntil: $validUntil, acceptedOn: $acceptedOn, quoteStatus: $quoteStatus, quoteComments: $quoteComments, quoteValue: $quoteValue, quoteTax: $quoteTax, currencyId: $currencyId, paymentMethodId: $paymentMethodId, payingDays: $payingDays, createdOn: $createdOn, updatedOn: $updatedOn, createdBy: $createdBy, updatedBy: $updatedBy, items: $items, lastSent: $lastSent}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteInfoMd &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          customerId == other.customerId &&
          name == other.name &&
          company == other.company &&
          contact == other.contact &&
          companyRegNumber == other.companyRegNumber &&
          vatNumber == other.vatNumber &&
          vatCalc == other.vatCalc &&
          active == other.active &&
          phone == other.phone &&
          fax == other.fax &&
          email == other.email &&
          addressLine1 == other.addressLine1 &&
          addressLine2 == other.addressLine2 &&
          addressCity == other.addressCity &&
          addressCounty == other.addressCounty &&
          addressCountry == other.addressCountry &&
          addressPostcode == other.addressPostcode &&
          notes == other.notes &&
          workAddressLine1 == other.workAddressLine1 &&
          workAddressLine2 == other.workAddressLine2 &&
          workAddressCity == other.workAddressCity &&
          workAddressCounty == other.workAddressCounty &&
          workAddressCountry == other.workAddressCountry &&
          workAddressPostcode == other.workAddressPostcode &&
          workStartDate == other.workStartDate &&
          altWorkStartDate == other.altWorkStartDate &&
          workStartTime == other.workStartTime &&
          workFinishTime == other.workFinishTime &&
          workRepeat == other.workRepeat &&
          workDays == other.workDays &&
          validUntil == other.validUntil &&
          acceptedOn == other.acceptedOn &&
          quoteStatus == other.quoteStatus &&
          quoteComments == other.quoteComments &&
          quoteValue == other.quoteValue &&
          quoteTax == other.quoteTax &&
          currencyId == other.currencyId &&
          paymentMethodId == other.paymentMethodId &&
          payingDays == other.payingDays &&
          createdOn == other.createdOn &&
          updatedOn == other.updatedOn &&
          createdBy == other.createdBy &&
          updatedBy == other.updatedBy &&
          items == other.items &&
          lastSent == other.lastSent;

  @override
  int get hashCode =>
      id.hashCode ^
      customerId.hashCode ^
      name.hashCode ^
      company.hashCode ^
      contact.hashCode ^
      companyRegNumber.hashCode ^
      vatNumber.hashCode ^
      vatCalc.hashCode ^
      active.hashCode ^
      phone.hashCode ^
      fax.hashCode ^
      email.hashCode ^
      addressLine1.hashCode ^
      addressLine2.hashCode ^
      addressCity.hashCode ^
      addressCounty.hashCode ^
      addressCountry.hashCode ^
      addressPostcode.hashCode ^
      notes.hashCode ^
      workAddressLine1.hashCode ^
      workAddressLine2.hashCode ^
      workAddressCity.hashCode ^
      workAddressCounty.hashCode ^
      workAddressCountry.hashCode ^
      workAddressPostcode.hashCode ^
      workStartDate.hashCode ^
      altWorkStartDate.hashCode ^
      workStartTime.hashCode ^
      workFinishTime.hashCode ^
      workRepeat.hashCode ^
      workDays.hashCode ^
      validUntil.hashCode ^
      acceptedOn.hashCode ^
      quoteStatus.hashCode ^
      quoteComments.hashCode ^
      quoteValue.hashCode ^
      quoteTax.hashCode ^
      currencyId.hashCode ^
      paymentMethodId.hashCode ^
      payingDays.hashCode ^
      createdOn.hashCode ^
      updatedOn.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode ^
      items.hashCode ^
      lastSent.hashCode;
}

class QuoteItemMd {
  // {
//                 "item_id": 30,
//                 "item_name": "Cleaning Service",
//                 "quantity": 1,
//                 "price": 50,
//                 "auto": true,
//                 "notes": ""
//             },

  final int itemId;
  final String itemName;
  final int quantity;
  final num price;
  final String? notes;
  final bool auto;

  QuoteItemMd({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.notes,
    required this.auto,
  });

  factory QuoteItemMd.fromJson(Map<String, dynamic> json) {
    try {
      return QuoteItemMd(
        itemId: json['item_id'],
        itemName: json['item_name'],
        price: json['price'],
        notes: json['notes'],
        auto: json['auto'],
        quantity: json['quantity'],
      );
    } on TypeError catch (e) {
      print('QuoteItemMd.fromJson: ${e.stackTrace}');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'item_name': itemName,
      'price': price,
      'notes': notes,
      'auto': auto,
      'quantity': quantity,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteItemMd &&
          runtimeType == other.runtimeType &&
          itemId == other.itemId &&
          itemName == other.itemName &&
          quantity == other.quantity &&
          price == other.price &&
          notes == other.notes &&
          auto == other.auto;

  @override
  int get hashCode =>
      itemId.hashCode ^
      itemName.hashCode ^
      quantity.hashCode ^
      price.hashCode ^
      notes.hashCode ^
      auto.hashCode;
}
