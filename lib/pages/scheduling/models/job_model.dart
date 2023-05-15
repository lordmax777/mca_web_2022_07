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

  ClientInfoMd get client {
    final cl = allocation?.shift.client;
    if (cl == null) {
      return ClientInfoMd.init();
    }
    return cl;
  }

  bool get isClientSelected => client.isClientTrue;

  set client(ClientInfoMd? clientInfoMd) {
    allocation?.shift.client = clientInfoMd;
  }

  bool active = true;

  LocationAddress? get address => allocation?.location;
  set address(LocationAddress? loc) {
    if (loc == null) return;
    allocation?.location = loc;
  }

  LocationAddress? workAddress;

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
    if (customDate != null) {
      print(customDate);
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
