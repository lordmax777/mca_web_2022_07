// ignore_for_file: empty_catches

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/checklist_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/checklists_view/users_view_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../manager/manager.dart';
import 'comments_view_popup.dart';
import 'damages_view_popup.dart';

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
            type: PlutoColumnType.date(format: 'yyyy-MM-dd')),
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
            enableFilterMenuItem: false,
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Damages",
          field: 'damages',
          width: 50,
          enableFilterMenuItem: false,
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
          enableFilterMenuItem: false,
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
          title: "Document",
          field: 'action',
          type: PlutoColumnType.text(),
          enableFilterMenuItem: false,
          renderer: (rendererContext) {
            return IconButton(
                onPressed: () {
                  downloadDocument(rendererContext.cell.value);
                },
                icon: const Icon(Icons.file_download));
          },
        ),
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

  void downloadDocument(ChecklistMd model) {
    context.futureLoading(() async {
      final ids = model.ids;

      final success = await dispatch<String>(GetChecklistPdfAction(ids: ids));
      if (success.isLeft) {
        try {
          base64Download(success.left);
        } catch (e) {
          context.showError(e.toString());
        }
      } else if (success.isRight) {
        context.showError(success.right.message);
      } else {
        context.showError("Error");
      }
    });
  }

  void onViewDamage(ChecklistMd model) {
    showGeneralDialog<bool>(
        context: context,
        barrierLabel: 'Damage',
        barrierDismissible: true,
        transitionBuilder: (ctx, a1, a2, child) {
          //build a transition that slides from left to right
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: const Offset(0, 0),
            ).animate(a1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            DamagesViewPopup(model: model));
  }

  void onViewComment(ChecklistMd model) {
    showGeneralDialog<bool>(
        context: context,
        barrierLabel: 'Comment',
        barrierDismissible: true,
        transitionBuilder: (ctx, a1, a2, child) {
          //build a transition that slides from left to right
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: const Offset(0, 0),
            ).animate(a1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            CommentsViewPopup(model: model));
  }

  void onViewUsers(ChecklistMd model) {
    showGeneralDialog<bool>(
        context: context,
        barrierLabel: 'Users',
        barrierDismissible: true,
        transitionBuilder: (ctx, a1, a2, child) {
          //build a transition that slides from left to right
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: const Offset(0, 0),
            ).animate(a1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            UsersViewPopup(model: model));
  }

  Future<PlutoLazyPaginationResponse> lazyFetch(
    PlutoLazyPaginationRequest request,
  ) async {
    bool? filterStatus;
    String? filterShift;
    String? filterDate;
    String? filterUser;

    if (request.filterRows.isNotEmpty) {
      final filter = FilterHelper.convertRowsToFilter(
        request.filterRows,
        stateManager!.refColumns,
      );
      final rowsToMap = FilterHelper.convertRowsToMap(request.filterRows);
      try {
        for (final row in rowsToMap.entries) {
          switch (row.key) {
            case "date":
              filterDate = row.value.first['Contains'];
              break;
            case "shift":
              filterShift = row.value.first['Contains'];
              break;
            case "status":
              final key = row.value.first.values.first.toLowerCase();
              if (row.value.first.values.first.length > 1) {
                break;
              }
              if (key == "d") {
                filterStatus = true;
              }
              if (key == "p") {
                filterStatus = false;
              }
              break;
            case "users":
              filterUser = row.value.first['Contains'];
              break;
          }
        }
      } catch (e) {}
    }
    final success = await dispatch<ChecklistFullMd>(GetChecklistsAction(
      page: request.page - 1,
      pageSize: stateManager!.pageSize,
      filterDate: filterDate,
      filterShift: filterShift,
      filterStatus: filterStatus,
      filterUser: filterUser,
    ));

    List<PlutoRow> tempList = [];
    if (success.isLeft) {
      tempList = success.left.checklists.map((e) => buildRow(e)).toList();
    } else {
      return PlutoLazyPaginationResponse(rows: [], totalPage: 0);
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
  Future<List<ChecklistMd>?> fetch() async {
    return appStore.state.generalState.checklists.checklists;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      columns: columns,
      rows: rows,
      onLoaded: (p0) {
        p0.stateManager.setShowColumnFilter(true);
        onLoaded(p0);
      },
      columnFilter: PlutoGridColumnFilterConfig(
        filters: [
          ...FilterHelper.defaultFilters,
          StatusColumnFilter(),
        ],
        debounceMilliseconds: 1000,
        resolveDefaultColumnFilter: (column, resolver) {
          if (column.field == "status") {
            return resolver<StatusColumnFilter>() as PlutoFilterType;
          }
          return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
        },
      ),
      // fetch: (page, pageSize) async {
      //   stateManager!.setPage(page);
      //   stateManager!.setPageSize(pageSize);
      //   stateManager!.setShowLoading(true);
      //   await lazyFetch(PlutoLazyPaginationRequest(
      //     page: stateManager!.page,
      //     sortColumn: stateManager!.getSortedColumn,
      //     filterRows: stateManager!.filterRows,
      //   ));
      //   stateManager!.setShowLoading(false);
      // },
      hasHeader: false,
      onSelected: (p0) {
        switch (p0.cell?.column.field) {
          case "damages":
            if (p0.row!.cells["damages"]!.value == 0) return;
            onViewDamage(p0.row!.cells["action"]!.value);
            break;
          case "comments":
            if (p0.row!.cells["comments"]!.value == 0) return;
            onViewComment(p0.row!.cells["action"]!.value);
            break;
          case "users":
            if (p0.row!.cells["users"]!.value == 0) return;
            onViewUsers(p0.row!.cells["action"]!.value);
            break;
        }
      },
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

  //     .fetch(
//       PlutoLazyPaginationRequest(
//         page: page,
//         sortColumn: stateManager.getSortedColumn,
//         filterRows: stateManager.filterRows,
//       ),
}
