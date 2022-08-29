// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qualifs_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QualifsMd _$QualifsMdFromJson(Map json) => QualifsMd(
      certificateNumber: json['certificateNumber'] as String,
      expire: json['expire'] as bool,
      expiryDate: LastTime.fromJson(
          Map<String, dynamic>.from(json['expiryDate'] as Map)),
      id: json['id'] as int,
      level: json['level'] as String,
      levelId: json['levelId'] as String,
      levels: json['levels'] as bool,
      title: json['title'] as String,
      uqId: json['uqId'] as int,
      imageType: json['imageType'] as String?,
      achievementDate: json['achievementDate'] == null
          ? null
          : LastTime.fromJson(
              Map<String, dynamic>.from(json['achievementDate'] as Map)),
      thumbnail: json['thumbnail'] as String?,
      comments: json['comments'] as String?,
      approvedOn: json['approvedOn'] as String?,
      certicate: json['certicate'] as String?,
    );

Map<String, dynamic> _$QualifsMdToJson(QualifsMd instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'expire': instance.expire,
      'levels': instance.levels,
      'uqId': instance.uqId,
      'achievementDate': instance.achievementDate,
      'certificateNumber': instance.certificateNumber,
      'expiryDate': instance.expiryDate,
      'levelId': instance.levelId,
      'level': instance.level,
      'comments': instance.comments,
      'certicate': instance.certicate,
      'thumbnail': instance.thumbnail,
      'imageType': instance.imageType,
      'approvedOn': instance.approvedOn,
    };
