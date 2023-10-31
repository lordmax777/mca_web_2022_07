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
  //         "invoices": 95232732.00000358,
  //         "payments": null,
  //         "outstandingBalance": 95232732.00000358,
  //         "checklists": null,
  //         "quotes": 106,
  //         "quotemessages": null,
  //         "lastChecklist": "2023-10-16",
  //         "daysSinceLastJob": 9,
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
  final num? outstandingBalance;
  final int? quotes;
  final String? lastChecklist;
  DateTime? get lastChecklistDt => DateTime.tryParse(lastChecklist ?? "");
  final int? daysSinceLastJob;
  final int? checklists;
  final int? quotemessages;
  final bool combineInvoices;
  final bool sendInvoices;
  final List<ClientShiftMd> shiftsList;
  final List<ClientInvoiceMd> invoicesList;
  final List<ClientQuoteMd> quotesList;
  final List<ClientExpenseMd> expensesList;

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
    required this.outstandingBalance,
    required this.quotes,
    required this.lastChecklist,
    required this.daysSinceLastJob,
    required this.checklists,
    required this.quotemessages,
    required this.combineInvoices,
    required this.sendInvoices,
    required this.invoicesList,
    required this.quotesList,
    required this.shiftsList,
    required this.expensesList,
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
        outstandingBalance,
        checklists,
        quotes,
        quotemessages,
        daysSinceLastJob,
        lastChecklist,
        sendInvoices,
        combineInvoices,
        invoicesList,
        quotesList,
        shiftsList,
        expensesList,
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
        checklists: json['checklists'],
        quotemessages: json['quotemessages'],
        quotes: json['quotes'],
        lastChecklist: json['lastChecklist'],
        daysSinceLastJob: json['daysSinceLastJob'],
        outstandingBalance: json['outstandingBalance'],
        combineInvoices: json['combineInvoices'] ?? false,
        sendInvoices: json['sendInvoices'] ?? false,
        expensesList: (json['expenses_list'] as List<dynamic>?)
                ?.map(
                    (e) => ClientExpenseMd.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        invoicesList: (json['invoices_list'] as List<dynamic>?)
                ?.map(
                    (e) => ClientInvoiceMd.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        quotesList: (json['quotes_list'] as List<dynamic>?)
                ?.map((e) => ClientQuoteMd.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        shiftsList: (json['shifts_list'] as List<dynamic>?)
                ?.map((e) => ClientShiftMd.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }
}

class ClientShiftMd extends Equatable {
  //     "id": 69,
  //                 "name": "afternoon",
  //                 "location_id": 47,
  //                 "location_name": "Sam Bavishi"
  //             }

  final int id;
  final String name;
  final int locationId;
  final String locationName;

  const ClientShiftMd({
    required this.id,
    required this.name,
    required this.locationId,
    required this.locationName,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        locationId,
        locationName,
      ];

  factory ClientShiftMd.fromJson(Map<String, dynamic> json) {
    try {
      return ClientShiftMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        locationId: json['location_id'] as int,
        locationName: json['location_name'] ?? "",
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }
}

class ClientInvoiceMd extends Equatable {
  //  {
  //                 "id": 13,
  //                 "date": "2021-02-09",
  //                 "due_date": "2021-03-11",
  //                 "value": 37.5,
  //                 "paid": false,
  //                 "payment_method": "Cash"
  //             }

  final int id;
  final String date;
  DateTime? get dateDt => DateTime.tryParse(date);
  final String dueDate;
  DateTime? get dueDateDt => DateTime.tryParse(dueDate);
  final num value;
  final bool paid;
  final String paymentMethod;
  PaymentMethodMd? getPaymentMethodMd(List<PaymentMethodMd> paymentMethods) =>
      paymentMethods
          .firstWhereOrNull((element) => element.name == paymentMethod);

  const ClientInvoiceMd({
    required this.id,
    required this.date,
    required this.dueDate,
    required this.value,
    required this.paid,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        dueDate,
        value,
        paid,
        paymentMethod,
      ];

  factory ClientInvoiceMd.fromJson(Map<String, dynamic> json) {
    try {
      return ClientInvoiceMd(
        id: json['id'] as int,
        date: json['date'] ?? "",
        dueDate: json['due_date'] ?? "",
        value: json['value'] ?? 0,
        paid: json['paid'] ?? false,
        paymentMethod: json['payment_method'] ?? "",
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }
}

class ClientQuoteMd extends Equatable {
  //{
  //                 "id": 74,
  //                 "status": "accepted",
  //                 "value": 40,
  //                 "repeat": "Once",
  //                 "start_date": "2023-05-04"
  //             }

  final int id;
  final String status;
  final num value;
  final String repeat;
  WorkRepeatMd? getWorkRepeatMd(List<WorkRepeatMd> workRepeats) =>
      workRepeats.firstWhereOrNull((element) => element.name == repeat);
  final String startDate;
  DateTime? get startDateDt => DateTime.tryParse(startDate);

  const ClientQuoteMd({
    required this.id,
    required this.status,
    required this.value,
    required this.repeat,
    required this.startDate,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        value,
        repeat,
        startDate,
      ];

  factory ClientQuoteMd.fromJson(Map<String, dynamic> json) {
    try {
      return ClientQuoteMd(
        id: json['id'] as int,
        status: json['status'] ?? "",
        value: json['value'] ?? 0,
        repeat: json['repeat'] ?? "",
        startDate: json['start_date'] ?? "",
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }
}

class ClientExpenseMd extends Equatable {
  final int id;
  final String category;
  final bool status;
  final num value;
  final bool invoiced;
  final bool completed;

  const ClientExpenseMd({
    required this.id,
    required this.category,
    required this.status,
    required this.value,
    required this.invoiced,
    required this.completed,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        status,
        value,
        invoiced,
        completed,
      ];

  factory ClientExpenseMd.fromJson(Map<String, dynamic> json) {
    try {
      return ClientExpenseMd(
        id: json['id'] as int,
        category: json['category'] ?? "",
        status: json['status'] ?? false,
        value: json['value'] ?? 0,
        invoiced: json['invoiced'] ?? false,
        completed: json['completed'] ?? false,
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }
}
