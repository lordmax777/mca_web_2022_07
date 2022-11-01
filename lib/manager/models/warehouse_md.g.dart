// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarehouseMd _$WarehouseMdFromJson(Map json) => WarehouseMd(
      id: json['id'] as int,
      name: json['name'] as String,
      active: json['active'] as bool,
      sendReport: json['sendReport'] as bool,
      contactEmail: json['contactEmail'] as String?,
      contactName: json['contactName'] as String?,
      properties: (json['properties'] as List<dynamic>?)
          ?.map((e) => PropertyMd.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$WarehouseMdToJson(WarehouseMd instance) =>
    <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'name': instance.name,
      'contactName': instance.contactName,
      'contactEmail': instance.contactEmail,
      'sendReport': instance.sendReport,
      'properties': instance.properties,
    };

PropertyMd _$PropertyMdFromJson(Map json) => PropertyMd(
      id: json['id'] as int,
      locationName: json['locationName'] as String,
      propertyName: json['propertyName'] as String,
    );

Map<String, dynamic> _$PropertyMdToJson(PropertyMd instance) =>
    <String, dynamic>{
      'id': instance.id,
      'locationName': instance.locationName,
      'propertyName': instance.propertyName,
    };
