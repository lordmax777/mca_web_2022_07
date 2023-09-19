import 'package:equatable/equatable.dart';

class TimesheetMd extends Equatable {
  final Map<String, dynamic> data;
  final List<dynamic> summary;
  final Map<String, dynamic> dates;
  final Map<String, dynamic> timesheetChecks;
  final String currentMonth;
  final num currentYear;
  final String currentDateFrom;
  DateTime? get currentDateFromDt => DateTime.tryParse(currentDateFrom);
  final String currentDateTo;
  DateTime? get currentDateToDt => DateTime.tryParse(currentDateTo);
  final String currentDate;
  DateTime? get currentDateDt => DateTime.tryParse(currentDate);
  final num currentTimestamp;
  DateTime? get currentTimestampDt =>
      DateTime.fromMillisecondsSinceEpoch((currentTimestamp * 1000).toInt());
  final num gracePeriod;

  const TimesheetMd({
    required this.data,
    required this.summary,
    required this.dates,
    required this.timesheetChecks,
    required this.currentMonth,
    required this.currentYear,
    required this.currentDateFrom,
    required this.currentDateTo,
    required this.currentDate,
    required this.currentTimestamp,
    required this.gracePeriod,
  });

  @override
  List<Object?> get props => [
        data,
        summary,
        dates,
        timesheetChecks,
        currentMonth,
        currentYear,
        currentDateFrom,
        currentDateTo,
        currentDate,
        currentTimestamp,
        gracePeriod,
      ];

