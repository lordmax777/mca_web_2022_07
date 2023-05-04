import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../manager/models/location_item_md.dart';
import '../popup_forms/timing_form.dart';

abstract class CreateShiftDataType {
  bool get isCreate;

  DateTime? date;
  int? selectedLocationId;
  bool isActive = true;
  int? tempAllowedLocationId;
  DateTime? endDate;
  bool isAllDay = false;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int scheduleLaterIndex = 0;
  List<int> repeatDays = [];

  List<UserRes> addedChildren = [];
  Map<int, double> addedChildrenRates = {};

  late PlutoGridStateManager gridStateManager;
  List<StorageItemMd> storageItems(List<StorageItemMd> storageItems) {
    return gridStateManager.rows
        .map<StorageItemMd>((row) {
          final item = storageItems.firstWhereOrNull(
              (element) => element.id == row.cells['id']!.value);
          if (item != null) {
            item.quantity = row.cells['quantity']!.value;
            item.outgoingPrice = row.cells['customer_price']!.value;
            item.auto = row.checked ?? false;
            return item;
          }
          return StorageItemMd.init();
        })
        .where((element) => element.id != -1)
        .toList();
  }

  late PlutoGridStateManager staffReqGridManager;

  late PlutoGridStateManager qualifReqGridManager;

  CreateShiftDataType({this.date});
}

class UnavailableUserLoad {
  bool isLoaded = false;
  List<UnavailableUserMd> _users = [];
  List<UnavailableUserMd> get users => _users;
  set users(List<UnavailableUserMd> users) {
    _users = users;
    isLoaded = true;
  }
}

class CreateShiftData extends CreateShiftDataType {
  String title = "";
  int paidHour = 0;

  int paidMinute = 0;
  bool isSplitTime = false;
  int? selectedClientId;
  int? selectedJobId;

  ClientInfoMd? client;
  LocationAddress? location;
  CreatedTimingReturnValue timingInfo = CreatedTimingReturnValue();
  bool hasAltTime;

  Address? workAddress;
  bool hasWorkAddress;
  int? tempAllowedLocIdWorkAddress;

  String comment = "";
  bool hasComment;

  final UnavailableUserLoad unavailableUsers = UnavailableUserLoad();
  bool hasUnavUsers;

  int? quoteId;

  int? shiftId;

  CreateShiftData({
    required super.date,
    this.hasComment = false,
    this.hasUnavUsers = true,
    this.hasWorkAddress = false,
    this.quoteId,
    this.hasAltTime = false,
    this.shiftId,
    this.type = ScheduleCreatePopupMenus.job,
  }) {
    if (selectedClientId != null) {
      client = appStore.state.generalState.clientInfos
          .firstWhereOrNull((element) => element.id == selectedClientId);
      if (client == null) return;
    }
    timingInfo.hasAltTime = hasAltTime;
    if (type == ScheduleCreatePopupMenus.quote) {
      scheduleLaterIndex = 1;
      timingInfo.repeatTypeIndex = 0;
      if (quoteId != null) {
        //TODO: SHOH

      }
    }
    if (kDebugMode) {
      shiftId = 379;
    }
  }

  ScheduleCreatePopupMenus type;

  @override
  bool get isCreate => selectedJobId == null || selectedJobId == 0;
}

class CreateShiftDataQuote extends CreateShiftDataType {
  int? quoteId;
  QuoteInfoMd quote = QuoteInfoMd.init();

  ClientInfoMd? _client;
  ClientInfoMd? get client => _client;
  set client(ClientInfoMd? client) {
    if (client == null) return;
    _client = client;
    quote.email = client.email;
    quote.phone = client.phone;
    quote.company = client.company;
    if (client.paymentMethodId != null) {
      quote.paymentMethodId = int.tryParse(client.paymentMethodId!) ?? 1;
    }
    quote.currencyId = int.tryParse(client.currencyId) ?? 1;
    quote.payingDays = client.payingDays;
    quote.notes = client.notes;
    quote.name = client.name;
  }

  set invoiceLocation(LocationAddress? address) {
    if (address == null) return;
    quote.addressLine1 = address.address?.line1;
    quote.addressLine2 = address.address?.line2;
    quote.addressCity = address.address?.city;
    quote.addressCounty = address.address?.county;
    quote.addressCountry = address.address?.country;
    quote.addressPostcode = address.address?.postcode;
  }

  set workLocation(LocationAddress? address) {
    if (address == null) return;
    if (address.anywhere == true) {
      quote.workAddressLine1 = address.name;
      return;
    }
    quote.workAddressLine1 = address.address?.line1;
    quote.workAddressLine2 = address.address?.line2;
    quote.workAddressCity = address.address?.city;
    quote.workAddressCounty = address.address?.county;
    quote.workAddressCountry = address.address?.country;
    quote.workAddressPostcode = address.address?.postcode;
  }

  CreateShiftDataQuote({this.quoteId}) {
    scheduleLaterIndex = 1;
    if (quoteId != null) {
      quote = appStore.state.generalState.quotes
              .firstWhereOrNull((element) => element.id == quoteId) ??
          QuoteInfoMd.init();
    }
  }
  @override
  bool get isCreate => quoteId == null || quote.id == 0;

  @override
  ScheduleCreatePopupMenus get type => ScheduleCreatePopupMenus.quote;
}
