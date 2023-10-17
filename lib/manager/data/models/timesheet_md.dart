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
  //{
  //                         "id": 215581,
  //                         "userId": "805",
  //                         "shiftId": "347",
  //                         "agreedStartLocationId": "129",
  //                         "agreedFinishLocationId": "129",
  //                         "actualStartLocationId": "129",
  //                         "actualFinishLocationId": null,
  //                         "username": "38195839",
  //                         "title": "Mr",
  //                         "firstName": "Dipen",
  //                         "lastName": "One",
  //                         "date": "2022-04-01",
  //                         "actualWorkingHours": 0,
  //                         "originalAgreedHours": 180,
  //                         "dayoff": 0,
  //                         "shiftName": "154 Bayham Street NW1 0AU Camden",
  //                         "agreedStartTime": "08:00:00",
  //                         "agreedFinishTime": "21:00:00",
  //                         "actualStartIpAddress": "180.231.119.164",
  //                         "actualFinishIpAddress": null,
  //                         "actualStartLatitude": 127.0703385,
  //                         "actualStartLongitude": 127.0703385,
  //                         "actualFinishLatitude": null,
  //                         "actualFinishLongitude": null,
  //                         "actualStartTime": "07:20:34",
  //                         "actualFinishTime": null,
  //                         "actualStartTimeClass": "PunchIncorrect PILocation",
  //                         "actualFinishTimeClass": "PunchMissing",
  //                         "totalAgreedHours": 180,
  //                         "deductedWorkingHours": 0,
  //                         "lateTotal": 0,
  //                         "lateLess": 0,
  //                         "lateMore": 0,
  //                         "leaveTotal": 0,
  //                         "leaveLess": 0,
  //                         "leaveMore": 0,
  //                         "overtime": 0,
  //                         "agreedOvertime": 0,
  //                         "holidays": [
  //                             {
  //                                 "id": 344,
  //                                 "start": "2022-04-01 00:00:00",
  //                                 "finish": "2022-04-05 23:59:59",
  //                                 "userId": "805",
  //                                 "typeId": "1",
  //                                 "comment": "",
  //                                 "accepted": 1,
  //                                 "acceptedComment": "",
  //                                 "name": "Holiday",
  //                                 "fullday": 1,
  //                                 "paid": true,
  //                                 "initial": "H",
  //                                 "textColor": "00ff00",
  //                                 "backgroundColor": "ffffff",
  //                                 "borderColor": "000000",
  //                                 "bothtime": 0,
  //                                 "fulldayPaid": true
  //                             }
  //                         ],
  //                         "startComment": null,
  //                         "finishComment": null,
  //                         "actualLunchClass": null,
  //                         "lunchStartTime": "07:55:58",
  //                         "lunchFinishTime": "07:56:34",
  //                         "breaks": [
  //                             {
  //                                 "start": "2022-04-01 07:20:48",
  //                                 "finish": "2022-04-01 07:51:49"
  //                             },
  //                             {
  //                                 "start": "2022-04-01 07:53:50",
  //                                 "finish": "2022-04-01 07:54:18"
  //                             },
  //                             {
  //                                 "start": "2022-04-01 07:59:08",
  //                                 "finish": "2022-04-01 08:04:54"
  //                             },
  //                             {
  //                                 "start": "2022-04-01 08:08:10",
  //                                 "finish": "2022-04-01 08:08:29"
  //                             }
  //                         ],
  //                         "actualBreakClass": null,
  //                         "breakDeduction": 0,
  //                         "totalBreakTime": 0
  //                     }

  final int id;
  final String? userId;
  final String? shiftId;
  final String? agreedStartLocationId;
  final String? agreedFinishLocationId;
  final String? actualStartLocationId;
  final String? actualFinishLocationId;
  final String? username;
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? date;
  final num? actualWorkingHours;
  final num? originalAgreedHours;
  final num? dayoff;
  final String? shiftName;
  final String? agreedStartTime;
  final String? agreedFinishTime;
  final String? actualStartIpAddress;
  final String? actualFinishIpAddress;
  final num? actualStartLatitude;
  final num? actualStartLongitude;
  final num? actualFinishLatitude;
  final num? actualFinishLongitude;
  final String? actualStartTime;
  final String? actualFinishTime;
  final String? actualStartTimeClass;
  final String? actualFinishTimeClass;
  final num? totalAgreedHours;
  final num? deductedWorkingHours;
  final num? lateTotal;
  final num? lateLess;
  final num? lateMore;
  final num? leaveTotal;
  final num? leaveLess;
  final num? leaveMore;
  final num? overtime;
  final num? agreedOvertime;
  final List<HolidayMd>? holidays;
  final String? startComment;
  final String? finishComment;
  final String? actualLunchClass;
  final String? lunchStartTime;
  final String? lunchFinishTime;
  final List? breaks;
  final String? actualBreakClass;
  final num? breakDeduction;
  final num? totalBreakTime;

  TsData({
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

  //fromJson
  factory TsData.fromJson(Map<String, dynamic> json) {
    try {
      print(json['breaks']);
      return TsData(
        id: json['id'] as int,
        userId: json['userId'] as String?,
        shiftId: json['shiftId'] as String?,
        agreedStartLocationId: json['agreedStartLocationId'] as String?,
        agreedFinishLocationId: json['agreedFinishLocationId'] as String?,
        actualStartLocationId: json['actualStartLocationId'] as String?,
        actualFinishLocationId: json['actualFinishLocationId'] as String?,
        username: json['username'] as String?,
        title: json['title'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        date: json['date'] as String?,
        actualWorkingHours: json['actualWorkingHours'] as num?,
        originalAgreedHours: json['originalAgreedHours'] as num?,
        dayoff: json['dayoff'] as num?,
        shiftName: json['shiftName'] as String?,
        agreedStartTime: json['agreedStartTime'] as String?,
        agreedFinishTime: json['agreedFinishTime'] as String?,
        actualStartIpAddress: json['actualStartIpAddress'] as String?,
        actualFinishIpAddress: json['actualFinishIpAddress'] as String?,
        actualStartLatitude: json['actualStartLatitude'] as num?,
        actualStartLongitude: json['actualStartLongitude'] as num?,
        actualFinishLatitude: json['actualFinishLatitude'] as num?,
        actualFinishLongitude: json['actualFinishLongitude'] as num?,
        actualStartTime: json['actualStartTime'] as String?,
        actualFinishTime: json['actualFinishTime'] as String?,
        actualStartTimeClass: json['actualStartTimeClass'] as String?,
        actualFinishTimeClass: json['actualFinishTimeClass'] as String?,
        totalAgreedHours: json['totalAgreedHours'] as num?,
        deductedWorkingHours: json['deductedWorkingHours'] as num?,
        lateTotal: json['lateTotal'] as num?,
        lateLess: json['lateLess'] as num?,
        lateMore: json['lateMore'] as num?,
        leaveTotal: json['leaveTotal'] as num?,
        leaveLess: json['leaveLess'] as num?,
        leaveMore: json['leaveMore'] as num?,
        overtime: json['overtime'] as num?,
        agreedOvertime: json['agreedOvertime'] as num?,
        holidays: json['holidays']
            ?.map((e) => HolidayMd.fromJson(e as Map<String, dynamic>))
            .toList(),
        startComment: json['startComment'] as String?,
        finishComment: json['finishComment'] as String?,
        actualBreakClass: json['actualBreakClass'] as String?,
        actualLunchClass: json['actualLunchClass'] as String?,
        breakDeduction: json['breakDeduction'] as num?,
        breaks: json['breaks']?.map((e) => e as Map<String, dynamic>).toList(),
        lunchFinishTime: json['lunchFinishTime'] as String?,
        lunchStartTime: json['lunchStartTime'] as String?,
        totalBreakTime: json['totalBreakTime'] as num?,
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }
}

class HolidayMd extends Equatable {
  //{
  //                                 "id": 344,
  //                                 "start": "2022-04-01 00:00:00",
  //                                 "finish": "2022-04-05 23:59:59",
  //                                 "userId": "805",
  //                                 "typeId": "1",
  //                                 "comment": "",
  //                                 "accepted": 1,
  //                                 "acceptedComment": "",
  //                                 "name": "Holiday",
  //                                 "fullday": 1,
  //                                 "paid": true,
  //                                 "initial": "H",
  //                                 "textColor": "00ff00",
  //                                 "backgroundColor": "ffffff",
  //                                 "borderColor": "000000",
  //                                 "bothtime": 0,
  //                                 "fulldayPaid": true
  //                             }
  final int id;
  final String start;
  final String finish;
  final String userId;
  final String typeId;
  final String comment;
  final int accepted;
  final String acceptedComment;
  final String name;
  final int fullday;
  final bool paid;
  final String initial;
  final String textColor;
  final String backgroundColor;
  final String borderColor;
  final int bothtime;
  final bool fulldayPaid;

  const HolidayMd({
    required this.id,
    required this.start,
    required this.finish,
    required this.userId,
    required this.typeId,
    required this.comment,
    required this.accepted,
    required this.acceptedComment,
    required this.name,
    required this.fullday,
    required this.paid,
    required this.initial,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.bothtime,
    required this.fulldayPaid,
  });

  @override
  List<Object?> get props => [
        id,
        start,
        finish,
        userId,
        typeId,
        comment,
        accepted,
        acceptedComment,
        name,
        fullday,
        paid,
        initial,
        textColor,
        backgroundColor,
        borderColor,
        bothtime,
        fulldayPaid,
      ];

//fromJson
  factory HolidayMd.fromJson(Map<String, dynamic> json) {
    try {
      return HolidayMd(
        id: json['id'] as int,
        start: json['start'] as String,
        finish: json['finish'] as String,
        userId: json['userId'] as String,
        typeId: json['typeId'] as String,
        comment: json['comment'] as String,
        accepted: json['accepted'] as int,
        acceptedComment: json['acceptedComment'] as String,
        name: json['name'] as String,
        fullday: json['fullday'] as int,
        paid: json['paid'] as bool,
        initial: json['initial'] as String,
        textColor: json['textColor'] as String,
        backgroundColor: json['backgroundColor'] as String,
        borderColor: json['borderColor'] as String,
        bothtime: json['bothtime'] as int,
        fulldayPaid: json['fulldayPaid'] as bool,
      );
    } on TypeError catch (e) {
      print(e.stackTrace);
      rethrow;
    }
  }
}
