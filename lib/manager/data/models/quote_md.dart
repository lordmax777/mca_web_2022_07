import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/models.dart';
import 'package:mca_dashboard/utils/utils.dart';

final class QuoteMd extends Equatable {
  //{
  //             "id": 1,
  //             "customer_id": "a7ee9e90e0c7ae618bb70b2510c7a394c1234c7909d94b9bdb97392c1b6d7a4a",
  //             "name": "test name",
  //             "company": "test company",
  //             "contact": null,
  //             "company_reg_number": null,
  //             "vat_number": null,
  //             "vat_calc": null,
  //             "active": true,
  //             "phone": "02787246238456",
  //             "fax": null,
  //             "email": "imre@incze.co.uk",
  //             "address_line1": "line 1",
  //             "address_line2": "line 2",
  //             "address_city": "city",
  //             "address_county": "county",
  //             "address_country": "GB",
  //             "address_postcode": "xx1 1xx",
  //             "notes": "notes",
  //             "work_address_line1": "work1",
  //             "work_address_line2": "work2",
  //             "work_address_city": "work city",
  //             "work_address_county": "work county",
  //             "work_address_country": "GB",
  //             "work_address_postcode": "xx1 1yy",
  //             "work_start_date": "2023-05-01",
  //             "alt_work_start_date": "2023-06-01",
  //             "work_start_time": "08:00",
  //             "work_finish_time": "08:30",
  //             "work_repeat": 0,
  //             "work_days": [],
  //             "valid_until": "2023-05-20",
  //             "accepted_on": "2023-05-03 11:42:36",
  //             "quote_status": true,
  //             "quote_comments": "quote comment",
  //             "quote_value": 30,
  //             "quote_tax": 0,
  //             "currency_id": 2,
  //             "payment_method_id": 1,
  //             "paying_days": 30,
  //             "client_id": 2,
  //             "client_contract_id": null,
  //             "location_id": 47,
  //             "shift_id": null,
  //             "user_ids": "805,806,807",
  //             "created_on": "2023-04-20 10:00:00",
  //             "updated_on": "2023-05-04 10:17:09",
  //             "created_by": 795,
  //             "updated_by": 795,
  //             "items": [
  //                 {
  //                     "item_id": 30,
  //                     "item_name": "Cleaning Service",
  //                     "quantity": 1,
  //                     "price": 30,
  //                     "auto": true,
  //                     "notes": ""
  //                 },
  //                 {
  //                     "item_id": 5,
  //                     "item_name": "Kingsize duvet",
  //                     "quantity": 2,
  //                     "price": 3.09,
  //                     "auto": false,
  //                     "notes": ""
  //                 }
  //             ],
  //             "last_sent": "2023-04-21 10:51:45",
  //             "messages": [
  //                 {
  //                     "content": "This is a quote message",
  //                     "createdOn": "2023-04-28 21:04:28",
  //                     "createdBy": 795
  //                 },
  //                 {
  //                     "content": "This is a quote message",
  //                     "createdOn": "2023-04-28 21:00:32",
  //                     "createdBy": 795
  //                 }
  //             ]
  //         }

  final int id;
  final String customerId;
  final String name;
  final String company;
  final String contact;
  final String companyRegNumber;
  final bool active;
  final String phone;
  final String fax;
  final String email;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressCity;
  final String? addressCounty;
  final String? addressCountry;
  CountryMd? countryMd(List<CountryMd> countries) {
    return countries
        .firstWhereOrNull((element) => element.code == addressCountry);
  }

  final String? addressPostcode;

  final String notes;
  final String? workAddressLine1;
  final String? workAddressLine2;
  final String? workAddressCity;
  final String? workAddressCounty;
  final String? workAddressCountry;
  CountryMd? workCountryMd(List<CountryMd> countries) {
    return countries
        .firstWhereOrNull((element) => element.code == workAddressCountry);
  }

  final String? workAddressPostcode;

  final String? workStartDate;
  DateTime? get workStartDateDt =>
      workStartDate == null ? null : DateTime.parse(workStartDate!);
  final String? altWorkStartDate;
  DateTime? get altWorkStartDateDt =>
      altWorkStartDate == null ? null : DateTime.parse(altWorkStartDate!);
  final String? workStartTime;
  TimeOfDay? get workStartTimeDt {
    if (workStartTime == null) return null;
    final List<String> time = workStartTime!.split(':');
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }

  final String? workFinishTime;
  TimeOfDay? get workFinishTimeDt {
    if (workFinishTime == null) return null;
    final List<String> time = workFinishTime!.split(':');
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }

  final int? workRepeat;
  WorkRepeatMd? workRepeatMd(List<WorkRepeatMd> workRepeats) {
    return workRepeats.firstWhereOrNull((element) => element.id == workRepeat);
  }