  //fromJson
  factory TimesheetMd.fromJson(Map<String, dynamic> json) {
    try {
      // final data = <TsData>[];
      // if (json['data'].isNotEmpty) {
      //   //is empty
      //   for (final item in json['data'].values) {
      //     data.add(TsData.fromJson(item));
      //   }
      // }
      return TimesheetMd(
        data: json['data'] is List ? {} : json['data'],
        summary: json['summary'],
        dates: json['dates'] is List ? {} : json['dates'],
        timesheetChecks:
            json['timesheetChecks'] is List ? {} : json['timesheetChecks'],
        currentMonth: json['currentMonth'] as String,
        currentYear: json['currentYear'] as num,
        currentDateFrom: json['currentDateFrom'] as String,
        currentDateTo: json['currentDateTo'] as String,
        currentDate: json['currentDate'] as String,
        currentTimestamp: json['currentTimestamp'] as num,
        gracePeriod: json['gracePeriod'] as num,
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }

  //init
  factory TimesheetMd.init() {
    return const TimesheetMd(
      data: {},
      summary: [],
      dates: {},
      timesheetChecks: {},
      currentMonth: '',
      currentYear: 0,
      currentDateFrom: '',
      currentDateTo: '',
      currentDate: '',
      currentTimestamp: 0,
      gracePeriod: 0,
    );
  }
}

final class TsData extends Equatable {
  final int id;
  final int userId;
  final int shiftId;
  final int agreedStartLocationId;
  final int agreedFinishLocationId;
  final int actualStartLocationId;
  final int actualFinishLocationId;
  final String username;
  final String title;
  final String firstName;
  final String lastName;
  final Map date;
  final num actualWorkingHours;
  final num originalAgreedHours;
  final num dayoff;
  final String shiftName;
  final String agreedStartTime;
  final String agreedFinishTime;
  final String actualStartIpAddress;
  final String actualFinishIpAddress;
  final String actualStartLatitude;
  final String actualStartLongitude;
  final String actualFinishLatitude;
  final String actualFinishLongitude;
  final String actualStartTime;
  final String actualFinishTime;
  final String actualStartTimeClass;
  final String actualFinishTimeClass;
  final num totalAgreedHours;
  final num deductedWorkingHours;
  final num lateTotal;
  final num lateLess;
  final num lateMore;
  final num leaveTotal;
  final num leaveLess;
  final num leaveMore;
  final num overtime;
  final num agreedOvertime;
  final num holidays;
  final String startComment;
  final String finishComment;
  final String actualLunchClass;
  final String lunchStartTime;
  final String lunchFinishTime;
  final num breaks;
  final String actualBreakClass;
  final num breakDeduction;
  final num totalBreakTime;

  const TsData({
    required this.id,
    required this.userId,
    required this.shiftId,
    required this.agreedStartLocationId,
    required this.agreedFinishLocationId,
    required this.actualStartLocationId,
    required this.actualFinishLocationId,
    required this.username,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.date,
    required this.actualWorkingHours,
    required this.originalAgreedHours,
    required this.dayoff,
    required this.shiftName,
    required this.agreedStartTime,
    required this.agreedFinishTime,
    required this.actualStartIpAddress,
    required this.actualFinishIpAddress,
    required this.actualStartLatitude,
    required this.actualStartLongitude,
    required this.actualFinishLatitude,
    required this.actualFinishLongitude,
    required this.actualStartTime,
    required this.actualFinishTime,
    required this.actualStartTimeClass,
    required this.actualFinishTimeClass,
    required this.totalAgreedHours,
    required this.deductedWorkingHours,
    required this.lateTotal,
    required this.lateLess,
    required this.lateMore,
    required this.leaveTotal,
    required this.leaveLess,
    required this.leaveMore,
    required this.overtime,
    required this.agreedOvertime,
    required this.holidays,
    required this.startComment,
    required this.finishComment,
    required this.actualLunchClass,
    required this.lunchStartTime,
    required this.lunchFinishTime,
    required this.breaks,
    required this.actualBreakClass,
    required this.breakDeduction,
    required this.totalBreakTime,
  });

  //fromJson with checking null
  factory TsData.fromJson(Map<String, dynamic> json) {
    return TsData(
      id: json['id'] ?? 0,
      userId: int.parse(json['userId']),
      shiftId: json['shiftId'] ?? 0,
      agreedStartLocationId: json['agreedStartLocationId'] ?? 0,
      agreedFinishLocationId: json['agreedFinishLocationId'] ?? 0,
      actualStartLocationId: json['actualStartLocationId'] ?? 0,
      actualFinishLocationId: json['actualFinishLocationId'] ?? 0,
      username: json['username'] ?? '',
      title: json['title'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      date: json['date'] ?? {},
      actualWorkingHours: json['actualWorkingHours'] ?? 0,
      originalAgreedHours: json['originalAgreedHours'] ?? 0,
      dayoff: json['dayoff'] ?? 0,
      shiftName: json['shiftName'] ?? '',
      agreedStartTime: json['agreedStartTime'] ?? '',
      agreedFinishTime: json['agreedFinishTime'] ?? '',
      actualStartIpAddress: json['actualStartIpAddress'] ?? '',
      actualFinishIpAddress: json['actualFinishIpAddress'] ?? '',
      actualStartLatitude: json['actualStartLatitude'] ?? '',
      actualStartLongitude: json['actualStartLongitude'] ?? '',
      actualFinishLatitude: json['actualFinishLatitude'] ?? '',
      actualFinishLongitude: json['actualFinishLongitude'] ?? '',
      actualStartTime: json['actualStartTime'] ?? '',
      actualFinishTime: json['actualFinishTime'] ?? '',
      actualStartTimeClass: json['actualStartTimeClass'] ?? '',
      actualFinishTimeClass: json['actualFinishTimeClass'] ?? '',
      totalAgreedHours: json['totalAgreedHours'] ?? 0,
      deductedWorkingHours: json['deductedWorkingHours'] ?? 0,
      lateTotal: json['lateTotal'] ?? 0,
      lateLess: json['lateLess'] ?? 0,
      lateMore: json['lateMore'] ?? 0,
      leaveTotal: json['leaveTotal'] ?? 0,
      leaveLess: json['leaveLess'] ?? 0,
      leaveMore: json['leaveMore'] ?? 0,
      overtime: json['overtime'] ?? 0,
      agreedOvertime: json['agreedOvertime'] ?? 0,
      holidays: json['holidays'] ?? 0,
      startComment: json['startComment'] ?? '',
      finishComment: json['finishComment'] ?? '',
      actualLunchClass: json['actualLunchClass'] ?? '',
      lunchStartTime: json['lunchStartTime'] ?? '',
      lunchFinishTime: json['lunchFinishTime'] ?? '',
      breaks: json['breaks'] ?? 0,
      actualBreakClass: json['actualBreakClass'] ?? '',
      breakDeduction: json['breakDeduction'] ?? 0,
      totalBreakTime: json['totalBreakTime'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        shiftId,
        agreedStartLocationId,
        agreedFinishLocationId,
        actualStartLocationId,
        actualFinishLocationId,
        username,
        title,
        firstName,
        lastName,
        date,
        actualWorkingHours,
        originalAgreedHours,
        dayoff,
        shiftName,
        agreedStartTime,
        agreedFinishTime,
        actualStartIpAddress,
        actualFinishIpAddress,
        actualStartLatitude,
        actualStartLongitude,
        actualFinishLatitude,
        actualFinishLongitude,
        actualStartTime,
        actualFinishTime,
        actualStartTimeClass,
        actualFinishTimeClass,
        totalAgreedHours,
        deductedWorkingHours,
        lateTotal,
        lateLess,
        lateMore,
        leaveTotal,
        leaveLess,
        leaveMore,
        overtime,
        agreedOvertime,
        holidays,
        startComment,
        finishComment,
        actualLunchClass,
        lunchStartTime,
        lunchFinishTime,
        breaks,
        actualBreakClass,
        breakDeduction,
        totalBreakTime,
      ];
}
