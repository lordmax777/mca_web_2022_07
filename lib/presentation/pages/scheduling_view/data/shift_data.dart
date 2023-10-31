// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ShiftData extends Equatable {
  final bool isCreate;
  final bool isQuote;

  final PersonalData personalData;
  final AddressData addressData;
  final AddressData workAddressData;
  final TimeData timeData;
  final TeamData teamData;
  final GuestData guestData;
  final QuoteData quoteData;
  final ProductData productData;

  const ShiftData({
    required this.personalData,
    required this.addressData,
    required this.timeData,
    required this.teamData,
    required this.guestData,
    required this.quoteData,
    required this.productData,
    required this.workAddressData,
    required this.isCreate,
    required this.isQuote,
  });

  @override
  List<Object?> get props => [
        personalData,
        addressData,
        timeData,
        teamData,
        guestData,
        quoteData,
        productData,
        workAddressData,
        isCreate,
        isQuote,
      ];

  factory ShiftData.init({
    PersonalData? personalData,
    AddressData? addressData,
    TimeData? timeData,
    TeamData? teamData,
    GuestData? guestData,
    QuoteData? quoteData,
    ProductData? productData,
    AddressData? workAddressData,
    bool isCreate = true,
    bool isQuote = false,
  }) {
    return ShiftData(
      isCreate: isCreate,
      personalData: personalData ??
          PersonalData(
            paymentMethod: appStore.state.generalState.defaultPaymentMethod,
          ),
      addressData: addressData ?? AddressData(),
      guestData: guestData ?? GuestData(),
      quoteData: quoteData ?? QuoteData(),
      productData: productData ?? ProductData(),
      teamData: teamData ?? TeamData(users: []),
      workAddressData: workAddressData ?? AddressData(),
      timeData: timeData ?? TimeData.init(withAltStartDate: isQuote),
      isQuote: isQuote,
    );
  }

  //copyWith
  ShiftData copyWith({
    PersonalData? personalData,
    AddressData? addressData,
    TimeData? timeData,
    TeamData? teamData,
    GuestData? guestData,
    QuoteData? quoteData,
    ProductData? productData,
    AddressData? workAddressData,
    bool? isCreate,
    bool? isQuote,
  }) {
    return ShiftData(
      personalData: personalData ?? this.personalData,
      addressData: addressData ?? this.addressData,
      timeData: timeData ?? this.timeData,
      teamData: teamData ?? this.teamData,
      guestData: guestData ?? this.guestData,
      quoteData: quoteData ?? this.quoteData,
      productData: productData ?? this.productData,
      workAddressData: workAddressData ?? this.workAddressData,
      isCreate: isCreate ?? this.isCreate,
      isQuote: isQuote ?? this.isQuote,
    );
  }
}

class PersonalData extends Equatable {
  String name;
  int? clientId;
  String companyName;
  String phone;
  String email;
  int paymentDays;
  PaymentMethodMd? paymentMethod;
  CurrencyMd? currency;
  String notes;
  int? shiftId;
  InvoicePeriod? invoicePeriod;
  int invoiceDay;
  bool combineInvoices;
  bool sendInvoices;
  String? fax;

  PersonalData({
    this.name = "",
    this.clientId,
    this.companyName = "",
    this.phone = "",
    this.email = "",
    this.paymentDays = 1,
    this.paymentMethod,
    this.currency,
    this.notes = "",
    this.shiftId,
    this.invoiceDay = 0,
    this.invoicePeriod,
    this.combineInvoices = false,
    this.sendInvoices = false,
    this.fax,
  });

  @override
  List<Object?> get props => [
        name,
        clientId,
        companyName,
        phone,
        email,
        paymentDays,
        paymentMethod,
        currency,
        notes,
        shiftId,
        invoiceDay,
        invoicePeriod,
        combineInvoices,
        sendInvoices,
        fax,
      ];

