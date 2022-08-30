// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractMd _$ContractMdFromJson(Map json) => ContractMd(
      id: json['id'] as int,
      contractType: json['contractType'] as int,
      awh: json['awh'] as num?,
      AHEonYS: json['AHEonYS'] as bool?,
      hct: json['hct'] as num?,
      initHolidays: json['initHolidays'] as int?,
      wdpw: json['wdpw'] as num?,
      jobTitleId: json['jobTitleId'] as String?,
      salaryPH: (json['salaryPH'] as num?)?.toDouble(),
      salaryOT: (json['salaryOT'] as num?)?.toDouble(),
      ahe: json['ahe'] as num?,
      ahew: json['ahew'] as num?,
      csd: json['csd'] == null
          ? null
          : ContractDate.fromJson(
              Map<String, dynamic>.from(json['csd'] as Map)),
      ced: json['ced'] == null
          ? null
          : ContractDate.fromJson(
              Map<String, dynamic>.from(json['ced'] as Map)),
      jobDescription: json['jobDescription'] as String?,
      lunchtime: json['lunchtime'] as String?,
      lunchtimeUnpaid: json['lunchtimeUnpaid'] as String?,
    );

Map<String, dynamic> _$ContractMdToJson(ContractMd instance) =>
    <String, dynamic>{
      'id': instance.id,
      'csd': instance.csd,
      'ced': instance.ced,
      'awh': instance.awh,
      'ahe': instance.ahe,
      'ahew': instance.ahew,
      'wdpw': instance.wdpw,
      'hct': instance.hct,
      'lunchtime': instance.lunchtime,
      'lunchtimeUnpaid': instance.lunchtimeUnpaid,
      'contractType': instance.contractType,
      'AHEonYS': instance.AHEonYS,
      'initHolidays': instance.initHolidays,
      'jobDescription': instance.jobDescription,
      'salaryPH': instance.salaryPH,
      'salaryOT': instance.salaryOT,
      'jobTitleId': instance.jobTitleId,
    };

ContractDate _$ContractDateFromJson(Map json) => ContractDate(
      date: json['date'] as String,
      timezone: json['timezone'] as String,
      timezone_type: json['timezone_type'] as int,
    );

Map<String, dynamic> _$ContractDateToJson(ContractDate instance) =>
    <String, dynamic>{
      'timezone_type': instance.timezone_type,
      'date': instance.date,
      'timezone': instance.timezone,
    };
