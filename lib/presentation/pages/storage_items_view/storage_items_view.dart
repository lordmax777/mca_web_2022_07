import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/storage_items_view/new_stock_item_popup.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class StorageItemsView extends StatefulWidget {
  const StorageItemsView({super.key});

  @override
  State<StorageItemsView> createState() => _StorageItemsViewState();
}

class _StorageItemsViewState extends State<StorageItemsView>
    with TableFocusNodeMixin<StorageItemsView, StorageItemMd, StorageItemMd> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<StorageItemMd>>(
        converter: (store) => store.state.generalState.storageItems,
        onDidChange: onDidChange,
        builder: (context, vm) {
          return DefaultTable(
            mode: PlutoGridMode.normal,
            columns: columns,
            onLoaded: onLoaded,
            focusNode: focusNode,
            onChanged: (p0) {
              // onChanged
              final id = p0.row.cells["action"]!.value.id;
              final name = p0.row.cells["name"]!.value;
              final incomingPrice = p0.row.cells["incomingPrice"]!.value;
              final outgoingPrice = p0.row.cells["outgoingPrice"]!.value;
              final taxValue = p0.row.cells["tax"]!.value;
              final taxId = appStore.state.generalState.lists.taxes
                  .firstWhere((element) => element.rate == taxValue)
                  .id;
              //show loading
              //update item
              //hide loading
              //if fail assign old values using p0.row.cells["action"].value

              loading(() async {
                final success = await dispatch<int>(PostStorageItemAction(
                  id: id,
                  taxId: taxId,
                  title: name,
                  price: incomingPrice,
                  outgoingPrice: outgoingPrice,
                  fetchLists: false,
                ));
                //if fail assign old values using p0.row.cells["action"].value
                if (success.isRight) {
                  //fail
                  stateManager!.removeRows([p0.row]);
                  final String field = p0.column.field;
                  p0.row.cells[field]!.value = p0.oldValue;
                  stateManager!.insertRows(p0.rowIdx, [p0.row]);
                  context.showError(success.right.message);
                  return;
                }
              });
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
                      onEdit((p0) => NewStorageItemPopup(model: p0), null),
                  child: const Text("Create Storage Item"),
                ),
              ],
            ),
            rows: stateManager == null ? [] : stateManager!.rows,
          );
        });
  }

  @override
  PlutoRow buildRow(StorageItemMd model) {
    return PlutoRow(
      cells: {
        "name": PlutoCell(value: model.name),
        "incomingPrice": PlutoCell(value: model.incomingPrice),
        "outgoingPrice": PlutoCell(value: model.outgoingPrice),
        "tax": PlutoCell(
            value: appStore.state.generalState.lists.taxes
                .firstWhere((element) => element.id == model.taxId)
                .rate),
        "action": PlutoCell(value: model),
      },
    );
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Storage Item Name",
          field: "name",
          enableAutoEditing: true,
          enableRowChecked: true,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Our Price",
          enableAutoEditing: true,
          field: "incomingPrice",
          width: 100,
          type: PlutoColumnType.currency(
              symbol: appStore.state.generalState.companyInfo.currency.sign),
        ),
        PlutoColumn(
          title: "Customer Price",
          enableAutoEditing: true,
          field: "outgoingPrice",
          width: 100,
          type: PlutoColumnType.currency(
              symbol: appStore.state.generalState.companyInfo.currency.sign),
        ),
        PlutoColumn(
          title: "Tax",
          enableAutoEditing: true,
          field: "tax",
          width: 100,
          enableEditingMode: false,
          type: PlutoColumnType.select(appStore.state.generalState.lists.taxes
              .map((e) => e.rate)
              .toList()),
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          hide: true,
          type: PlutoColumnType.text(),
        ),
      ];

  @override
  Future<List<StorageItemMd>?> fetch() async {
    final res =
        await dispatch<List<StorageItemMd>>(const GetStorageItemsAction());
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
      final res = await dispatch<bool>(DeleteStorageItemAction(id));
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
