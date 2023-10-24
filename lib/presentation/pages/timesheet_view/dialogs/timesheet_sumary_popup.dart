import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/data/models/timesheet_md.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/timesheet_view/dialogs/actual_time_popup.dart';
import 'package:mca_dashboard/presentation/pages/timesheet_view/dialogs/user_timesheet_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TimesheetSummaryPopup extends StatefulWidget {
  const TimesheetSummaryPopup({super.key});

  @override
  State<TimesheetSummaryPopup> createState() => _TimesheetSummaryPopupState();
}

class _TimesheetSummaryPopupState extends State<TimesheetSummaryPopup> {
  PlutoGridStateManager? stateManager;

  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  int get timestamp =>
      DateTime.utc(selectedDate.value.year, selectedDate.value.month)
          .millisecondsSinceEpoch ~/
      1000;

  PlutoColumn getColumn({required String name}) {
    return PlutoColumn(
        enableFilterMenuItem: false,
        title: name,
        field: name,
        width: 150,
        minWidth: 150,
        enableColumnDrag: false,
        enableContextMenu: false,
        enableDropToResize: false,
        type: PlutoColumnType.number(format: "#.##"));
  }

  PlutoColumn userCol() {
    return PlutoColumn(
      title: "Name",
      field: 'UserId',
      width: 150,
      minWidth: 150,
      enableColumnDrag: false,
      enableContextMenu: false,
      enableDropToResize: false,
      type: PlutoColumnType.text(),
    );
  }

  List<PlutoColumn> columns = [];

  PlutoRow buildRow(Map<String, dynamic> model) {
    return PlutoRow(
      cells: {
        "UserId": PlutoCell(value: model['UserId']),
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
    stateManager!.setShowLoading(true, level: PlutoGridLoadingLevel.grid);
    final res = await dispatch<TimesheetMd>(GetTimesheetAction(
        timestamp:
            // 1648771200,
            timestamp));

    stateManager!.setShowLoading(false);
    if (res.isLeft) {
      //success
      final timesheet = res.left;
      final dates = timesheet.dates;
      //get all dates keys
      final dateKeys = dates.keys.toList();

      //add columns
      sm.removeColumns(sm.columns);
      sm.insertColumns(0, [userCol()]);
      var newCols = dateKeys
          .map((e) =>
              getColumn(name: DateFormat("EEE d").format(DateTime.parse(e))))
          .toList();
      for (int i = 0; i < newCols.length; i++) {
        sm.insertColumns(i + 1, [newCols[i]]);
      }

      //summary
      final summary = timesheet.summary;
      //get all values from data
      final rows = summary.map((e) {
        final model = <String, dynamic>{};
        final userMd = appStore.state.generalState.users
            .firstWhereOrNull((element) => element.id == e['UserId']);
        model['UserId'] = userMd?.fullname ?? e['UserId'];
        for (var date in dateKeys) {
          model[date] = e[date]?['times']?['WorkTime'];
        }
        return PlutoRow(cells: {
          "UserId": PlutoCell(value: model['UserId']),
          for (var date in dateKeys)
            DateFormat("EEE d").format(DateTime.parse(date)):
                PlutoCell(value: model[date] != null ? model[date] / 60 : 0)
        });
      }).toList();
      //set rows
      setRows(sm, rows);
      // final filterrows = sm.filterRows;
      // if (sm.hasFilter) {
      //   stateManager!.setFilterWithFilterRows(filterrows);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: "Timesheet Summary",
      builder: (context) => DefaultTable(
        columns: columns,
        headerStart: ValueListenableBuilder(
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
        columnFilter: const PlutoGridColumnFilterConfig(filters: [
          ...FilterHelper.defaultFilters,
        ]),
        onLoaded: (p0) async {
          p0.stateManager.setShowColumnFilter(true);
          // p0.stateManager.sortAscending(columns[1]);
          stateManager = p0.stateManager;
          loadData(stateManager!);
        },
        rows: stateManager == null ? [] : stateManager!.rows,
      ),
    );
  }
}

class CustomFilter extends PlutoFilterType {}
