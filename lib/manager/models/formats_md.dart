import 'package:json_annotation/json_annotation.dart';
part 'formats_md.g.dart';

@JsonSerializable(anyMap: true)
class FormatMd {
  String short;
  String datetime;
  String long;
  String full_date;
  String form_short;
  String form_long;
  String form_datepicker;
  String form_daterangepicker;
  String form_datetimerangepicker;
  String calendar;
  String timesheet;
  String schedule;
  String time;
  String yearmonth;
  String monthday;
  String sort_monthday;
  IntervalDay interval_day;
  IntervalMonth interval_month;

  @override
  FormatMd({
    required this.calendar,
    required this.datetime,
    required this.form_datepicker,
    required this.form_daterangepicker,
    required this.form_datetimerangepicker,
    required this.form_long,
    required this.form_short,
    required this.full_date,
    required this.interval_day,
    required this.interval_month,
    required this.long,
    required this.monthday,
    required this.schedule,
    required this.short,
    required this.sort_monthday,
    required this.time,
    required this.timesheet,
    required this.yearmonth,
  });

  factory FormatMd.fromJson(Map<String, dynamic> json) =>
      _$FormatMdFromJson(json);

  Map<String, dynamic> toJson() => _$FormatMdToJson(this);
}

@JsonSerializable(anyMap: true)
class IntervalDay {
  String first;
  String second;

  @override
  IntervalDay({
    required this.first,
    required this.second,
  });

  factory IntervalDay.fromJson(Map<String, dynamic> json) =>
      _$IntervalDayFromJson(json);

  Map<String, dynamic> toJson() => _$IntervalDayToJson(this);
}

@JsonSerializable(anyMap: true)
class IntervalMonth {
  String first;
  String second;
  @override
  IntervalMonth({
    required this.second,
    required this.first,
  });

  factory IntervalMonth.fromJson(Map<String, dynamic> json) =>
      _$IntervalMonthFromJson(json);

  Map<String, dynamic> toJson() => _$IntervalMonthToJson(this);
}
