import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/timing_model.dart';

import '../../../manager/models/location_item_md.dart';
import '../scheduling_page.dart';

class JobModel {
  final ScheduleCreatePopupMenus type;

  AllocationModel? allocation;

  DateTime? get date => timingInfo.date;
  String? get dateAsString => timingInfo.date?.toIso8601String();

  DateTime? customDate;

  ClientInfoMd client = ClientInfoMd.init();

  void setClient(ClientInfoMd? clientInfoMd) {
    if (clientInfoMd == null) {
      client = ClientInfoMd.init();
    } else {
      client = clientInfoMd;
    }
    setAddress(null);
    setWorkAddress(null);
  }

  bool get isClientSelected => client.isClientTrue;

  bool active = true;

  LocationAddress _address = LocationAddress.init();
  LocationAddress get address => _address;
  void setAddress(LocationAddress? loc) {
    if (loc == null) {
      _address = LocationAddress.init();
      return;
    }
    _address = loc;
  }

  LocationAddress _workAddress = LocationAddress.init();
  LocationAddress get workAddress => _workAddress;
  void setWorkAddress(LocationAddress? loc) {
    if (loc == null) {
      _workAddress = LocationAddress.init();
      return;
    }
    _workAddress = loc;
  }

  bool get hasWorkAddress => type == ScheduleCreatePopupMenus.quote;

  TimingModel timingInfo = TimingModel();

  Map<UserRes, double> addedChildren = {};

  QuoteInfoMd? quote;

  //Getters
  bool get isCreate => allocation == null;
  bool get isUpdate => allocation != null;

  JobModel(
      {this.allocation,
      this.customDate,
      this.type = ScheduleCreatePopupMenus.job}) {
    if (allocation != null) {
      final cl = allocation!.shift.client;
      setClient(cl);
      setAddress(allocation!.location);
      // setWorkAddress(allocation!.location);
    }
    if (customDate != null) {
      timingInfo.date = customDate!;
      timingInfo.startTime =
          TimeOfDay(hour: customDate!.hour, minute: customDate!.minute);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JobModel &&
        other.allocation == allocation &&
        other.client == client &&
        other.address == address &&
        other.workAddress == workAddress &&
        other.timingInfo == timingInfo &&
        other.addedChildren == addedChildren &&
        other.quote == quote;
  }

  @override
  int get hashCode {
    return allocation.hashCode ^
        client.hashCode ^
        address.hashCode ^
        workAddress.hashCode ^
        timingInfo.hashCode ^
        addedChildren.hashCode ^
        quote.hashCode;
  }
}
