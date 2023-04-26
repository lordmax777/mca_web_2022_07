import 'package:flutter/foundation.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

class UnavailableUserLoad {
  bool isLoaded = kDebugMode ? true : false;
  List<UnavailableUserMd> _users = [];
  List<UnavailableUserMd> get users => _users;
  set users(List<UnavailableUserMd> users) {
    _users = users;
    isLoaded = true;
  }
}

abstract class CreateShiftDataType {
  ScheduleCreatePopupMenus get type;
  final DateTime? date;
  final PropertiesMd? property;
  final UnavailableUserLoad unavailableUsers = UnavailableUserLoad();

  String title = "";
  int? selectedClientId;
  int? selectedLocationId;
  int? tempAllowedLocationId;
  bool isActive = true;
  DateTime? startDate;
  DateTime? altStartDate;
  DateTime? endDate;
  bool isAllDay = false;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int scheduleLaterIndex = 0;
  int? repeatTypeIndex;
  List<int> repeatDays = [];
  int paidHour = 0;
  int paidMinute = 0;
  bool isSplitTime = false;
  String? comments;

  List<UserRes> addedChildren = [];
  Map<int, double> addedChildrenRates = {};

  late PlutoGridStateManager gridStateManager;

  CreateShiftDataType({this.date, this.property});

  @override
  String toString() {
    return 'CreateShiftDataType{type: $type, date: $date, property: $property, title: $title, selectedClientId: $selectedClientId, selectedLocationId: $selectedLocationId, tempAllowedLocationId: $tempAllowedLocationId, isActive: $isActive, startDate: $startDate, altStartDate: $altStartDate, endDate: $endDate, isAllDay: $isAllDay, startTime: $startTime, endTime: $endTime, scheduleLaterIndex: $scheduleLaterIndex, repeatTypeIndex: $repeatTypeIndex, repeatDays: $repeatDays, paidHour: $paidHour, paidMinute: $paidMinute, isSplitTime: $isSplitTime, comments: $comments, addedChildren: $addedChildren, addedChildrenRates: $addedChildrenRates, gridStateManager: $gridStateManager}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateShiftDataType &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          date == other.date &&
          property == other.property &&
          title == other.title &&
          selectedClientId == other.selectedClientId &&
          selectedLocationId == other.selectedLocationId &&
          tempAllowedLocationId == other.tempAllowedLocationId &&
          isActive == other.isActive &&
          startDate == other.startDate &&
          altStartDate == other.altStartDate &&
          endDate == other.endDate &&
          isAllDay == other.isAllDay &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          scheduleLaterIndex == other.scheduleLaterIndex &&
          repeatTypeIndex == other.repeatTypeIndex &&
          repeatDays == other.repeatDays &&
          paidHour == other.paidHour &&
          paidMinute == other.paidMinute &&
          isSplitTime == other.isSplitTime &&
          comments == other.comments &&
          addedChildren == other.addedChildren &&
          addedChildrenRates == other.addedChildrenRates &&
          gridStateManager == other.gridStateManager;

  @override
  int get hashCode =>
      type.hashCode ^
      date.hashCode ^
      property.hashCode ^
      title.hashCode ^
      selectedClientId.hashCode ^
      selectedLocationId.hashCode ^
      tempAllowedLocationId.hashCode ^
      isActive.hashCode ^
      startDate.hashCode ^
      altStartDate.hashCode ^
      endDate.hashCode ^
      isAllDay.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      scheduleLaterIndex.hashCode ^
      repeatTypeIndex.hashCode ^
      repeatDays.hashCode ^
      paidHour.hashCode ^
      paidMinute.hashCode ^
      isSplitTime.hashCode ^
      comments.hashCode ^
      addedChildren.hashCode ^
      addedChildrenRates.hashCode ^
      gridStateManager.hashCode;
}

class CreateShiftData extends CreateShiftDataType {
  CreateShiftData({required super.date, super.property});

  @override
  ScheduleCreatePopupMenus get type => ScheduleCreatePopupMenus.job;
}

class CreateShiftDataQuote extends CreateShiftDataType {
  int? quoteId;

  CreateShiftDataQuote({this.quoteId});

  @override
  ScheduleCreatePopupMenus get type => ScheduleCreatePopupMenus.quote;
}