  final List<int> workDays;
  final String validUntil;
  DateTime get validUntilDt => DateTime.parse(validUntil);
  final String? acceptedOn;
  DateTime? get acceptedOnDt =>
      acceptedOn == null ? null : DateTime.parse(acceptedOn!);
  final bool quoteStatus;
  final String quoteComments;
  final num quoteValue;
  final num quoteTax;
  final int currencyId;
  CurrencyMd? currencyMd(List<CurrencyMd> currencies) {
    return currencies.firstWhereOrNull((element) => element.id == currencyId);
  }

  final int paymentMethodId;
  PaymentMethodMd? paymentMethodMd(List<PaymentMethodMd> paymentMethods) {
    return paymentMethods
        .firstWhereOrNull((element) => element.id == paymentMethodId);
  }

  final int payingDays;
  final int? clientId;
  ClientMd? clientMd(List<ClientMd> clients) {
    return clients.firstWhereOrNull((element) => element.id == clientId);
  }

  final int? clientContractId;
  final int? locationId;
  LocationMd? locationMd(List<LocationMd> locations) {
    return locations.firstWhereOrNull((element) => element.id == locationId);
  }

  final int? shiftId;
  PropertyMd? shiftMd(List<PropertyMd> properties) {
    return properties.firstWhereOrNull((element) => element.id == shiftId);
  }

  final List<QuoteUserMd> userIds;
  final String createdOn;
  DateTime get createdOnDt => DateTime.parse(createdOn);
  final String updatedOn;
  DateTime get updatedOnDt => DateTime.parse(updatedOn);
  final int? createdBy;
  UserMd? createdByMd(List<UserMd> users) {
    return users.firstWhereOrNull((element) => element.id == createdBy);
  }

  final int? updatedBy;
  UserMd? updatedByMd(List<UserMd> users) {
    return users.firstWhereOrNull((element) => element.id == updatedBy);
  }

  final List<QuoteItemMd> items;
  final String? lastSent;
  DateTime? get lastSentDt =>
      lastSent == null ? null : DateTime.parse(lastSent!);
  final List<QuoteMessageMd> messages;

  const QuoteMd({
    required this.addressLine1,
    required this.addressLine2,
    required this.addressCity,
    required this.addressCounty,
    required this.addressCountry,
    required this.addressPostcode,
    required this.workAddressLine1,
    required this.workAddressLine2,
    required this.workAddressCity,
    required this.workAddressCounty,
    required this.workAddressCountry,
    required this.workAddressPostcode,
    required this.id,
    required this.customerId,
    required this.name,
    required this.company,
    required this.contact,
    required this.companyRegNumber,
    required this.active,
    required this.phone,
    required this.fax,
    required this.email,
    required this.notes,
    required this.workStartDate,
    required this.altWorkStartDate,
    required this.workStartTime,
    required this.workFinishTime,
    required this.workRepeat,
    required this.workDays,
    required this.validUntil,
    required this.acceptedOn,
    required this.quoteStatus,
    required this.quoteComments,
    required this.quoteValue,
    required this.quoteTax,
    required this.currencyId,
    required this.paymentMethodId,
    required this.payingDays,
    required this.clientId,
    required this.clientContractId,
    required this.locationId,
    required this.shiftId,
    required this.userIds,
    required this.createdOn,
    required this.updatedOn,
    required this.createdBy,
    required this.updatedBy,
    required this.items,
    required this.lastSent,
    required this.messages,
  });

  @override
  List<Object?> get props => [
        id,
        customerId,
        name,
        company,
        contact,
        companyRegNumber,
        active,
        phone,
        fax,
        email,
        notes,
        workStartDate,
        altWorkStartDate,
        workStartTime,
        workFinishTime,
        workRepeat,
        workDays,
        validUntil,
        acceptedOn,
        quoteStatus,
        quoteComments,
        quoteValue,
        quoteTax,
        currencyId,
        paymentMethodId,
        payingDays,
        clientId,
        clientContractId,
        locationId,
        shiftId,
        userIds,
        createdOn,
        updatedOn,
        createdBy,
        updatedBy,
        items,
        lastSent,
        messages
      ];

