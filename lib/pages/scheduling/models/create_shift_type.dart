import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

  bool isGridInitialized = false;
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

  PlutoRow buildRow(StorageItemMd contractShiftItem,
      {bool checked = false, int? qty}) {
    return PlutoRow(
      checked: checked,
      cells: {
        "id": PlutoCell(value: contractShiftItem.id),
        "title": PlutoCell(
            value: contractShiftItem.name +
                " - " +
                contractShiftItem.service.toString()),
        "customer_price": PlutoCell(value: contractShiftItem.outgoingPrice),
        "quantity": PlutoCell(value: qty ?? 1),
        "delete_action": PlutoCell(value: ""),
        "include_in_service": PlutoCell(value: "Included in service"),
      },
    );
  }
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

  AppointmentIdMd? editAppointment;

  QuoteInfoMd? _fetchedQuote;
  QuoteInfoMd? get fetchedQuote => _fetchedQuote;
  set fetchedQuote(QuoteInfoMd? quote) {
    if (quote == null) return;
    _fetchedQuote = quote;
    quoteId = quote.id;
    client = appStore.state.generalState.clientInfos
        .firstWhereOrNull((element) => element.id == quote.clientId);
    location = appStore.state.generalState.locations
        .firstWhereOrNull((element) => element.id == quote.locationId);
    timingInfo.startDate = quote.workStartDate?.toDate();
    timingInfo.startTime = quote.workStartTime?.formattedTime;
    timingInfo.endTime = quote.workFinishTime?.formattedTime;
    final foundWorkRepeat = appStore.state.generalState.workRepeats
        .indexWhere((element) => element.days == quote.workRepeat);
    if (foundWorkRepeat != -1) {
      timingInfo.repeatTypeIndex = foundWorkRepeat;
      timingInfo.repeatDays = [...quote.workDays];
    }
    isActive = quote.active;
    title = quote.name;
    for (UserInfo user in (quote.users ?? [])) {
      final userRes = appStore.state.usersState.users
          .firstWhereOrNull((element) => element.id == user.userId);
      if (userRes != null) {
        addedChildren.add(userRes);
        if (user.specialRate != null) {
          addedChildrenRates[userRes.id] = user.specialRate!.toDouble();
        }
      }
    }
    gridStateManager.appendRows(quote.items
        .map(
          (e) => buildRow(
            StorageItemMd(
              id: e.itemId,
              active: true,
              name: e.itemName,
              incomingPrice: 0,
              outgoingPrice: e.price,
              service: false,
              taxId: 1,
            ),
            checked: e.auto,
            qty: e.quantity,
          ),
        )
        .toList());
  }

  CreateShiftData({
    required super.date,
    this.hasComment = false,
    this.hasUnavUsers = true,
    this.hasWorkAddress = false,
    this.quoteId,
    this.hasAltTime = false,
    this.shiftId,
    this.editAppointment,
    this.type = ScheduleCreatePopupMenus.job,
  }) {
    if (selectedClientId != null) {
      client = appStore.state.generalState.clientInfos
          .firstWhereOrNull((element) => element.id == selectedClientId);
    }
    timingInfo.hasAltTime = hasAltTime;
    if (type == ScheduleCreatePopupMenus.quote) {
      scheduleLaterIndex = 1;
      timingInfo.repeatTypeIndex = 0;
      if (quoteId != null) {
        return;
      }
    }
    if (editAppointment != null) {
      final id = editAppointment!;
      final p = id.property;
      final sh = id.allocation;
      shiftId = p.id;
      client = appStore.state.generalState.clientInfos
          .firstWhereOrNull((element) => element.id == p.clientId);
      location = appStore.state.generalState.locations
          .firstWhereOrNull((element) => element.id == p.locationId);
      timingInfo.startDate = sh.dateTimeDate;
      timingInfo.startTime = p.startTime?.formattedTime;
      timingInfo.endTime = p.finishTime?.formattedTime;
      isActive = p.active ?? false;
    }
  }

  ScheduleCreatePopupMenus type;

  @override
  bool get isCreate => _fetchedQuote?.id == null;
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
