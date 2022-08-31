// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotosMd _$PhotosMdFromJson(Map<String, dynamic> json) => PhotosMd(
      createdOn: LastTime.fromJson(json['createdOn'] as Map<String, dynamic>),
      height: json['height'] as int,
      id: json['id'] as int,
      notes: json['notes'] as String,
      photo: json['photo'] as String,
      type: json['type'] as String,
      userId: json['userId'] as int,
      width: json['width'] as int,
    );

Map<String, dynamic> _$PhotosMdToJson(PhotosMd instance) => <String, dynamic>{
      'photo': instance.photo,
      'id': instance.id,
      'createdOn': instance.createdOn,
      'type': instance.type,
      'userId': instance.userId,
      'width': instance.width,
      'height': instance.height,
      'notes': instance.notes,
    };
