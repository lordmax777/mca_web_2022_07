import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/timing_model.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/rest/rest_client.dart';
import '../scheduling_page.dart';

class JobModel {
  final ScheduleCreatePopupMenus type;

  AllocationModel? allocation;

  DateTime? get date => timingInfo.date;
  String? get dateAsString => timingInfo.date?.toString().substring(0, 10);

  DateTime? customStartDate;
  DateTime? customEndDate;

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

  Address _address = Address.init();
  Address get address => _address;
  void setAddress(Address? loc) {
    if (loc == null) {
      _address = Address.init();
      return;
    }
    _address = loc;
  }

  Address _workAddress = Address.init();
  Address get workAddress => _workAddress;
  void setWorkAddress(Address? loc) {
    if (loc == null) {
      _workAddress = Address.init();
      return;
    }
    _workAddress = loc;
  }

  bool get hasWorkAddress => type == ScheduleCreatePopupMenus.quote;

  TimingModel timingInfo = TimingModel();

  Map<UserRes, double> addedChildren = {};

  AppState get state => appStore.state;
  QuoteInfoMd? _quote;
  QuoteInfoMd? get quote => _quote;
  set quote(QuoteInfoMd? q) {
    if (q == null) return;
    _quote = q;
    client.name = q.name;
    client.company = q.company;
    client.email = q.email;
    client.phone = q.phone;
    client.payingDays = q.payingDays;
    client.currencyId = q.currencyId.toString();
    client.paymentMethodId = q.paymentMethodId.toString();
    client.notes = q.clientInfo?.notes;
    quoteComment = q.quoteComments;
    setAddress(q.addressModel);
    setWorkAddress(q.workAddressModel);
    timingInfo.date = q.workStartDateAsDateTime;
    timingInfo.startTime = q.workStartTimeAsTimeOfDay;
    timingInfo.endTime = q.workFinishTimeAsTimeOfDay;
    timingInfo.altStartDate = q.altWorkStartDateAsDateTime;
    timingInfo.repeat = q.getWorkRepeat;
    //TODO: Check after posting a quote
    timingInfo.setDays(q.workDays);
    final allUsers = [...state.usersState.users];
    if (q.users != null && q.users!.isNotEmpty) {
      for (var user in q.users!) {
        final foundUser =
            allUsers.firstWhereOrNull((element) => element.id == user.userId);
        if (foundUser != null) {
          addedChildren[foundUser] = user.specialRate?.toDouble() ?? 0;
        }
      }
    }
  }

  String? quoteComment;

  //Getters
  bool get isCreate => allocation == null && quote == null;
  bool get isUpdate => allocation != null && quote != null;

  JobModel(
      {this.allocation,
      this.customStartDate,
      this.customEndDate,
      this.type = ScheduleCreatePopupMenus.job}) {
    if (customStartDate != null) {
      timingInfo.date = customStartDate!;
      timingInfo.startTime = TimeOfDay(
          hour: customStartDate!.hour, minute: customStartDate!.minute);
      timingInfo.endTime =
          TimeOfDay(hour: customEndDate!.hour, minute: customEndDate!.minute);
    }
    print(allocation?.shift.id);
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
