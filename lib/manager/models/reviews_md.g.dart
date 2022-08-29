// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewMd _$ReviewMdFromJson(Map json) => ReviewMd(
      date: json['date'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String,
      conducted_by: json['conducted_by'] as String,
    );

Map<String, dynamic> _$ReviewMdToJson(ReviewMd instance) => <String, dynamic>{
      'date': instance.date,
      'conducted_by': instance.conducted_by,
      'title': instance.title,
      'notes': instance.notes,
    };
