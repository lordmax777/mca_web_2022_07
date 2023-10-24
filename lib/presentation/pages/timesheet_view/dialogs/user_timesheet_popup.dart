import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/data/models/timesheet_md.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/timesheet_view/dialogs/actual_time_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../global_widgets/modals/custom_month_picker.dart';
import 'breaks_popup.dart';

class UserTimesheetPopup extends StatefulWidget {
  final int userId;
  final DateTime? initialTime;
  const UserTimesheetPopup({super.key, required this.userId, this.initialTime});

  @override
  State<UserTimesheetPopup> createState() => _UserTimesheetPopupState();
}

class _UserTimesheetPopupState extends State<UserTimesheetPopup> {
  int get userId => widget.userId;
  PlutoGridStateManager? stateManager;
  TimesheetMd? timesheetData;
  late final ValueNotifier<DateTime> _selectedDate =
      ValueNotifier(widget.initialTime ?? DateTime.now());
  DateTime get selectedDate => _selectedDate.value;

  int get timestamp =>
      DateTime.utc(selectedDate.year, selectedDate.month)
          .millisecondsSinceEpoch ~/
      1000;

  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(
        title: "Agreed time", fields: ['agreed_start', 'agreed_end']),
    PlutoColumnGroup(
        title: "Actual time", fields: ['actual_start', 'actual_end']),
    PlutoColumnGroup(
        title: "Comment", fields: ['comment_start', 'comment_end']),
    PlutoColumnGroup(title: "Lunch time", fields: ['lunch_start', 'lunch_end']),
    // PlutoColumnGroup(title: "Breaks", fields: ['start_break', 'end_break']),
  ];

  final List<PlutoColumn> columns = [
    PlutoColumn(
      title: "",
      field: 'id',
      type: PlutoColumnType.text(),
      width: 0,
      minWidth: 0,
    ),
    PlutoColumn(
      title: "Date",
      field: 'date',
      frozen: PlutoColumnFrozen.start,
      enableRowChecked: true,
      width: 150,
      //format: Tue,1st September
      type: PlutoColumnType.date(format: 'EEE, d MMM'),
      renderer: (rendererContext) {
        return rendererContext.defaultText();
      },
    ),
    PlutoColumn(
      title: "Shift",
      field: 'shift',
      frozen: PlutoColumnFrozen.start,
      width: 300,
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "Start",
      field: "agreed_start",
      width: 120,
      enableEditingMode: true,
      type: PlutoColumnType.time(),
    ),
    PlutoColumn(
      title: "End",
      field: "agreed_end",
      width: 120,
      type: PlutoColumnType.time(),
    ),
    PlutoColumn(
      title: "Start",
      field: "actual_start",
      width: 120,
      type: PlutoColumnType.time(),
      renderer: (rendererContext) {
        return rendererContext.defaultText(
            isSelectable: rendererContext.cell.value != null);
      },
    ),
    PlutoColumn(
      title: "End",
      field: "actual_end",
      width: 120,
      type: PlutoColumnType.time(),
      renderer: (rendererContext) {
        return rendererContext.defaultText(
            isSelectable: rendererContext.cell.value != null);
      },
    ),
    PlutoColumn(
      title: "Start",
      field: "lunch_start",
      width: 120,
      type: PlutoColumnType.time(),
      renderer: (rendererContext) {
        return rendererContext.defaultText(
            isSelectable: rendererContext.cell.value != null);
      },
    ),
    PlutoColumn(
      title: "End",
      field: "lunch_end",
      width: 120,
      type: PlutoColumnType.time(),
      renderer: (rendererContext) {
        return rendererContext.defaultText(
            isSelectable: rendererContext.cell.value != null);
      },
    ),
    // PlutoColumn(
    //   title: "Start",
    //   field: 'start_break',
    //   width: 120,
    //   type: PlutoColumnType.time(),
    //   renderer: (rendererContext) {
    //     return rendererContext.defaultText(
    //         isSelectable: rendererContext.cell.value != null);
    //   },
    // ),
    // PlutoColumn(
    //   title: "End",
    //   field: 'end_break',
    //   width: 120,
    //   type: PlutoColumnType.time(),
    //   renderer: (rendererContext) {
    //     return rendererContext.defaultText(
    //         isSelectable: rendererContext.cell.value != null);
    //   },
    // ),
    PlutoColumn(
        title: "Breaks",
        field: 'breaks',
        width: 120,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          final value = rendererContext.cell.value.length;
          return rendererContext.defaultText(
              isSelectable: value > 0, title: value > 0 ? "View $value" : "");
        }),
    PlutoColumn(
      title: "Late",
      field: 'late',
      // width: 120,
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value min(s)" : "",
    ),
    PlutoColumn(
      title: "Leave early",
      field: 'leave_early',
      // width: 120,
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value min(s)" : "",
    ),
    PlutoColumn(
      title: "Overtime",
      field: 'overtime',
      // width: 120,
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value min(s)" : "",
    ),
    PlutoColumn(
      title: "Break deduction",
      field: 'break_deduction',
      // width: 120,
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value min(s)" : "",
    ),
    PlutoColumn(
      title: "Total break time",
      field: 'total_break_time',
      // width: 120,
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value min(s)" : "",
    ),
    PlutoColumn(
      title: "Paid hours",
      field: 'paid_hours',
      // width: 120,
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value Hr(s)" : "",
    ),
    PlutoColumn(
      title: "Agreed Hours",
      field: 'agreed_hours',
      // width: 120,
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value Hr(s)" : "",
    ),
    PlutoColumn(
        title: "Actual Hours",
        field: 'actual_hours',
        // width: 120,
        type: PlutoColumnType.number(format: "#.##"),
        formatter: (value) => value > 0 ? "$value Hr(s)" : "",
        renderer: (rendererContext) {
          final value = rendererContext.cell.value ?? 0;
          return rendererContext.defaultText(
              isSelectable: value > 0, title: value > 0 ? "$value Hr(s)" : "");
        }),
    PlutoColumn(
      title: "Requests",
      field: 'requests',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "Start",
      field: 'comment_start',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "End",
      field: 'comment_end',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "model",
      field: 'model',
      type: PlutoColumnType.text(),
      width: 0,
      minWidth: 0,
    ),
  ];

  PlutoRow buildRow(Map<String, dynamic> model) {
    return PlutoRow(
      cells: {
        'id': PlutoCell(value: model['id']),
        'date': PlutoCell(value: model['date']),
        'shift': PlutoCell(value: model['shift']),
        'agreed_start': PlutoCell(value: model['agreed_start']),
        'agreed_end': PlutoCell(value: model['agreed_end']),
        'actual_start': PlutoCell(value: model['actual_start']),
        'actual_end': PlutoCell(value: model['actual_end']),
        'paid_hours': PlutoCell(value: model['paid_hours']),
        'agreed_hours': PlutoCell(value: model['agreed_hours']),
        'actual_hours': PlutoCell(value: model['actual_hours']),
        'late': PlutoCell(value: model['late']),
        'leave_early': PlutoCell(value: model['leave_early']),
        'requests': PlutoCell(value: model['requests']),
        'comment_start': PlutoCell(value: model['comment_start']),
        'comment_end': PlutoCell(value: model['comment_end']),
        'lunch_start': PlutoCell(value: model['lunch_start']),
        'lunch_end': PlutoCell(value: model['lunch_end']),
        'overtime': PlutoCell(value: model['overtime']),
        // 'start_break': PlutoCell(value: model['start_break']),
        // 'end_break': PlutoCell(value: model['end_break']),
        'breaks': PlutoCell(value: model['breaks']),
        'break_deduction': PlutoCell(value: model['break_deduction']),
        'total_break_time': PlutoCell(value: model['total_break_time']),
        'model': PlutoCell(value: model['model']),
      },
    );
  }

  PlutoGridStateManager setRows(PlutoGridStateManager sm, List<PlutoRow> rs) {
    sm.removeAllRows();
    sm.appendRows(rs);
    final sortedColumn = sm.getSortedColumn;
    if (sortedColumn != null) {
      if (sortedColumn.sort.isAscending) {
        sm.sortAscending(sortedColumn);
      } else if (sortedColumn.sort.isDescending) {
        sm.sortDescending(sortedColumn);
      }
    }
    return sm;
  }

  Future<void> loadData(PlutoGridStateManager sm) async {
    final res = await context
        .futureLoading(() async => dispatch<TimesheetMd>(GetTimesheetAction(
            userId:
                // 805,
                userId,
            timestamp:
                // 1654023600,
                timestamp
            // added 1, because month starts from 0
            )));

    if (res.isLeft) {
      setState(() {
        timesheetData = res.left;
      });
      //success
      final timesheet = res.left;
      final data = timesheet.data;
      final dates = timesheet.dates;
      //get all values from data
      final List dataValues =
          (data.values.toList().first['data'].values.toList() as List)
              .expand((element) => element)
              .toList();

      //each dataValues.values.toList() is a List of Map

      //data of each dataValues is single user data
      final List<PlutoRow> rows = dataValues.map<PlutoRow>((d) {
        final model = <String, dynamic>{};

        //loop through each date
        if (d['date'] != null) {
          model['date'] = d['date'];
        }
        model['shift'] = d['shiftName'];
        model['id'] = d['id'];

        if (d['originalAgreedHours'] != null) {
          model['schedule_hours'] = d['originalAgreedHours'];
        }
        if (d['totalAgreedHours'] != null) {
          model['agreed_hours'] = d['totalAgreedHours'] / 60;
        }
        if (d['actualWorkingHours'] != null) {
          model['actual_hours'] = d['actualWorkingHours'] / 60;
        }

        final late = d['late'] ?? 0;
        final leaveEarly = d['leaveEarly'] ?? 0;
        model['late'] = late;
        model['leave_early'] = leaveEarly;

        final overtime = d['overtime'];
        if (overtime != null) {
          model['overtime'] = overtime;
        }

        final breakDeduction = d['breakDeduction'];
        if (breakDeduction != null) {
          model['break_deduction'] = breakDeduction;
        }
        final totalBreakTime = d['totalBreakTime'];
        if (totalBreakTime != null) {
          model['total_break_time'] = totalBreakTime;
        }

        final startComment = d['startComment'] ?? "";
        final finishComment = d['finishComment'] ?? "";
        model['comment_start'] = startComment;
        model['comment_end'] = finishComment;

        final String? actualStartDt = d['actualStartTime'];
        model['actual_start'] = actualStartDt?.toTimeOfDay?.toApiTime ?? "";

        final String? actualFinishDt = d['actualFinishTime'];
        model['actual_end'] = actualFinishDt?.toTimeOfDay?.toApiTime ?? "";

        final String? agreedStartDt = d['agreedStartTime'];
        model['agreed_start'] = agreedStartDt?.toTimeOfDay?.toApiTime ?? "";

        final String? agreedFinishDt = d['agreedFinishTime'];
        model['agreed_end'] = agreedFinishDt?.toTimeOfDay?.toApiTime ?? "";

        final String? lunchStartDt = d['lunchStartTime'];
        model['lunch_start'] = lunchStartDt?.toTimeOfDay?.toApiTime ?? "";

        final String? lunchFinishDt = d['lunchFinishTime'];
        model['lunch_end'] = lunchFinishDt?.toTimeOfDay?.toApiTime ?? "";

        // final breakStart =
        //     DateTime.tryParse(d['breaks']?.first?['start'] ?? "");
        // final breakEnd = DateTime.tryParse(d['breaks']?.first?['finish'] ?? "");
        // if (breakStart != null) {
        //   model['start_break'] = breakStart.toApiTime;
        // }
        // if (breakEnd != null) {
        //   model['end_break'] = breakEnd.toApiTime;
        // }
        final List breaks = d['breaks'] ?? [];
        model['breaks'] = breaks;
        model['model'] = d;

        model['paid_hours'] = d[''] ?? 0; //todo:
        model['requests'] = ""; //todo:

        return buildRow(model);
      }).toList();
      // set rows
      setRows(sm, rows);
    }
  }

  void _onSubmit() {}

  void _onCheckAll() {
    stateManager?.toggleAllRowChecked(!isAllChecked);
  }

  void _downloadPdf() async {
    final success = await context.futureLoading(() async => dispatch<String>(
        GetTimesheetPdfAction(userId: userId, timestamp: timestamp)));
    if (success.isLeft) {
      try {
        base64Download(success.left, "timesheet");
      } catch (e) {
        context.showError(e.toString());
      }
    } else if (success.isRight) {
      context.showError(success.right.message);
    } else {
      context.showError("Error");
    }
  }

  bool get isAllChecked =>
      stateManager?.checkedRows.length == stateManager?.rows.length;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          IconButton(onPressed: context.pop, icon: Icon(Icons.arrow_back)),
          const SizedBox(width: 8),
          if (timesheetData != null)
            Text(timesheetData!.data.values.first['fullname'] ?? ""),
        ],
      ),
      actions: [
        // ElevatedButton(onPressed: _onCheckAll, child: const Text("Check All")),
        ElevatedButton(
            onPressed: _onSubmit, child: const Text("Check selected")),
      ],
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,
        child: DefaultTable(
          columns: columns,
          hasFooter: false,
          autoSizeMode: PlutoAutoSizeMode.none,
          headerStart: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder(
                valueListenable: _selectedDate,
                builder: (context, value, child) => DefaultTextField(
                  enabled: false,
                  onTap: () {
                    showCustomMonthPicker(context, initialTime: value)
                        .then((v) async {
                      if (v != null) {
                        _selectedDate.value = v;
                        await loadData(stateManager!);
                      }
                    });
                  },
                  controller: TextEditingController(
                      text: DateFormat('MMMM yyyy').format(value)),
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        minimumSize: const Size(167, 56),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16))),
                    label: const Text("Download PDF"),
                    icon: const Icon(Icons.download),
                    onPressed: _downloadPdf,
                  ),
                ],
              ),
            ],
          ),
          columnsGroups: columnGroups,
          onLoaded: (p0) async {
            p0.stateManager.setPageSize(200);
            stateManager = p0.stateManager;
            await loadData(stateManager!);
          },
          onSelected: (p0) async {
            final field = p0.cell?.column.field;
            final value = p0.cell?.value;
            final model = p0.row?.cells['model']?.value;
            if (value == null && model != null) return;
            final m = TsData.fromJson(model);
            switch (field) {
              case "actual_hours":
                // if (m.actualStartTime == null && m.actualFinishTime == null) {
                //   return;
                // }
                if (value == 0) {
                  return;
                }
                final success = await context
                    .showDialog(ActualTimePopup(model: m, type: field!));
                if (success == "success") {
                  loadData(stateManager!);
                } else if (success == "start_loc_not_found") {
                  context.showError("Start location not found");
                }
                break;
              case "actual_start":
              case "actual_end":
              case "lunch_start":
              case "lunch_end":
                if (m.actualFinishLocationId == null &&
                    m.actualStartLocationId == null &&
                    m.agreedFinishLocationId == null &&
                    m.agreedStartLocationId == null) {
                  return;
                }
                final success = await context
                    .showDialog(ActualTimePopup(model: m, type: field!));
                if (success == "success") {
                  loadData(stateManager!);
                } else if (success == "start_loc_not_found") {
                  context.showError("Start location not found");
                }
                break;
              case "breaks":
                if (value == null || value == 0) return;
                context.showDialog(BreaksPopup(model: m));
                break;
            }
          },
          rows: stateManager == null ? [] : stateManager!.rows,
        ),
      ),
    );
  }
}