  //copyWith
  PersonalData copyWith({
    String? name,
    int? clientId,
    String? companyName,
    String? phone,
    String? email,
    int? paymentDays,
    PaymentMethodMd? paymentMethod,
    CurrencyMd? currency,
    String? notes,
    int? shiftId,
    int? invoiceDay,
    InvoicePeriod? invoicePeriod,
    bool? combineInvoices,
    bool? sendInvoices,
    String? fax,
  }) {
    return PersonalData(
      name: name ?? this.name,
      clientId: clientId ?? this.clientId,
      companyName: companyName ?? this.companyName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      paymentDays: paymentDays ?? this.paymentDays,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      shiftId: shiftId ?? this.shiftId,
      invoiceDay: invoiceDay ?? this.invoiceDay,
      invoicePeriod: invoicePeriod ?? this.invoicePeriod,
      combineInvoices: combineInvoices ?? this.combineInvoices,
      sendInvoices: sendInvoices ?? this.sendInvoices,
      fax: fax ?? this.fax,
    );
  }

  //copyFrom ClientMd client
  PersonalData copyFromClient(
    ClientMd client, {
    required List<CurrencyMd> currencies,
    required List<PaymentMethodMd> paymentMethods,
    required List<InvoicePeriod> invoicePeriods,
  }) {
    return PersonalData(
      name: client.name,
      clientId: client.id,
      companyName: client.company ?? "",
      phone: client.phone ?? "",
      email: client.email ?? "",
      paymentDays: client.payingDays,
      paymentMethod: client.getPaymentMethodMd(paymentMethods),
      currency: client.getCurrencyMd(currencies),
      notes: client.notes,
      shiftId: shiftId,
      invoicePeriod: client.getInvoicePeriod(invoicePeriods),
      invoiceDay: client.invoiceDay ?? 0,
      sendInvoices: client.sendInvoices,
      combineInvoices: client.combineInvoices,
      fax: client.fax ?? "",
    );
  }

  //copyFrom QuoteMd quote
  PersonalData copyFromQuote(
    QuoteMd quote, {
    required List<CurrencyMd> currencies,
    required List<PaymentMethodMd> paymentMethods,
    required List<ClientMd> clients,
    required List<InvoicePeriod> invoicePeriods,
  }) {
    return PersonalData(
        paymentDays: quote.payingDays,
        paymentMethod: quote.paymentMethodMd(paymentMethods),
        currency: quote.currencyMd(currencies),
        name: quote.name,
        phone: quote.phone,
        email: quote.email,
        notes: quote.notes,
        clientId: quote.clientId,
        companyName: quote.company,
        shiftId: shiftId,
        invoicePeriod:
            quote.clientMd(clients)?.getInvoicePeriod(invoicePeriods),
        invoiceDay: 0,
        sendInvoices: false,
        combineInvoices: false,
        fax: quote.fax);
  }

  PersonalData copyFromProperty(
    PropertyMd pr, {
    required List<ShiftMd> shifts,
    required List<ClientMd> clients,
    required List<CurrencyMd> currencies,
    required List<PaymentMethodMd> paymentMethods,
    required List<InvoicePeriod> invoicePeriods,
  }) {
    PersonalData data = PersonalData(shiftId: pr.id, invoiceDay: 0);
    final shift = shifts.firstWhereOrNull((element) => element.id == pr.id);
    if (shift != null) {
      final client = shift.getClientMd(clients);
      if (client != null) {
        data = data.copyFromClient(client,
            currencies: currencies,
            paymentMethods: paymentMethods,
            invoicePeriods: invoicePeriods);
      }
    }
    return data;
  }

  //Validate
  bool isValid(BuildContext context) {
    if (name.isEmpty ||
        // phone.isEmpty ||
        // email.isEmpty ||
        paymentMethod == null ||
        currency == null ||
        invoicePeriod == null) {
      context.showError(
          "Please fill ${name.isEmpty ? "name, " : ""}${paymentMethod == null ? "payment method, " : ""}${currency == null ? "currency, " : ""}${invoicePeriod == null ? "invoice period, " : ""}}");
      return false;
    }
    return name.isNotEmpty &&
        // phone.isNotEmpty &&
        // email.isNotEmpty &&
        paymentMethod != null &&
        currency != null;
  }
}

class AddressData extends Equatable {
  String name;
  String line1;
  String line2;
  String city;
  String county;
  String postcode;
  CountryMd? country;

