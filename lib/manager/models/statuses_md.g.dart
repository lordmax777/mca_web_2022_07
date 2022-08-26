// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statuses_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusMd _$StatusMdFromJson(Map json) => StatusMd(
      active: json['active'] as bool,
      activeName: json['activeName'] as String,
      color: json['color'] as String,
      colorName: json['colorName'] as String,
      domains: (json['domains'] as List<dynamic>)
          .map((e) => DomainsMd.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      finishColor: json['finishColor'] as String,
      finishId: json['finishId'] as int,
      level: json['level'] as int,
      levelName: json['levelName'] as String,
      multi: json['multi'] as bool,
      nameFinish: json['nameFinish'] as String,
      nameStart: json['nameStart'] as String,
    );

Map<String, dynamic> _$StatusMdToJson(StatusMd instance) => <String, dynamic>{
      'nameStart': instance.nameStart,
      'nameFinish': instance.nameFinish,
      'active': instance.active,
      'activeName': instance.activeName,
      'level': instance.level,
      'levelName': instance.levelName,
      'multi': instance.multi,
      'color': instance.color,
      'colorName': instance.colorName,
      'domains': instance.domains,
      'finishId': instance.finishId,
      'finishColor': instance.finishColor,
    };

DomainsMd _$DomainsMdFromJson(Map json) => DomainsMd(
      id: json['id'] as int,
    );

Map<String, dynamic> _$DomainsMdToJson(DomainsMd instance) => <String, dynamic>{
      'id': instance.id,
    };