  //from json
  factory QuoteMd.fromJson(Map<String, dynamic> json) {
    bool canParseJsonUserIds = false;
    if (json['user_ids'] is String) {
      try {
        jsonDecode(json['user_ids']);
        canParseJsonUserIds = true;
      } catch (e) {
        canParseJsonUserIds = false;
      }
    }
    return QuoteMd(
      id: json["id"],
      customerId: json["customer_id"] ?? "",
      name: json["name"] ?? "",
      company: json["company"] ?? "",
      contact: json["contact"] ?? "",
      companyRegNumber: json["company_reg_number"] ?? "",
      active: json["active"],
      phone: json["phone"] ?? "",
      fax: json["fax"] ?? "",
      email: json["email"] ?? "",
      notes: json["notes"] ?? "",
      workStartDate: json["work_start_date"] ?? "",
      altWorkStartDate: json["alt_work_start_date"] ?? "",
      workStartTime: json["work_start_time"] ?? "",
      workFinishTime: json["work_finish_time"] ?? "",
      workRepeat: json["work_repeat"],
      workDays: List<int>.from(json["work_days"].map((x) => x)),
      validUntil: json["valid_until"] ?? "",
      acceptedOn: json["accepted_on"] ?? "",
      quoteStatus: json["quote_status"] ?? false,
      quoteComments: json["quote_comments"] ?? "",
      quoteValue: json["quote_value"] ?? 0,
      quoteTax: json["quote_tax"] ?? 0,
      currencyId: json["currency_id"],
      paymentMethodId: json["payment_method_id"],
      payingDays: json["paying_days"] ?? 0,
      clientId: json["client_id"],
      clientContractId: json["client_contract_id"] ?? 0,
      locationId: json["location_id"],
      shiftId: json["shift_id"],
      userIds: json["user_ids"] == null
          ? []
          : canParseJsonUserIds
              ? jsonDecode(json["user_ids"]) is List
                  ? List<QuoteUserMd>.from(jsonDecode(json["user_ids"])
                      .map((x) => QuoteUserMd.fromJson(x)))
                  : []
              : [],
      createdOn: json["created_on"] ?? "",
      updatedOn: json["updated_on"] ?? "",
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      lastSent: json["last_sent"] ?? "",
      items: List<QuoteItemMd>.from(
          (json["items"] ?? []).map((x) => QuoteItemMd.fromJson(x))),
      messages: List<QuoteMessageMd>.from(
          (json["messages"] ?? []).map((x) => QuoteMessageMd.fromJson(x))),
      addressCity: json["address_city"],
      addressCounty: json["address_county"],
      addressCountry: json["address_country"],
      addressPostcode: json["address_postcode"],
      addressLine1: json["address_line1"],
      addressLine2: json["address_line2"],
      workAddressCity: json["work_address_city"],
      workAddressCounty: json["work_address_county"],
      workAddressCountry: json["work_address_country"],
      workAddressPostcode: json["work_address_postcode"],
      workAddressLine1: json["work_address_line1"],
      workAddressLine2: json["work_address_line2"],
    );
  }
}

final class QuoteItemMd extends Equatable {
  //                 {
  //                     "item_id": 30,
  //                     "item_name": "Cleaning Service",
  //                     "quantity": 1,
  //                     "price": 30,
  //                     "auto": true,
  //                     "notes": ""
  //                 },
  final int itemId;
  StorageItemMd? itemMd(List<StorageItemMd> items) {
    return items.firstWhereOrNull((element) => element.id == itemId);
  }

  final String itemName;
  final int quantity;
  final num price;
  final bool auto;
  final String notes;

  const QuoteItemMd({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.auto,
    required this.notes,
  });

  factory QuoteItemMd.fromJson(Map<String, dynamic> json) => QuoteItemMd(
        itemId: json["item_id"],
        itemName: json["item_name"] ?? "",
        quantity: json["quantity"] ?? 0,
        price: json["price"] ?? 0,
        auto: json["auto"] ?? false,
        notes: json["notes"] ?? "",
      );

  @override
  List<Object?> get props => [itemId, itemName, quantity, price, auto, notes];
}

final class QuoteMessageMd extends Equatable {
  //  {
  //                     "content": "1st message\r\n\r\nNo content\r\n\r\nOnly this",
  //                     "createdOn": "2023-04-28 10:26:56",
  //                     "createdBy": 779
  //                 }
  final String content;
  final String createdOn;
  DateTime get createdOnDt => DateTime.parse(createdOn);
  final int? createdBy;
  UserMd? userMd(List<UserMd> users) {
    return users.firstWhereOrNull((element) => element.id == createdBy);
  }

  const QuoteMessageMd({
    required this.content,
    required this.createdOn,
    required this.createdBy,
  });

  factory QuoteMessageMd.fromJson(Map<String, dynamic> json) => QuoteMessageMd(
        content: json["content"] ?? "",
        createdOn: json["createdOn"] ?? "",
        createdBy: json["createdBy"],
      );

  @override
  List<Object?> get props => [content, createdOn, createdBy];
}

final class QuoteUserMd extends Equatable {
  //{\"user_id\":805,\"special_start_time\":\"13:00\",\"special_finish_time\":\"18:00\",\"special_rate\":7.99}
  final int userId;

  final String? specialStartTime;
  TimeOfDay? get specialStartTimeDt {
    if (specialStartTime == null) return null;
    final parts = specialStartTime!.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  final String? specialFinishTime;
  TimeOfDay? get specialFinishTimeDt {
    if (specialFinishTime == null) return null;
    final parts = specialFinishTime!.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  final num? specialRate;

  const QuoteUserMd({
    required this.userId,
    this.specialStartTime,
    this.specialFinishTime,
    this.specialRate,
  });

  factory QuoteUserMd.fromJson(Map<String, dynamic> json) {
    int userId =
        json['user_id'] is int ? json['user_id'] : int.parse(json['user_id']);
    return QuoteUserMd(
      userId: userId,
      specialStartTime: json["special_start_time"],
      specialFinishTime: json["special_finish_time"],
      specialRate: json["special_rate"],
    );
  }

  @override
  List<Object?> get props =>
      [userId, specialStartTime, specialFinishTime, specialRate];
}
