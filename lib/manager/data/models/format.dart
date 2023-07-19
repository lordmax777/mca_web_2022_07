import 'package:equatable/equatable.dart';

final class FormatMd extends Equatable {
  //{
  //     "short": "d/m/Y",
  //     "datetime": "d/m/Y H:i",
  //     "long": "jS F Y",
  //     "interval_day": [
  //         "jS - ",
  //         "%long%"
  //     ],
  //     "interval_month": [
  //         "jS F - ",
  //         "%long%"
  //     ],
  //     "full_date": "D, jS F Y",
  //     "form_short": "dd/MM/yyyy",
  //     "form_long": "dd/MM/yyyy HH:mm",
  //     "form_datepicker": "dd/mm/yy",
  //     "form_daterangepicker": "dd/mm/yy",
  //     "form_datetimerangepicker": "d/m/y HH:mm",
  //     "calendar": "D jS M",
  //     "timesheet": "%month% %year%",
  //     "schedule": "Week %weekno%, %year% (%date_from% - %date_to%)",
  //     "time": "H:i",
  //     "yearmonth": "F Y",
  //     "monthday": "jS F",
  //     "short_monthday": "d M"
  // }

  final String short;
  final String datetime;
  final String long;
  final List<String> intervalDay;
  final List<String> intervalMonth;
  final String fullDate;
  final String formShort;
  final String formLong;
  final String formDatepicker;
  final String formDaterangepicker;
  final String formDatetimerangepicker;
  final String calendar;
  final String timesheet;
  final String schedule;
  final String time;
  final String yearmonth;
  final String monthday;
  final String shortMonthday;

  const FormatMd({
    required this.short,
    required this.datetime,
    required this.long,
    required this.intervalDay,
    required this.intervalMonth,
    required this.fullDate,
    required this.formShort,
    required this.formLong,
    required this.formDatepicker,
    required this.formDaterangepicker,
    required this.formDatetimerangepicker,
    required this.calendar,
    required this.timesheet,
    required this.schedule,
    required this.time,
    required this.yearmonth,
    required this.monthday,
    required this.shortMonthday,
  });

  factory FormatMd.fromJson(Map<String, dynamic> json) {
    return FormatMd(
      short: json['short'] ?? "",
      datetime: json['datetime'] ?? "",
      long: json['long'] ?? "",
      intervalDay: json['interval_day']?.cast<String>() ?? [],
      intervalMonth: json['interval_month']?.cast<String>() ?? [],
      fullDate: json['full_date'] ?? "",
      formShort: json['form_short'] ?? "",
      formLong: json['form_long'] ?? "",
      formDatepicker: json['form_datepicker'] ?? "",
      formDaterangepicker: json['form_daterangepicker'] ?? "",
      formDatetimerangepicker: json['form_datetimerangepicker'] ?? "",
      calendar: json['calendar'] ?? "",
      timesheet: json['timesheet'] ?? "",
      schedule: json['schedule'] ?? "",
      time: json['time'] ?? "",
      yearmonth: json['yearmonth'] ?? "",
      monthday: json['monthday'] ?? "",
      shortMonthday: json['short_monthday'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'short': short,
        'datetime': datetime,
        'long': long,
        'interval_day': intervalDay,
        'interval_month': intervalMonth,
        'full_date': fullDate,
        'form_short': formShort,
        'form_long': formLong,
        'form_datepicker': formDatepicker,
        'form_daterangepicker': formDaterangepicker,
        'form_datetimerangepicker': formDatetimerangepicker,
        'calendar': calendar,
        'timesheet': timesheet,
        'schedule': schedule,
        'time': time,
        'yearmonth': yearmonth,
        'monthday': monthday,
        'short_monthday': shortMonthday,
      };

  //init empty
  factory FormatMd.init() => FormatMd.fromJson(const {});

  @override
  List<Object?> get props => [
        short,
        datetime,
        long,
        intervalDay,
        intervalMonth,
        fullDate,
        formShort,
        formLong,
        formDatepicker,
        formDaterangepicker,
        formDatetimerangepicker,
        calendar,
        timesheet,
        schedule,
        time,
        yearmonth,
        monthday,
        shortMonthday
      ];
}
