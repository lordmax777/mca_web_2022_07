// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatussMd _$StatussMdFromJson(Map<String, dynamic> json) => StatussMd(
      comment: json['comment'] as String?,
      created_on: json['created_on'] as String?,
      id: json['id'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      location: json['location'] as String?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      mode: json['mode'] as String?,
      name: json['name'] as String?,
      shift: json['shift'] as String?,
      timestamp: json['timestamp'] as String?,
      whithin_range: json['whithin_range'] as bool?,
    );

Map<String, dynamic> _$StatussMdToJson(StatussMd instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'comment': instance.comment,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'whithin_range': instance.whithin_range,
      'shift': instance.shift,
      'location': instance.location,
      'mode': instance.mode,
      'timestamp': instance.timestamp,
      'created_on': instance.created_on,
    };
