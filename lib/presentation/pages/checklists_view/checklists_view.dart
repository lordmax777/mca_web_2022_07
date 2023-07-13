import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/checklist_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/global_functions.dart';
import 'package:mca_dashboard/utils/table_helpers.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../manager/manager.dart';

class ChecklistsView extends StatefulWidget {
  const ChecklistsView({super.key});

  @override
  State<ChecklistsView> createState() => _ChecklistsViewState();
}

class _ChecklistsViewState extends State<ChecklistsView>
    with TableFocusNodeMixin<ChecklistsView, ChecklistMd, ChecklistMd> {
  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            title: "Date",
            field: 'date',
            width: 80,
            type: PlutoColumnType.date(format: 'dd/MM/yyyy')),
        PlutoColumn(
            title: "Shift", field: 'shift', type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Users",
          field: 'users',
          width: 50,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            if (rendererContext.cell.value == 0) return const SizedBox();
            return rendererContext.defaultText(
                isSelectable: true,
                title: "View (${rendererContext.cell.value})");
          },
        ),
        PlutoColumn(
            title: "Time",
            field: 'time',
            width: 80,
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Damages",
          field: 'damages',
          width: 50,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            if (rendererContext.cell.value == 0) return const SizedBox();
            return rendererContext.defaultText(
                isSelectable: true,
                title: "View (${rendererContext.cell.value})");
          },
        ),
        PlutoColumn(
          title: "Comments",
          field: 'comments',
          width: 50,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            if (rendererContext.cell.value == 0) return const SizedBox();
            return rendererContext.defaultText(
                isSelectable: true,
                title: "View (${rendererContext.cell.value})");
          },
        ),
        PlutoColumn(
            width: 80,
            title: "Status",
            field: 'status',
            type: PlutoColumnType.text()),
        PlutoColumn(
            width: 50,
            title: "Action",
            field: 'action',
            type: PlutoColumnType.text()),
      ];

  @override
  PlutoRow buildRow(ChecklistMd model) {
    return PlutoRow(cells: {
      'date': PlutoCell(value: model.date),
      'shift': PlutoCell(value: model.fullTitle),
      'users': PlutoCell(value: model.users.length),
      'time': PlutoCell(value: model.fromToTime),
      'damages': PlutoCell(value: model.damages.length),
      'comments': PlutoCell(value: model.comments.length),
      'status': PlutoCell(value: model.done ? "Done" : "In Progress"),
      'action': PlutoCell(value: model),
    });
  }

  Future<PlutoLazyPaginationResponse> lazyFetch(
    PlutoLazyPaginationRequest request,
  ) async {
    final success = await dispatch<ChecklistFullMd>(
        GetChecklistsAction(page: request.page - 1));

    List<PlutoRow> tempList = [];
    if (success.isLeft) {
      tempList = success.left.checklists.map((e) => buildRow(e)).toList();
    } else {
      return PlutoLazyPaginationResponse(rows: [], totalPage: 0); //todo:
    }

    if (request.filterRows.isNotEmpty) {
      final filter = FilterHelper.convertRowsToFilter(
        request.filterRows,
        stateManager!.refColumns,
      );

      tempList = tempList.where(filter!).toList();
    }

    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      tempList = [...tempList];

      tempList.sort((a, b) {
        final sortA = request.sortColumn!.sort.isAscending ? a : b;
        final sortB = request.sortColumn!.sort.isAscending ? b : a;

        return request.sortColumn!.type.compare(
          sortA.cells[request.sortColumn!.field]!.valueForSorting,
          sortB.cells[request.sortColumn!.field]!.valueForSorting,
        );
      });
    }

    final totalPage = success.left.maxPages;

    return Future.value(PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: tempList.toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      columns: columns,
      rows: rows,
      onLoaded: onLoaded,
      focusNode: focusNode,
      customFooter: (p0) {
        return PlutoLazyPagination(
          stateManager: p0,
          fetch: lazyFetch,
          initialPage: 1,
          initialFetch: true,
          fetchWithFiltering: true,
          fetchWithSorting: true,
        );
      },
    );
  }
}
