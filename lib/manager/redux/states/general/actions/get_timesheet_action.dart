import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/models/timesheet_md.dart';
import 'package:mca_dashboard/manager/manager.dart';

class GetTimesheetAction {
  final int userId;
  final int timestamp;

  const GetTimesheetAction({
    this.userId = -1,
    required this.timestamp,
  });

  Future<Either<TimesheetMd, ErrorMd>> fetch(AppState state) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .getTimesheet(timestamp: timestamp, userId: userId);
      final timesheet = TimesheetMd.fromJson(res.data);
      return timesheet;
    });
  }
}

final class GetTimesheetPdfAction {
  final int userId;
  final int timestamp;

  const GetTimesheetPdfAction({
    required this.userId,
    required this.timestamp,
  });

  Future<Either<String, ErrorMd>> fetch(AppState state) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .getTimesheetPdf(userId: userId, timestamp: timestamp);
      try {
        final data = res.data['pdf'];
        return data;
      } catch (e) {
        Logger.e(e.toString(), tag: 'GetTimesheetPdfAction');
        throw const ErrorMd(
            message: 'Error while downloading pdf', data: null, code: null);
      }
    });
  }
}

final class PostTimesheetAction {
  final int userId;
  final int shiftId;
  final StatusMd status;
  final int locationId;
  final String? comment;
  final TimeOfDay time;
  final String? originalDate;
  final String date;

  const PostTimesheetAction({
    required this.userId,
    required this.shiftId,
    required this.status,
    required this.locationId,
    required this.comment,
    required this.time,
    this.originalDate,
    required this.date,
  });

  Future<Either<String?, ErrorMd>> fetch(AppState state) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient.postTimesheet(
          user: userId,
          shift: shiftId,
          type: status.id,
          loc: locationId,
          comment: comment,
          time: "${time.toApiTime}:00",
          original: originalDate,
          date: date);
      return res.response.statusMessage;
    });
  }
}

final class PostTimesheetWorkTimeAction {
  final int userId;
  final int shiftId;
  final int locationId;
  final String date;
  final String worktime;

  const PostTimesheetWorkTimeAction({
    required this.userId,
    required this.shiftId,
    required this.locationId,
    required this.date,
    required this.worktime,
  });

  Future<Either<String?, ErrorMd>> fetch(AppState state) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .postTimesheetWorkTime(
              user: userId,
              shift: shiftId,
              loc: locationId,
              worktime: worktime,
              date: date);
      return res.response.statusMessage;
    });
  }
}
