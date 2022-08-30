// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preffered_shift_md_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferredShiftMd _$PreferredShiftMdFromJson(Map json) => PreferredShiftMd(
      day: json['day'] as String,
      dayId: json['dayId'] as int,
      finish:
          LastTime.fromJson(Map<String, dynamic>.from(json['finish'] as Map)),
      hours: json['hours'] as int,
      id: json['id'] as int,
      location: json['location'] as String,
      start: LastTime.fromJson(Map<String, dynamic>.from(json['start'] as Map)),
      title: json['title'] as String,
      weekId: json['weekId'] as int,
    );

Map<String, dynamic> _$PreferredShiftMdToJson(PreferredShiftMd instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dayId': instance.dayId,
      'weekId': instance.weekId,
      'day': instance.day,
      'hours': instance.hours,
      'start': instance.start,
      'finish': instance.finish,
      'location': instance.location,
      'title': instance.title,
    };