  String phoneNumber;
  String? phoneLandline;
  String? phoneFax;
  String email;

  int? locationId;

  double? latitude;
  double? longitude;
  double? radius;

  bool fixedIpAddress;

  String? ipAddress;

  AddressData({
    this.line1 = "",
    this.name = "",
    this.line2 = "",
    this.city = "",
    this.county = "",
    this.postcode = "",
    this.country,
    this.locationId,
    this.phoneNumber = "",
    this.email = "",
    this.latitude,
    this.longitude,
    this.fixedIpAddress = false,
    this.ipAddress,
    this.radius,
    this.phoneLandline,
    this.phoneFax,
  });

  @override
  List<Object?> get props => [
        line1,
        line2,
        city,
        county,
        postcode,
        country,
        locationId,
        phoneNumber,
        email,
        latitude,
        longitude,
        fixedIpAddress,
        ipAddress,
        name,
        radius,
        phoneLandline,
        phoneFax,
      ];

  //copyWith
  AddressData copyWith({
    String? line1,
    String? line2,
    String? city,
    String? county,
    String? postcode,
    CountryMd? country,
    String? phoneNumber,
    String? email,
    double? latitude,
    double? longitude,
    int? locationId,
    bool? fixedIpAddress,
    String? ipAddress,
    String? name,
    double? radius,
    String? phoneLandline,
    String? phoneFax,
  }) {
    return AddressData(
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      county: county ?? this.county,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      locationId: locationId ?? this.locationId,
      longitude: longitude ?? this.longitude,
      fixedIpAddress: fixedIpAddress ?? this.fixedIpAddress,
      ipAddress: ipAddress ?? this.ipAddress,
      name: name ?? this.name,
      radius: radius ?? this.radius,
      phoneLandline: phoneLandline ?? this.phoneLandline,
      phoneFax: phoneFax ?? this.phoneFax,
    );
  }

  //copyFrom AddressMd address
  AddressData copyFromAddress(AddressMd address,
      {required List<CountryMd> countries, String? email, String? phone}) {
    return AddressData(
      line1: address.line1,
      line2: address.line2,
      city: address.city,
      county: address.county,
      postcode: address.postcode,
      country: address.getCountryMd(countries),
      phoneNumber: phone ?? "",
      email: email ?? "",
      latitude: address.latitude?.toDouble(),
      longitude: address.longitude?.toDouble(),
      radius: address.radius?.toDouble(),
    );
  }

  //copyFrom QuoteMd quote
  AddressData copyFromQuote(QuoteMd quote,
      {required List<CountryMd> countries, bool isWorkAddress = false}) {
    if (isWorkAddress) {
      return AddressData(
        line1: quote.workAddressLine1 ?? "",
        line2: quote.workAddressLine2 ?? "",
        city: quote.workAddressCity ?? "",
        county: quote.workAddressCounty ?? "",
        postcode: quote.workAddressPostcode ?? "",
        country: quote.workCountryMd(countries),
        phoneNumber: quote.phone,
        email: quote.email,
        locationId: quote.workAddressLine1 == null ? null : quote.locationId,
      );
    }
    return AddressData(
      line1: quote.addressLine1 ?? "",
      line2: quote.addressLine2 ?? "",
      city: quote.addressCity ?? "",
      county: quote.addressCounty ?? "",
      postcode: quote.addressPostcode ?? "",
      country: quote.countryMd(countries),
      phoneNumber: quote.phone,
      email: quote.email,
      locationId: quote.locationId,
    );
  }

  AddressData copyFromProperty(
    PropertyMd pr, {
    required List<ShiftMd> shifts,
    required List<LocationMd> locations,
    required List<CountryMd> countries,
  }) {
    AddressData data = AddressData();
    final shift = shifts.firstWhereOrNull((element) => element.id == pr.id);
    if (shift != null) {
      final location = shift.getLocationMd(locations);
      if (location != null) {
        data = data.copyFromAddress(location.address, countries: countries);
      }
    }
    return data;
  }

