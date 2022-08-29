// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visa_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisaMd _$VisaMdFromJson(Map json) => VisaMd(
      createdOn: LastTime.fromJson(
          Map<String, dynamic>.from(json['createdOn'] as Map)),
      document_no: json['document_no'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String,
      endDate: json['endDate'] == null
          ? null
          : LastTime.fromJson(
              Map<String, dynamic>.from(json['endDate'] as Map)),
      id: json['id'] as int,
      notExpire: json['notExpire'] as bool,
      startDate: LastTime.fromJson(
          Map<String, dynamic>.from(json['startDate'] as Map)),
    );

Map<String, dynamic> _$VisaMdToJson(VisaMd instance) => <String, dynamic>{
      'id': instance.id,
      'document_no': instance.document_no,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'notExpire': instance.notExpire,
      'createdOn': instance.createdOn,
      'notes': instance.notes,
      'title': instance.title,
    };
