import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';

import '../../../../manager/manager.dart';

class ShiftDetailsData with DataSourceMixin<ShiftDetailsData> {
  final int? id;

  bool get isCreate => id == null;

  //Details
  final TextEditingController propertyName;
  final int? warehouseId;
  final int? locationId;
  final int? clientId;
  final int? checklistTemplateId;
  final WeekDaysMd weekDays;
  final bool active;

  //Timing
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final TimeOfDay? breakStartTime;
  final TimeOfDay? breakEndTime;
  final bool strictBreakTime;
  final TimeOfDay? mobileStartTime;
  final TimeOfDay? mobileEndTime;
  final TimeOfDay? mobileBreakStartTime;
  final TimeOfDay? mobileBreakEndTime;

  //Custom Rates
  final List<CustomRate> customRates;

  const ShiftDetailsData({
    this.id,
    required this.propertyName,
    this.warehouseId,
    this.locationId,
    this.clientId,
    this.checklistTemplateId,
    required this.weekDays,
    this.startTime,
    this.endTime,
    this.breakStartTime,
    this.breakEndTime,
    this.strictBreakTime = false,
    this.mobileStartTime,
    this.mobileEndTime,
    this.mobileBreakStartTime,
    this.mobileBreakEndTime,
    required this.customRates,
    this.active = true,
  });

  @override
  ShiftDetailsData copyWith({
    int? id,
    int? warehouseId,
    int? locationId,
    int? clientId,
    int? checklistTemplateId,
    WeekDaysMd? weekDays,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TimeOfDay? breakStartTime,
    TimeOfDay? breakEndTime,
    bool? strictBreakTime,
    TimeOfDay? mobileStartTime,
    TimeOfDay? mobileEndTime,
    TimeOfDay? mobileBreakStartTime,
    TimeOfDay? mobileBreakEndTime,
    bool? active,
  }) {
    return ShiftDetailsData(
      id: id ?? this.id,
      warehouseId: warehouseId ?? this.warehouseId,
      locationId: locationId ?? this.locationId,
      clientId: clientId ?? this.clientId,
      checklistTemplateId: checklistTemplateId ?? this.checklistTemplateId,
      weekDays: weekDays ?? this.weekDays,
      propertyName: propertyName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakStartTime: breakStartTime ?? this.breakStartTime,
      breakEndTime: breakEndTime ?? this.breakEndTime,
      strictBreakTime: strictBreakTime ?? this.strictBreakTime,
      mobileStartTime: mobileStartTime ?? this.mobileStartTime,
      mobileEndTime: mobileEndTime ?? this.mobileEndTime,
      mobileBreakStartTime: mobileBreakStartTime ?? this.mobileBreakStartTime,
      mobileBreakEndTime: mobileBreakEndTime ?? this.mobileBreakEndTime,
      customRates: customRates,
      active: active ?? this.active,
    );
  }

  @override
  void dispose() {
    propertyName.dispose();
    for (var rate in customRates) {
      rate.dispose();
    }
  }

  @override
  List<Object?> get props => [
        id,
        warehouseId,
        locationId,
        clientId,
        checklistTemplateId,
        weekDays,
        propertyName,
        startTime,
        endTime,
        breakStartTime,
        breakEndTime,
        strictBreakTime,
        mobileStartTime,
        mobileEndTime,
        mobileBreakStartTime,
        mobileBreakEndTime,
        customRates,
        active,
      ];

  //init
  static ShiftDetailsData init({int? id}) {
    return ShiftDetailsData(
      id: id,
      propertyName: TextEditingController(),
      weekDays: WeekDaysMd(),
      customRates: [],
    );
  }

  bool isValid(BuildContext context) {
    if (propertyName.text.isEmpty ||
        locationId == null ||
        startTime == null ||
        endTime == null ||
        !weekDays.isAnyChecked ||
        checklistTemplateId == null ||
        clientId == null ||
        warehouseId == null) {
      context.showError(
          "Please fill the required fields: ${propertyName.text.isEmpty ? "${appStore.state.generalState.propertyName} Name, " : ""} ${locationId == null ? "Location, " : ""}${startTime == null ? "Start Time, " : ""}${endTime == null ? "End Time, " : ""}${!weekDays.isAnyChecked ? "Days, " : ""}${checklistTemplateId == null ? "Checklist Template, " : ""}${clientId == null ? "Client, " : ""}${warehouseId == null ? "Warehouse, " : ""}");
      return false;
    }
    return true;
  }

  factory ShiftDetailsData.from(PropertyMd? p) {
    if (p == null) return ShiftDetailsData.init();

    return ShiftDetailsData(
      id: p.id,
      propertyName: TextEditingController(text: p.title),
      weekDays: p.days is List
          ? WeekDaysMd.fromList(p.days)
          : p.days is Map
              ? WeekDaysMd.fromMap(p.days)
              : WeekDaysMd(),
      locationId: p.locationId,
      active: p.active,
      checklistTemplateId: p.checklistTemplateId,
      warehouseId: p.warehouseId,
      clientId: p.clientId,
      breakEndTime: p.finishBreakOfDay,
      breakStartTime: p.startBreakOfDay,
      endTime: p.finishTimeOfDay,
      mobileBreakEndTime: p.fpStartBreakDay,
      mobileBreakStartTime: p.fpFinishBreakDay,
      mobileEndTime: p.fpFinishTimeDay,
      mobileStartTime: p.fpStartTimeOfDay,
      startTime: p.startTimeOfDay,
      strictBreakTime: p.strictBreak,
      customRates: [],
    );
  }
}

class CustomRate with DataSourceMixin<CustomRate> {
  final int? id;
  final TextEditingController name;
  final TextEditingController rate;
  final TextEditingController minWorkTime;
  final TextEditingController minPaidTime;
  final bool splitTime;

  const CustomRate({
    required this.name,
    required this.rate,
    required this.minWorkTime,
    required this.minPaidTime,
    required this.splitTime,
    this.id,
  });

  @override
  List<Object?> get props => [
        name,
        rate,
        minWorkTime,
        minPaidTime,
        splitTime,
        id,
      ];

  @override
  void dispose() {
    name.dispose();
    rate.dispose();
    minWorkTime.dispose();
    minPaidTime.dispose();
  }

  @override
  CustomRate copyWith({
    bool? splitTime,
    int? id,
  }) {
    return CustomRate(
      name: name,
      rate: rate,
      minWorkTime: minWorkTime,
      minPaidTime: minPaidTime,
      splitTime: splitTime ?? this.splitTime,
      id: id ?? this.id,
    );
  }

  //init
  static CustomRate init() {
    return CustomRate(
      name: TextEditingController(),
      rate: TextEditingController(),
      minWorkTime: TextEditingController(),
      minPaidTime: TextEditingController(),
      splitTime: false,
    );
  }

  //from
  factory CustomRate.from(SpecialRateMd r) {
    return CustomRate(
      rate: TextEditingController(text: r.rate?.toString() ?? ""),
      minWorkTime: TextEditingController(text: r.minWorkTime?.toString() ?? ""),
      name: TextEditingController(text: r.name ?? ""),
      minPaidTime: TextEditingController(text: r.paidTime?.toString() ?? ""),
      splitTime: r.splitTime,
      id: r.id,
    );
  }
}