  //Validate
  bool isValid(BuildContext context) {
    if (line1.isEmpty || city.isEmpty || postcode.isEmpty || country == null) {
      context.showError(
          "Please fill ${line1.isEmpty ? "address line 1, " : ""}${city.isEmpty ? "city, " : ""}${postcode.isEmpty ? "postcode, " : ""}${country == null ? "country, " : ""}");
      return false;
    }
    return line1.isNotEmpty &&
        city.isNotEmpty &&
        postcode.isNotEmpty &&
        country != null;
  }
}

class TimeData extends Equatable {
  DateTime? start;
  DateTime? altStartDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  WorkRepeatMd? repeat;
  bool active;
  final WeekDaysMd week1;
  final WeekDaysMd week2;
  final bool showAltDate;

  bool get isAllDay =>
      (startTime != null && endTime != null) &&
      startTime!.hour == 0 &&
      endTime!.hour == 23 &&
      startTime!.minute == 0 &&
      endTime!.minute == 59;

  bool get showRepeatDays => repeat != null && repeat!.days > 1;

  bool get showWeek2 => repeat != null && repeat!.days > 7;

  //"1,2,3,4,5" - Monday to Friday (1-7) week1
  //"8,9,10,11,12" - Monday to Friday (8-14) week2
  String? get week1Str {
    if (showRepeatDays) {
      String str = "";
      for (var i = 0; i < week1.asMap.length; i++) {
        if (week1.asMap.values.toList()[i] == true) {
          str += "${i + 1},";
        }
      }
      return str.substring(0, str.length - 1);
    }
    return null;
  }

  String? get week2Str {
    if (showWeek2) {
      String str = "";
      for (var i = 0; i < week2.asMap.length; i++) {
        if (week2.asMap.values.toList()[i] == true) {
          str += "${i + 8},";
        }
      }
      return str.substring(0, str.length - 1);
    }
    return null;
  }

  TimeData({
    this.start,
    this.altStartDate,
    this.startTime,
    this.endTime,
    this.repeat,
    required this.week1,
    required this.week2,
    this.active = true,
    this.showAltDate = false,
  });

  @override
  List<Object?> get props => [
        start,
        startTime,
        endTime,
        repeat,
        active,
        week1,
        week2,
        altStartDate,
        showAltDate,
      ];

  //copyWith
  TimeData copyWith({
    DateTime? start,
    DateTime? altStartDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    WorkRepeatMd? repeat,
    bool? active,
    WeekDaysMd? week1,
    WeekDaysMd? week2,
    bool? showAltDate,
  }) {
    return TimeData(
      start: start ?? this.start,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      repeat: repeat ?? this.repeat,
      active: active ?? this.active,
      week1: week1 ?? this.week1,
      week2: week2 ?? this.week2,
      altStartDate: altStartDate ?? this.altStartDate,
      showAltDate: showAltDate ?? this.showAltDate,
    );
  }

  //copyFromQuote QuoteMd quote
  TimeData copyFromQuote(
    QuoteMd quote, {
    required List<WorkRepeatMd> repeats,
  }) {
    return TimeData(
      showAltDate: showAltDate,
      active: quote.active,
      altStartDate: quote.altWorkStartDateDt,
      start: quote.workStartDateDt,
      startTime: quote.workStartTimeDt,
      endTime: quote.workFinishTimeDt,
      repeat: repeats
          .firstWhereOrNull((element) => element.days == quote.workRepeat),
      week1: WeekDaysMd.fromQuoteWorkDays(quote.workDays),
      week2: WeekDaysMd.fromQuoteWorkDays(quote.workDays, isFortnightly: true),
    );
  }

  //Validate
  bool isValid(BuildContext context) {
    if (start == null ||
        startTime == null ||
        endTime == null ||
        repeat == null) {
      context.showError(
          "Please fill ${start == null ? "start date, " : ""}${startTime == null ? "start time, " : ""}${endTime == null ? "end time, " : ""}${repeat == null ? "repeat, " : ""}");
      return false;
    }
    return start != null &&
        startTime != null &&
        endTime != null &&
        repeat != null;
  }

