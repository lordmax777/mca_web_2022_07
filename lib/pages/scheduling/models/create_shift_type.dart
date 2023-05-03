import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../manager/models/location_item_md.dart';
import '../popup_forms/timing_form.dart';

abstract class CreateShiftDataType {
  ScheduleCreatePopupMenus get type;

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
  int? repeatTypeIndex;
  List<int> repeatDays = [];

  List<UserRes> addedChildren = [];
  Map<int, double> addedChildrenRates = {};

  late PlutoGridStateManager gridStateManager;

  CreateShiftDataType({this.date});

  @override
  String toString() {
    return 'CreateShiftDataType{type: $type, date: $date,'
        'selectedLocationId: $selectedLocationId, tempAllowedLocationId: $tempAllowedLocationId,'
        ' isActive: $isActive,'
        'endDate: $endDate, isAllDay: $isAllDay, startTime: $startTime, endTime: $endTime,'
        ' scheduleLaterIndex: $scheduleLaterIndex, repeatTypeIndex: $repeatTypeIndex,'
        ' repeatDays: $repeatDays, '
        'addedChildren: $addedChildren,'
        ' addedChildrenRates: $addedChildrenRates, gridStateManager: $gridStateManager}';
  }
}

class UnavailableUserLoad {
  bool isLoaded = kDebugMode ? true : false;
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
  CreatedTimingReturnValue timingInfo =
      CreatedTimingReturnValue(hasAltTime: false);

  final UnavailableUserLoad unavailableUsers = UnavailableUserLoad();

  CreateShiftData({required super.date}) {
    if (selectedClientId != null) {
      client = appStore.state.generalState.clientInfos
          .firstWhereOrNull((element) => element.id == selectedClientId);
      if (client == null) return;
    }
  }

  @override
  ScheduleCreatePopupMenus get type => ScheduleCreatePopupMenus.job;

  @override
  bool get isCreate => selectedJobId == null || selectedJobId == 0;
}

class CreateShiftDataQuote extends CreateShiftDataType {
  int? quoteId;
  QuoteInfoMd quote = QuoteInfoMd.init();

  CreateShiftDataQuote({this.quoteId}) {
    scheduleLaterIndex = 1;
    repeatTypeIndex = 0;
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
