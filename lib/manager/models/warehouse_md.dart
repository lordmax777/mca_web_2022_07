import 'dart:math';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'warehouse_md.g.dart';

@JsonSerializable(anyMap: true)
class WarehouseMd {
  int id;
  bool active;
  String name;
  String? contactName;
  String? contactEmail;
  bool sendReport;
  List<PropertyMd>? properties;
  @override
  WarehouseMd({
    required this.id,
    required this.name,
    required this.active,
    required this.sendReport,
    this.contactEmail,
    this.contactName,
    this.properties,
  });

  factory WarehouseMd.fromJson(Map<String, dynamic> json) =>
      _$WarehouseMdFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseMdToJson(this);
}

@JsonSerializable(anyMap: true)
class PropertyMd {
  int id;
  String locationName;
  String propertyName;

  @JsonKey(ignore: true)
  Color userRandomBgColor = Color.fromRGBO(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 0.3);

  @override
  PropertyMd({
    required this.id,
    required this.locationName,
    required this.propertyName,
  });

  factory PropertyMd.fromJson(Map<String, dynamic> json) =>
      _$PropertyMdFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyMdToJson(this);
}
