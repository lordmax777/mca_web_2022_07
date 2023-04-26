import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

abstract class CreateShiftDataType {
  ScheduleCreatePopupMenus get type;

  bool get isCreate;

  DateTime? date;
  int? selectedClientId;
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
        ' selectedClientId: $selectedClientId, '
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
  final PropertiesMd? property;

  final UnavailableUserLoad unavailableUsers = UnavailableUserLoad();

  CreateShiftData({required super.date, this.property}) {}

  @override
  ScheduleCreatePopupMenus get type => ScheduleCreatePopupMenus.job;

  @override
  bool get isCreate => property == null;
}

class CreateShiftDataQuote extends CreateShiftDataType {
  int? quoteId;
  DateTime? altStartDate;
  String? comments;

  QuoteInfoMd? quote;

  CreateShiftDataQuote({this.quoteId}) {
    scheduleLaterIndex = 1;
    repeatTypeIndex = 0;
    if (quoteId != null) {
      quote = appStore.state.generalState.quotes
          .firstWhereOrNull((element) => element.id == quoteId);
      if (quote != null) {
        // title = quote!.name;
        // selectedClientId = quote!.;
        // selectedLocationId = quote!.locationId;
        // tempAllowedLocationId = quote!.locationId;
        // startDate = quote!.startDate;
        // endDate = quote!.endDate;
        // isAllDay = quote!.isAllDay;
        // startTime = quote!.startTime;
        // endTime = quote!.endTime;
        // scheduleLaterIndex = quote!.scheduleLaterIndex;
        // repeatTypeIndex = quote!.repeatTypeIndex;
        // repeatDays = quote!.repeatDays;
        // paidHour = quote!.paidHour;
        // paidMinute = quote!.paidMinute;
        // isSplitTime = quote!.isSplitTime;
        // comments = quote!.comments;
        // addedChildren = quote!.addedChildren;
        // addedChildrenRates = quote!.addedChildrenRates;
      }
    }
  }
  @override
  bool get isCreate => quoteId == null;

  @override
  ScheduleCreatePopupMenus get type => ScheduleCreatePopupMenus.quote;
}