  //init
  factory TimeData.init({bool withAltStartDate = false}) {
    return TimeData(
      week1: WeekDaysMd(),
      week2: WeekDaysMd(),
      showAltDate: withAltStartDate,
    );
  }
}

class TeamData extends Equatable {
  final List<UserMd> users;

  const TeamData({
    required this.users,
  });

  @override
  List<Object?> get props => [users];

  //copyWith
  TeamData copyWith({
    List<UserMd>? users,
  }) {
    return TeamData(
      users: users ?? this.users,
    );
  }
}

class GuestData extends Equatable {
  int bedrooms;
  int bathrooms;
  int min;
  int max;
  String notes;
  int current;

  GuestData({
    this.min = 0,
    this.max = 0,
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.notes = "",
    this.current = 0,
  });

  @override
  List<Object?> get props => [
        min,
        max,
        current,
        bedrooms,
        bathrooms,
        notes,
      ];

  //copyWith
  GuestData copyWith({
    int? min,
    int? max,
    int? current,
    int? bedrooms,
    int? bathrooms,
    String? notes,
  }) {
    return GuestData(
      min: min ?? this.min,
      max: max ?? this.max,
      current: current ?? this.current,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      notes: notes ?? this.notes,
    );
  }

  //copyFrom from PropertyDetailsMd property
  GuestData copyFromProperty(PropertyDetailMd property) {
    return GuestData(
      min: property.minSleeps,
      max: property.maxSleeps,
      current: current,
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      notes: property.notes,
    );
  }

  //isValid
  bool isValid(BuildContext context) {
    //if any of the numbers are 0 then is valid
    if (min == 0 && max == 0 && bedrooms == 0 && bathrooms == 0) {
      return true;
    }
    //if any is greater than 0 then all must be greater than 0
    if (min > 0 || max > 0 || bedrooms > 0 || bathrooms > 0) {
      if (min == 0 || max == 0 || bedrooms == 0 || bathrooms == 0) {
        context.showError(
            "${min == 0 ? "min, " : ""}${max == 0 ? "max, " : ""}${bedrooms == 0 ? "bedrooms, " : ""}${bathrooms == 0 ? "bathrooms, " : ""}must be greater than 0");
        return false;
      }
    }
    return true;
  }

  // must fetch
  bool mustFetch() {
    return min > 0 && max > 0 && bedrooms > 0 && bathrooms > 0;
  }
}

class QuoteData extends Equatable {
  int? id;
  String? quoteComment;

  QuoteData({
    this.quoteComment,
    this.id,
  });

  @override
  List<Object?> get props => [quoteComment, id];

  //copyWith
  QuoteData copyWith({
    String? quoteComment,
    int? id,
  }) {
    return QuoteData(
      quoteComment: quoteComment ?? this.quoteComment,
      id: id ?? this.id,
    );
  }

  //copyFrom from QuoteMd quote
  QuoteData copyFromQuote(QuoteMd quote) {
    return QuoteData(
      id: quote.id,
      quoteComment: quote.quoteComments,
    );
  }
}

class ProductData extends Equatable {
  PlutoGridStateManager? stateManager;

  ProductData({this.stateManager});

  List<StorageItemMd> items(List<StorageItemMd> storageItems) {
    final list = <StorageItemMd>[];
    for (var row in (stateManager?.rows ?? [])) {
      final item = storageItems
          .firstWhereOrNull((e) => e.id == row.cells["id"]!.value)
          ?.copyWith();
      if (item != null) {
        item.quantity = row.cells["quantity"]!.value;
        item.auto = row.checked == true;
        item.outgoingPrice = row.cells["price"]!.value;
        list.add(item);
      }
    }

    return list;
  }

  @override
  List<Object?> get props => [stateManager];

  //copyWith
  ProductData copyWith({
    PlutoGridStateManager? stateManager,
  }) {
    return ProductData(
      stateManager: stateManager ?? this.stateManager,
    );
  }

  //Validate
  bool isValid(BuildContext context) {
    if (stateManager?.rows.isEmpty == true) {
      context.showError("Please add at least one product");
      return false;
    }
    return stateManager?.rows.isNotEmpty == true;
  }
}
