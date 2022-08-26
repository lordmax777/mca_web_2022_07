// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formats_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormatMd _$FormatMdFromJson(Map json) => FormatMd(
      calendar: json['calendar'] as String,
      datetime: json['datetime'] as String,
      form_datepicker: json['form_datepicker'] as String,
      form_daterangepicker: json['form_daterangepicker'] as String,
      form_datetimerangepicker: json['form_datetimerangepicker'] as String,
      form_long: json['form_long'] as String,
      form_short: json['form_short'] as String,
      full_date: json['full_date'] as String,
      interval_day: IntervalDay.fromJson(
          Map<String, dynamic>.from(json['interval_day'] as Map)),
      interval_month: IntervalMonth.fromJson(
          Map<String, dynamic>.from(json['interval_month'] as Map)),
      long: json['long'] as String,
      monthday: json['monthday'] as String,
      schedule: json['schedule'] as String,
      short: json['short'] as String,
      sort_monthday: json['sort_monthday'] as String,
      time: json['time'] as String,
      timesheet: json['timesheet'] as String,
      yearmonth: json['yearmonth'] as String,
    );

Map<String, dynamic> _$FormatMdToJson(FormatMd instance) => <String, dynamic>{
      'short': instance.short,
      'datetime': instance.datetime,
      'long': instance.long,
      'full_date': instance.full_date,
      'form_short': instance.form_short,
      'form_long': instance.form_long,
      'form_datepicker': instance.form_datepicker,
      'form_daterangepicker': instance.form_daterangepicker,
      'form_datetimerangepicker': instance.form_datetimerangepicker,
      'calendar': instance.calendar,
      'timesheet': instance.timesheet,
      'schedule': instance.schedule,
      'time': instance.time,
      'yearmonth': instance.yearmonth,
      'monthday': instance.monthday,
      'sort_monthday': instance.sort_monthday,
      'interval_day': instance.interval_day,
      'interval_month': instance.interval_month,
    };

IntervalDay _$IntervalDayFromJson(Map json) => IntervalDay(
      first: json['first'] as String,
      second: json['second'] as String,
    );

Map<String, dynamic> _$IntervalDayToJson(IntervalDay instance) =>
    <String, dynamic>{
      'first': instance.first,
      'second': instance.second,
    };

IntervalMonth _$IntervalMonthFromJson(Map json) => IntervalMonth(
      second: json['second'] as String,
      first: json['first'] as String,
    );

Map<String, dynamic> _$IntervalMonthToJson(IntervalMonth instance) =>
    <String, dynamic>{
      'first': instance.first,
      'second': instance.second,
    };
