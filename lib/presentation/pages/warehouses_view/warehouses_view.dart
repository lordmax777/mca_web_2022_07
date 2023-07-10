import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/qualification_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/warehouse_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/qualifications_view/new_qualification_popup.dart';
import 'package:mca_dashboard/presentation/pages/warehouses_view/dialogs/new_warehouse_popup.dart';
import 'package:mca_dashboard/presentation/pages/warehouses_view/dialogs/warehouse_properties_popup.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'dialogs/warehouse_inventory_popup.dart';

class WarehousesView extends StatefulWidget {
  const WarehousesView({super.key});

  @override
  State<WarehousesView> createState() => _WarehousesViewState();
}

class _WarehousesViewState extends State<WarehousesView>
    with TableFocusNodeMixin<WarehousesView, WarehouseMd, WarehouseMd> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<WarehouseMd>>(
        converter: (store) => store.state.generalState.warehouses,
        onDidChange: onDidChange,
        builder: (context, vm) {
          return DefaultTable(
            columns: columns,
            onLoaded: onLoaded,
            focusNode: focusNode,
            onSelected: (p0) {
              if (stateManager!.hasFocus) {
                stateManager?.gridFocusNode.removeListener(handleFocus);
              }
              switch (p0.cell?.column.field) {
                case "linkedProperties":
                  final warehouse = p0.row!.cells["action"]!.value;
                  if (warehouse is WarehouseMd) {
                    context.showDialog(
                        WarehousePropertiesPopup(warehouse: warehouse));
                  }
                  break;
              }
              logger(p0.cell?.value);
            },
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
                      onEdit((p0) => NewWarehousePopup(model: p0), null),
                  child: const Text("Create Warehouse"),
                ),
              ],
            ),
            rows: stateManager == null ? [] : stateManager!.rows,
          );
        });
  }

  @override
  PlutoRow buildRow(WarehouseMd model) {
    return PlutoRow(
      cells: {
        "name": PlutoCell(value: model.name),
        "contactName": PlutoCell(value: model.contactName),
        "contactEmail": PlutoCell(value: model.contactEmail),
        "linkedProperties": PlutoCell(value: model.properties.length),
        "action": PlutoCell(value: model),
      },
    );
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Warehouse Name",
          field: "name",
          enableRowChecked: true,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Contact Name",
          field: "contactName",
          width: 120,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Contact Email",
          field: "contactEmail",
          width: 120,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Linked Properties",
          field: "linkedProperties",
          width: 80,
          type: PlutoColumnType.number(format: "#,###"),
          renderer: (rendererContext) {
            return rendererContext.defaultText(isSelectable: true);
          },
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          width: 60,
          renderer: (rendererContext) {
            return PopupMenuButton(
              offset: const Offset(0, 40),
              padding: const EdgeInsets.all(0),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: SpacedRow(
                    horizontalSpace: 10,
                    children: const [
                      Icon(Icons.edit),
                      Text("Edit"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: SpacedRow(
                    horizontalSpace: 10,
                    children: const [
                      Icon(Icons.delete),
                      Text("Delete"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: SpacedRow(
                    horizontalSpace: 10,
                    children: const [
                      Icon(Icons.inventory),
                      Text("Check Inventory"),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (stateManager!.hasFocus) {
                  stateManager?.gridFocusNode.removeListener(handleFocus);
                }
                switch (value) {
                  case 1:
                    onEdit((p0) => NewWarehousePopup(model: p0),
                        rendererContext.cell.value);
                    break;
                  case 2:
                    onDelete(() async {
                      return await deleteSelected(rendererContext.row);
                    }, showError: false);
                    break;
                  case 3:
                    onCheckInventory(rendererContext.cell.value);
                }
              },
            );
          },
        ),
      ];

  @override
  Future<List<WarehouseMd>?> fetch() async {
    final res = await dispatch<List<WarehouseMd>>(const GetWarehousesAction());
    if (res.isLeft) {
      return res.left;
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
      final res = await dispatch<bool>(DeleteWarehouseAction(id));
      if (res.isRight) {
        delFailed.add(row.cells['name']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }

  void onCheckInventory(WarehouseMd model) {
    context.showDialog(WarehouseInventoryPopup(model: model));
  }
}
