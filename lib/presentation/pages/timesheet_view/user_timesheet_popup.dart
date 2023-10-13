import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/data/models/timesheet_md.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../global_widgets/modals/custom_month_picker.dart';

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

  List<PlutoColumn> columns = [
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
      //format: Tue,1st september
      type: PlutoColumnType.date(format: 'EEE, d MMM'),
    ),
    PlutoColumn(
      title: "Shift",
      field: 'shift',
      minWidth: 300,
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        return rendererContext.defaultText(isSelectable: false);
      },
    ),
    PlutoColumn(
      title: "Actual Time",
      field: 'actual_time',
      type: PlutoColumnType.time(),
      renderer: (rendererContext) {
        final val = rendererContext.cell.value;
        return rendererContext.defaultText(isSelectable: val != "-");
      },
    ),
    PlutoColumn(
      title: "Paid hours",
      field: 'paid_hours',
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value Hr(s)" : "",
    ),
    PlutoColumn(
      title: "Agreed Hours",
      field: 'agreed_hours',
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value Hr(s)" : "",
    ),
    PlutoColumn(
      title: "Actual Hours",
      field: 'actual_hours',
      type: PlutoColumnType.number(format: "#.##"),
      formatter: (value) => value > 0 ? "$value Hr(s)" : "",
    ),
    PlutoColumn(
      title: "Requests",
      field: 'requests',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: "Comments",
      field: 'comments',
      type: PlutoColumnType.text(),
    ),
  ];

  PlutoRow buildRow(Map<String, dynamic> model) {
    return PlutoRow(
      cells: {
        'id': PlutoCell(value: model['id']),
        'date': PlutoCell(value: model['date']),
        'shift': PlutoCell(value: model['shift']),
        'actual_time': PlutoCell(value: model['actual_time']),
        'paid_hours': PlutoCell(value: model['paid_hours']),
        'agreed_hours': PlutoCell(value: model['agreed_hours']),
        'actual_hours': PlutoCell(value: model['actual_hours']),
        'requests': PlutoCell(value: model['requests']),
        'comments': PlutoCell(value: model['comments']),
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
              userId: 805,
              // userId,
              timestamp: 1654023600,
              // DateTime(
              //     selectedDate.year,
              //     selectedDate.month +
              //         1)) //added 1, because month starts from 0
              // .millisecondsSinceEpoch ~/
              // 1000
              // )
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
        if (d['date']['date'] != null) {
          model['date'] = d['date']['date'];
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
        model['comments'] =
            "${d['startComment'] ?? ""} ${d['finishComment'] ?? ""}";
        model['actual_time'] =
            "${(DateTime.tryParse(d['actualStartTime']?['date'] ?? "")?.toApiTime) ?? ""}-${(DateTime.tryParse(d['actualFinishTime']?['date'] ?? "")?.toApiTime) ?? ""}";
        model['agreed_time'] =
            "${d['agreedStartTime'] ?? ""}-${d['agreedFinishTime'] ?? ""}";

        model['paid_hours'] = d[''] ?? 0; //todo:
        model['requests'] = "-"; //todo:

        return buildRow(model);
      }).toList();
      // set rows
      setRows(sm, rows);
    }
  }

  void _onSubmit() {}

  void _onCheckAll() {}

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
        ElevatedButton(onPressed: _onCheckAll, child: const Text("Check All")),
        ElevatedButton(onPressed: _onSubmit, child: const Text("Submit")),
      ],
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,
        child: DefaultTable(
          columns: columns,
          hasFooter: false,
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
                        .then((v) {
                      if (v != null) {
                        _selectedDate.value = v;
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
            p0.stateManager.setPageSize(40);
            stateManager = p0.stateManager;
            stateManager!.setRowGroup(
                PlutoRowGroupByColumnDelegate(showCount: true, columns: [
              // stateManager!.columns[0],
              stateManager!.columns[1],
            ]));
            await loadData(stateManager!);
          },
          rows: stateManager == null ? [] : stateManager!.rows,
        ),
      ),
    );
  }
}
