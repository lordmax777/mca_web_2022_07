import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/schedule_widgets/shift_card.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../manager/data/models/timesheet_md.dart';

class ActualTimePopup extends StatefulWidget {
  final TsData model;
  //actual_start, actual_end, actual_hours, lunch_start, lunch_end
  final String type;
  const ActualTimePopup({super.key, required this.model, required this.type});

  @override
  State<ActualTimePopup> createState() => _ActualTimePopupState();
}

class _ActualTimePopupState extends State<ActualTimePopup> {
  TsData get model => widget.model;
  String get type => widget.type;
  bool get isWorkTime => type == "actual_hours";

  String comment = "";

  bool get isNew => time == null;

  String get fullName => '${model.firstName} ${model.lastName}';
  String get date {
    final DateTime? date = DateTime.tryParse(model.date ?? "");
    return date != null ? DateFormat.MMMEd().format(date) : '-';
  }

  List<StatusMd> get statuses => appStore.state.generalState.lists.statuses;
  StatusMd? get status {
    final bool isStart = type.split("_").last == "start";
    final bool isEnd = type.split("_").last == "end";
    final bool isLunch = type.split("_")[0] == "lunch";
    if (isLunch) {
      if (isStart) {
        return appStore.state.generalState.lists.statuses[4];
      }
      if (isEnd) {
        return appStore.state.generalState.lists.statuses[5];
      }
    }
    if (isStart) {
      return appStore.state.generalState.lists.statuses[0];
    }
    if (isEnd) {
      return appStore.state.generalState.lists.statuses[1];
    }
    return null;
  }

  int? locationId;
  void setLocationId() {
    String? locId;
    // String? key;
    // switch (type) {
    //   case "actual_start":
    //     key = "actualStartLocationId";
    //     break;
    //   case "actual_end":
    //     key = "actualFinishLocationId";
    //     break;
    //   case "work_time":
    //     key = "actualWorkingHours"; //in minutes
    //     break;
    //   case "lunch_start":
    //     key = "lunchStartLocationId";
    //     break;
    //   case "lunch_end":
    //     key = "lunchFinishLocationId";
    //     break;
    //   case "agreed_start":
    //     key = "agreedStartLocationId";
    //     break;
    //   case "agreed_end":
    //     key = "agreedFinishLocationId";
    //     break;
    // }

    // if (key != null) {
    //   final isEnd = key.contains("Finish");
    //   if (isEnd) {
    //     key = key.replaceAll("Finish", "Start");
    //   }
    final entries = model.toJson().entries;
    for (final e in entries) {
      final k = e.key;
      final v = e.value;
      if (k.contains("Location") && v != null) {
        locId = v as String?;
        break;
      }
    }
    // locId = model.toJson()[key] as String?;
    locationId = int.tryParse(locId ?? "");
    debugPrint('locationId: $locationId');
    if (locationId == null) {
      context.pop("start_loc_not_found");
    }
    setState(() {});
    // }
  }

  String? get shiftName => model.shiftName;
  TimeOfDay? time;
  void setTime() {
    String? key;
    switch (type) {
      case "actual_start":
        key = "actualStartTime";
        break;
      case "actual_end":
        key = "actualFinishTime";
        break;
      case "work_time":
        key = "actualWorkingHours"; //in minutes
        break;
      case "lunch_start":
        key = "lunchStartTime";
        break;
      case "lunch_end":
        key = "lunchFinishTime";
        break;
      case "agreed_start":
        key = "agreedStartTime";
        break;
      case "agreed_end":
        key = "agreedFinishTime";
        break;
    }
    if (key != null) {
      if (key != "actualWorkingHours") {
        final TimeOfDay? t = (model.toJson()[key] as String?)?.toTimeOfDay;
        time = t;
        debugPrint('time: $time');
        setState(() {});
      }
    }
  }

  String? originalDate;
  void setOriginalDate() {
    final date = model.date;
    final t = time;
    if (date != null && t != null) {
      originalDate =
          '$date ${t.toString().replaceAll("TimeOfDay", "").replaceAll("(", "").replaceAll(")", "")}';
      debugPrint('originalDate: $originalDate');
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    print(model.toJson());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setTime();
      setLocationId();
      setOriginalDate();
    });
  }

  void _onSubmit() async {
    if (!isWorkTime) {
      if (time == null) {
        context.showError('Please select time!');
        return;
      }
    }
    if (status == null && !isWorkTime) {
      context.showError('Cannot find status!');
      return;
    }
    if (!isWorkTime) {
      if (!isNew && time == null) {
        context.showError('Please select time!');
        return;
      }
    }
    final int? shiftId = int.tryParse(model.shiftId ?? "");
    if (shiftId == null) {
      context.showError('Cannot find shift id!');
      return;
    }
    if (locationId == null) {
      context.showError('Cannot find location id!');
      return;
    }
    final int? userId = int.tryParse(model.userId ?? "");
    if (userId == null) {
      context.showError('Cannot find user!');
      return;
    }
    if (isWorkTime) {
      if (comment.isEmpty) {
        context.showError('Please enter work time!');
        return;
      }
      final int? worktime = int.tryParse(comment);
      if (worktime == null) {
        context.showError('Please enter valid work time!');
        return;
      }
    }
    final res = await context.futureLoading(() async {
      if (isWorkTime) {
        return await dispatch<String?>(PostTimesheetWorkTimeAction(
            userId: userId,
            shiftId: shiftId,
            locationId: locationId!,
            date: model.date!,
            worktime: comment));
      }
      return await dispatch<String?>(PostTimesheetAction(
          userId: userId,
          shiftId: shiftId,
          status: status!,
          locationId: locationId!,
          comment: comment,
          time: time!,
          originalDate: isNew ? null : originalDate,
          date: model.date!));
    });
    if (res.isLeft) {
      context.showSuccess('Success!');
      context.pop("success");
    } else if (res.isRight) {
      context.showError(res.right.message);
    } else {
      context.showError('Error!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: context.width * .4,
        child: ShiftCard(
            title: isWorkTime ? "Edit Work Time" : 'Edit Punch Time',
            width: context.width * .4,
            isExpanded: true,
            isTrailingRight: false,
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: context.pop,
            ),
            items: [
              ShiftCardItem(title: "User", simpleText: fullName),
              ShiftCardItem(title: "Date", simpleText: date),
              ShiftCardItem(title: "Location/Property", simpleText: shiftName),
              if (!isWorkTime)
                ShiftCardItem(title: "Status", simpleText: status?.name ?? "-"),
              if (!isWorkTime)
                ShiftCardItem(
                  title: "Time",
                  simpleText: time?.toApiTime ?? "Select Time",
                  onSimpleTextTapped: () async {
                    final newTime = await showTimePicker(
                        context: context, initialTime: time ?? TimeOfDay.now());
                    if (newTime != null) {
                      time = newTime;
                      setState(() {});
                    }
                  },
                ),
              ShiftCardItem(
                title: isWorkTime ? "Work Time (minutes)" : "Comment",
                maxLines: isWorkTime ? 1 : 2,
                onChanged: (value) {
                  comment = value;
                },
              )
            ]),
      ),
      actions: [
        ElevatedButton(onPressed: _onSubmit, child: const Text('Submit')),
      ],
    );
  }
}
