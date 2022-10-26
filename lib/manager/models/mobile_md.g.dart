// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileMd _$MobileMdFromJson(Map<String, dynamic> json) => MobileMd(
      registered: json['registered'] as String,
      registered_on: json['registered_on'] as String?,
      os: json['os'] as String?,
      ping_time: json['ping_time'] as int?,
    );

Map<String, dynamic> _$MobileMdToJson(MobileMd instance) => <String, dynamic>{
      'registered': instance.registered,
      'registered_on': instance.registered_on,
      'os': instance.os,
      'ping_time': instance.ping_time,
    };
