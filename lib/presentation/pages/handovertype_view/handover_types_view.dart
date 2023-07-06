import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/handover_type_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/handovertype_view/new_handover_type_popup.dart';
import 'package:mca_dashboard/presentation/pages/qualifications_view/new_qualification_popup.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class HandoverTypesView extends StatefulWidget {
  const HandoverTypesView({super.key});

  @override
  State<HandoverTypesView> createState() => _HandoverTypesViewState();
}

class _HandoverTypesViewState extends State<HandoverTypesView>
    with
        TableFocusNodeMixin<HandoverTypesView, HandoverTypeMd, HandoverTypeMd> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<HandoverTypeMd>>(
        converter: (store) => store.state.generalState.lists.handoverTypes,
        onDidChange: onDidChange,
        builder: (context, vm) {
          return DefaultTable(
            columns: columns,
            onLoaded: onLoaded,
            hasFooter: false,
            focusNode: focusNode,
            headerEnd: SpacedRow(
              horizontalSpace: 10,
              children: [
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
                  onPressed: () =>
                      onEdit((p0) => NewHandoverTypePopup(model: p0), null),
                  child: const Text("Create Handover"),
                ),
              ],
            ),
            rows: stateManager == null ? [] : stateManager!.rows,
          );
        });
  }

  @override
  PlutoRow buildRow(HandoverTypeMd model) {
    return PlutoRow(
      cells: {
        "name": PlutoCell(value: model.title),
        "status": PlutoCell(value: model.active ? "Active" : "Inactive"),
        "action": PlutoCell(value: model),
      },
    );
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Handover Name",
          field: "name",
          enableRowChecked: true,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Status",
          field: "status",
          width: 80,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          width: 60,
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onDelete: () {
                onDelete(() async {
                  return await deleteSelected(rendererContext.row);
                }, showError: false);
              },
              onEdit: () => onEdit((p0) => NewHandoverTypePopup(model: p0),
                  rendererContext.cell.value),
            );
          },
        ),
      ];

  @override
  Future<List<HandoverTypeMd>?> fetch() async {
    final res = await dispatch<ListMd>(const GetListsAction());
    if (res.isLeft) {
      return res.left.handoverTypes;
    }
    return null;
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
      final id = row.cells['action']!.value.id;
      final res = await dispatch<bool>(DeleteHandoverTypeAction(id));
      if (res.isRight) {
        delFailed.add(row.cells['name']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }
}
