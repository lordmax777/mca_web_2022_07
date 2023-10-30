import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/settings_view/modals/create_new_unav_to_work_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AvailabilityTab extends StatefulWidget {
  const AvailabilityTab({Key? key}) : super(key: key);

  @override
  State<AvailabilityTab> createState() => _AvailabilityTabState();
}

class _AvailabilityTabState extends State<AvailabilityTab>
    with
        TableFocusNodeMixin<AvailabilityTab, AccountAvailabilityMd,
            AccountAvailabilityMd> {
  @override
  Future<List<AccountAvailabilityMd>?> fetch() async {
    final res = await dispatch<List<AccountAvailabilityMd>>(
        const GetAccountUserAvailabilityAction());
    // return mockedUserAccountAvailabilityList;

    if (res.isLeft) {
      return res.left;
    } else if (res.isRight) {
      context.showError(res.right.message);
    } else {
      context.showError("Something went wrong");
    }
    return null;
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            title: "Start Date",
            field: "startDate",
            enableRowChecked: true,
            width: 90,
            type: PlutoColumnType.date(format: "dd/MM/yyyy")),
        PlutoColumn(
            title: "End Date",
            field: "endDate",
            width: 80,
            type: PlutoColumnType.date(format: "dd/MM/yyyy")),
        PlutoColumn(
            title: "Start Time",
            field: "startTime",
            width: 60,
            type: PlutoColumnType.time()),
        PlutoColumn(
            title: "End Time",
            field: "endTime",
            width: 60,
            type: PlutoColumnType.time()),
        PlutoColumn(
            title: "Comment",
            width: 80,
            field: "comment",
            type: PlutoColumnType.text(),
            renderer: (rendererContext) {
              return rendererContext.defaultTooltipWidget();
            }),
        PlutoColumn(
          width: 40,
          title: "Action",
          field: 'action',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return IconButton(
                onPressed: () {
                  onDelete(() async {
                    return await deleteSelected(rendererContext.row);
                  }, showError: false);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ));
          },
        ),
      ];

  @override
  PlutoRow buildRow(AccountAvailabilityMd model) {
    return PlutoRow(cells: {
      'startDate': PlutoCell(value: model.startDate),
      'endDate': PlutoCell(value: model.endDate),
      'startTime': PlutoCell(value: model.startTime ?? "-"),
      'endTime': PlutoCell(value: model.endTime ?? "-"),
      'comment': PlutoCell(value: model.comment),
      'action': PlutoCell(value: model),
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      headerEnd: SpacedRow(
        horizontalSpace: 10,
        children: [
          //delete selected button
          ElevatedButton(
            onPressed: () {
              onDelete(() async {
                return await deleteSelected(null);
              }, showError: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Delete Selected"),
          ),
          ElevatedButton(
            onPressed: () {
              onEdit((p0) => const CreateNewUnavToWorkPopup(), null);
            },
            child: const Text("Create New"),
          ),
        ],
      ),
      onLoaded: onLoaded,
      columns: columns,
      rows: stateManager == null ? [] : stateManager!.rows,
      focusNode: focusNode,
    );
  }

  Future<bool> deleteSelected(PlutoRow? singleRow) async {
    final selected = [...stateManager!.checkedRows];
    if (singleRow != null) {
      selected.clear();
      selected.add(singleRow);
    }
    if (selected.isEmpty) {
      return false;
    }
    final List<String> delFailed = [];
    for (final row in selected) {
      final date = DateTime.parse(row.cells['action']!.value.startDate);
      final res =
          await dispatch<bool>(DeleteAccountUserAvailabilityAction(date));
      if (res.isRight) {
        delFailed.add(
            "${row.cells['startDate']!.value} - ${row.cells['endDate']!.value}: ${res.right.message}");
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete\n${delFailed.join("\n")}");
    }
    return delFailed.isEmpty;
  }
}
