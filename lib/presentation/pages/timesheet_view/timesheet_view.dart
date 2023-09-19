import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/data/models/timesheet_md.dart';
import 'package:mca_dashboard/manager/data/models/timesheet_md.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/get_timesheet_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TimesheetView extends StatefulWidget {
  const TimesheetView({super.key});

  @override
  State<TimesheetView> createState() => _TimesheetViewState();
}

class _TimesheetViewState extends State<TimesheetView> {
  PlutoGridStateManager? stateManager;

  ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  List<PlutoColumn> columns = [
    PlutoColumn(
      title: "id",
      field: 'id',
      type: PlutoColumnType.text(),
      hide: true,
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
      title: "Scheduled Hours",
      field: 'schedule_hours',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Actual Hours",
      field: 'actual_hours',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Overtime",
      field: 'overtime',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Days off",
      field: 'days_off',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Lates",
      field: 'lates',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: "Cleans",
      field: 'cleans',
      type: PlutoColumnType.number(),
    ),
  ];

  PlutoRow buildRow(Map<String, dynamic> model) {
    return PlutoRow(
      cells: {
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
    final res = await dispatch<TimesheetMd>(GetTimesheetAction(
        timestamp: (DateTime(
                    selectedDate.value.year,
                    selectedDate.value.month +
                        1)) //added 1, because month starts from 0
                .millisecondsSinceEpoch ~/
            1000));

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
          for (var d in e['data'][date]) {
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
        model['schedule_hours'] = scheduleHours;
        model['actual_hours'] = actualHours;
        model['overtime'] = overtime;
        model['days_off'] = daysOff;
        model['lates'] = lates;
        model['cleans'] = cleans;

        return buildRow(model);
      }).toList();
      //set rows
      setRows(sm, rows);
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
      onLoaded: (p0) async {
        stateManager = p0.stateManager;
        await loadData(stateManager!);
      },
      rows: stateManager == null ? [] : stateManager!.rows,
    );
  }
}
