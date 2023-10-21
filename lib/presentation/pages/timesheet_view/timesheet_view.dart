import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/data/models/timesheet_md.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/timesheet_view/dialogs/actual_time_popup.dart';
import 'package:mca_dashboard/presentation/pages/timesheet_view/user_timesheet_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TimesheetView extends StatefulWidget {
  const TimesheetView({super.key});

  @override
  State<TimesheetView> createState() => _TimesheetViewState();
}

class _TimesheetViewState extends State<TimesheetView> {
  PlutoGridStateManager? stateManager;

  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  int get timestamp =>
      DateTime.utc(selectedDate.value.year, selectedDate.value.month)
          .millisecondsSinceEpoch ~/
      1000;

  List<PlutoColumn> columns = [
    PlutoColumn(
      title: "",
      field: 'userId',
      type: PlutoColumnType.text(),
      width: 0,
      minWidth: 0,
    ),
    PlutoColumn(
      title: "Staff Name",
      field: 'staff_name',
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        return rendererContext.defaultText(isSelectable: true);
      },
    ),
    PlutoColumn(
      enableFilterMenuItem: false,
      title: "Scheduled Hours",
      field: 'schedule_hours',
      type: PlutoColumnType.number(format: "#.##"),
    ),
    PlutoColumn(
      enableFilterMenuItem: false,
      title: "Actual Hours",
      field: 'actual_hours',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      enableFilterMenuItem: false,
      title: "Overtime",
      field: 'overtime',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      enableFilterMenuItem: false,
      title: "Days off",
      field: 'days_off',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      enableFilterMenuItem: false,
      title: "Lates",
      field: 'lates',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      enableFilterMenuItem: false,
      title: "Cleans",
      field: 'cleans',
      type: PlutoColumnType.number(),
    ),
  ];

  PlutoRow buildRow(Map<String, dynamic> model) {
    return PlutoRow(
      cells: {
        "userId": PlutoCell(value: model['userId']),
        "staff_name": PlutoCell(value: model['fullname']),
        "schedule_hours": PlutoCell(value: model['schedule_hours']),
        "actual_hours": PlutoCell(value: model['actual_hours']),
        "overtime": PlutoCell(value: model['overtime']),
        "days_off": PlutoCell(value: model['days_off']),
        "lates": PlutoCell(value: model['lates']),
        "cleans": PlutoCell(value: model['cleans']),
      },
    );
  }

  void onDidChange(TimesheetMd? prev, TimesheetMd current) {
    final oldItems = prev;
    final newItems = current;
    if (oldItems != newItems) {
      //update timesheet
      // setRows(stateManager!, newItems.map((e) => buildRow(e)).toList());
    }
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
    stateManager!.setShowLoading(true, level: PlutoGridLoadingLevel.grid);
    final res =
        await dispatch<TimesheetMd>(GetTimesheetAction(timestamp: timestamp));

    stateManager!.setShowLoading(false);
    if (res.isLeft) {
      //success
      final timesheet = res.left;
      final data = timesheet.data;
      final dates = timesheet.dates;
      //get all dates keys
      final dateKeys = dates.keys.toList();
      //get all values from data
      final dataValues = data.values.toList();
      //data of each dataValues is single user data
      final rows = dataValues.map((e) {
        final model = <String, dynamic>{};
        final fullname = e['fullname'];
        num scheduleHours = 0;
        num actualHours = 0;
        num overtime = 0;
        num daysOff = 0;
        num lates = 0;
        num cleans = 0;
        model['fullname'] = fullname;
        //loop through each date
        for (var date in dateKeys) {
          for (var d in e['data']?[date] ?? []) {
            final shiftId = d['shiftId'];
            scheduleHours += (d['originalAgreedHours'] ?? 0);
            actualHours += (d['actualWorkingHours'] ?? 0);
            overtime += (d['overtime'] ?? 0);
            if ((d['dayoff'] ?? 0) != 0) {
              daysOff += 1;
            }
            lates += (d['lateTotal'] ?? 0);
            cleans +=
                (shiftId != null ? 1 : 0); //if shift id is not null, calculate
          }
        }
        model['schedule_hours'] = scheduleHours > 0 ? scheduleHours / 60 : 0;
        model['actual_hours'] = actualHours > 0 ? actualHours / 60 : 0;
        model['overtime'] = overtime > 0 ? overtime / 60 : 0;
        model['days_off'] = daysOff;
        model['lates'] = lates;
        model['cleans'] = cleans;
        model['userId'] = e['userId'];

        return buildRow(model);
      }).toList();
      //set rows
      setRows(sm, rows);
      final filterrows = sm.filterRows;
      if (sm.hasFilter) {
        stateManager!.setFilterWithFilterRows(filterrows);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      columns: columns,
      headerStart: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder(
            valueListenable: selectedDate,
            builder: (context, value, child) => DefaultTextField(
              enabled: false,
              onTap: () {
                showCustomMonthPicker(context, initialTime: value).then((v) {
                  if (v != null) {
                    selectedDate.value = v;
                    loadData(stateManager!);
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
                label: const Text("Summary"),
                icon: const Icon(Icons.list),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      columnFilter: PlutoGridColumnFilterConfig(filters: [
        ...FilterHelper.defaultFilters,
      ]),
      onLoaded: (p0) async {
        p0.stateManager.setShowColumnFilter(true);
        p0.stateManager.sortAscending(columns[1]);
        stateManager = p0.stateManager;
        await loadData(stateManager!);
      },
      rows: stateManager == null ? [] : stateManager!.rows,
      onSelected: (p0) {
        // context.showDialog(ActualTimePopup(model: {}));
        // return;
        final col = p0.cell?.column.field;
        switch (col) {
          case 'staff_name':
            final String? userId = p0.cell?.row.cells['userId']?.value;
            //navigate to staff detail
            if (userId != null) {
              context.showDialog(UserTimesheetPopup(
                userId: int.parse(userId),
                initialTime: selectedDate.value,
              ));
            } else {
              context.showError('Cannot find user');
            }
            break;
        }
      },
    );
  }
}
