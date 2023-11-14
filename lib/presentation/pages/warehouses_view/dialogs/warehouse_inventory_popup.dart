import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/actions/stocks_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/warehouses_view/dialogs/add_to_stock_popup.dart';
import 'package:mca_dashboard/presentation/pages/warehouses_view/dialogs/change_min_level_popup.dart';
import 'package:mca_dashboard/presentation/pages/warehouses_view/dialogs/transfer_stock_popup.dart';
import 'package:mca_dashboard/presentation/pages/warehouses_view/dialogs/view_stock_history_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

class WarehouseInventoryPopup extends StatefulWidget {
  const WarehouseInventoryPopup({super.key, required this.model});

  final WarehouseMd model;

  @override
  State<WarehouseInventoryPopup> createState() =>
      _WarehouseInventoryPopupState();
}

class _WarehouseInventoryPopupState extends State<WarehouseInventoryPopup>
    with TableFocusNodeMixin<WarehouseInventoryPopup, StockMd, StockMd> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(widget.model.name),
          const Spacer(),
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        height: context.height,
        width: context.width,
        child: DefaultTable(
          onLoaded: onLoaded,
          columns: columns,
          rows: rows,
          focusNode: focusNode,
        ),
      ),
    );
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Item Name",
          field: 'name',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Current Stock",
          field: "currentStock",
          type: PlutoColumnType.number(),
          renderer: (rendererContext) {
            final model = rendererContext.row.cells['action']!.value as StockMd;
            final current = rendererContext.cell.value as int;
            final min = model.minimum ?? 0;
            final bool isLow = current < min;
            return Text(
              "$current (Min $min)",
              style: TextStyle(
                color: isLow ? Colors.red : Colors.black,
              ),
            );
          },
        ),
        PlutoColumn(
          title: "Last Updated",
          field: "lastUpdated",
          type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm"),
        ),
        PlutoColumn(
          width: 40,
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            final model = rendererContext.cell.value as StockMd;
            return PopupMenuButton(
              offset: const Offset(0, 40),
              padding: const EdgeInsets.all(0),
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: "addToStock",
                    child: SpacedRow(horizontalSpace: 10, children: const [
                      Icon(Icons.add),
                      Text("Add to Stock")
                    ])),
                PopupMenuItem(
                    value: "removeFromStock",
                    enabled: (model.current ?? 0) > 0,
                    child: SpacedRow(horizontalSpace: 10, children: const [
                      Icon(Icons.remove),
                      Text("Remove from Stock")
                    ])),
                PopupMenuItem(
                    value: "transfer",
                    child: SpacedRow(
                        horizontalSpace: 10,
                        children: const [Icon(Icons.send), Text("Transfer")])),
                PopupMenuItem(
                    value: "changeMinimumLevel",
                    child: SpacedRow(horizontalSpace: 10, children: const [
                      Icon(Icons.trending_down_rounded),
                      Text("Change Minimum Level")
                    ])),
                PopupMenuItem(
                    value: "viewStockHistory",
                    child: SpacedRow(horizontalSpace: 10, children: const [
                      Icon(Icons.history),
                      Text("View Stock History")
                    ])),
              ],
              onSelected: (value) async {
                if (stateManager!.hasFocus) {
                  stateManager?.gridFocusNode.removeListener(handleFocus);
                }
                bool? success;
                switch (value) {
                  case "addToStock":
                    success = await context.showDialog(AddToStockPopup(
                      stock: model,
                      warehouse: widget.model,
                    ));
                    break;
                  case "removeFromStock":
                    success = await context.showDialog(AddToStockPopup(
                      stock: model,
                      warehouse: widget.model,
                      isAdd: false,
                    ));
                    break;
                  case "transfer":
                    success = await context.showDialog(TransferStockPopup(
                      stock: model,
                      warehouse: widget.model,
                    ));
                    break;
                  case "changeMinimumLevel":
                    success = await context.showDialog(ChangeMinLevelPopup(
                      stock: rendererContext.cell.value,
                      warehouse: widget.model,
                    ));
                    break;
                  case "viewStockHistory":
                    await context.showDialog(ViewStockHistoryPopup(
                      stock: rendererContext.cell.value,
                      warehouse: widget.model,
                    ));
                    break;
                }
                if (success == null) return;
                if (success) {
                  final list =
                      await loading<List<StockMd>?>(() async => await fetch());
                  if (list != null) {
                    setRows(
                        stateManager!, list.map((e) => buildRow(e)).toList());
                  }
                }
              },
            );
          },
        ),
      ];

  @override
  PlutoRow buildRow(StockMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: model.itemName),
      "currentStock": PlutoCell(value: model.current),
      "lastUpdated": PlutoCell(value: model.lastUpdate),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Future<List<StockMd>?> fetch() async {
    final res = await dispatch<List<StockMd>>(
        GetCurrentStockListAction(widget.model.id));
    if (res.isLeft) {
      return res.left;
    } else if (res.isRight) {
      context.showError(res.right.message);
    } else {
      context.showError("Something went wrong");
    }
    return null;
  }
}
