import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/actions/stocks_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ViewStockHistoryPopup extends StatefulWidget {
  final WarehouseMd warehouse;
  final StockMd stock;
  const ViewStockHistoryPopup(
      {super.key, required this.warehouse, required this.stock});

  @override
  State<ViewStockHistoryPopup> createState() => _ViewStockHistoryPopupState();
}

class _ViewStockHistoryPopupState extends State<ViewStockHistoryPopup>
    with
        TableFocusNodeMixin<ViewStockHistoryPopup, StockHistoryMd,
            StockHistoryMd> {
  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            title: "Date",
            field: 'date',
            width: 150,
            type: PlutoColumnType.date(
              format: 'dd/MM/yyyy HH:mm',
            )),
        PlutoColumn(
            title: "Action By",
            field: 'actionBy',
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Document Number",
            field: 'documentNumber',
            type: PlutoColumnType.text()),
        PlutoColumn(
            width: 80,
            title: "Added",
            field: "added",
            textAlign: PlutoColumnTextAlign.center,
            type: PlutoColumnType.text()),
        PlutoColumn(
            width: 80,
            title: "Removed",
            field: "removed",
            textAlign: PlutoColumnTextAlign.center,
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Comment",
          field: "comment",
          width: 100,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultTooltipWidget();
          },
        ),
        PlutoColumn(
          hide: true,
          title: "Action",
          field: 'action',
          type: PlutoColumnType.text(),
        ),
      ];

  @override
  Future<List<StockHistoryMd>?> fetch() async {
    final success = await dispatch<List<StockHistoryMd>>(GetStockHistoryAction(
        warehouseId: widget.warehouse.id, itemId: widget.stock.itemId!));
    if (success.isLeft) {
      return success.left;
    } else if (success.isRight) {
      if (success.right.code == 400) {
        context.showError("No history found");
        return null;
      }
      context.showError(success.right.message);
    } else {
      context.showError("Something went wrong");
    }
    return null;
  }

  @override
  PlutoRow buildRow(StockHistoryMd model) {
    return PlutoRow(
      cells: {
        'date': PlutoCell(value: model.timestampDt),
        'actionBy': PlutoCell(value: model.enteredBy),
        'documentNumber': PlutoCell(value: model.docno),
        'added': PlutoCell(
            value:
                !(model.quantity?.isNegative ?? false) ? model.quantity : ""),
        'removed': PlutoCell(
            value: (model.quantity?.isNegative ?? false)
                ? model.quantity!.abs()
                : ""),
        'comment': PlutoCell(value: model.comment),
        'action': PlutoCell(value: model),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SpacedRow(
        children: [
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.arrow_back),
          ),
          Text(
              "Stock History. ${widget.warehouse.name} - ${widget.stock.itemName}")
        ],
      ),
      content: SizedBox(
        height: context.height,
        width: context.width,
        child: DefaultTable(
          headerEnd: SpacedRow(
            horizontalSpace: 30,
            children: [
              // icon with text
              //ex: Icons.storage Canary Wharf storage

              SpacedRow(
                crossAxisAlignment: CrossAxisAlignment.center,
                horizontalSpace: 10,
                children: [
                  const Icon(Icons.warehouse_outlined),
                  Text(
                    widget.warehouse.name,
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),

              SpacedRow(
                crossAxisAlignment: CrossAxisAlignment.center,
                horizontalSpace: 10,
                children: [
                  const Icon(Icons.border_all_outlined),
                  Text(
                    widget.stock.itemName ?? "-",
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
          onLoaded: onLoaded,
          rows: rows,
          columns: columns,
          focusNode: focusNode,
        ),
      ),
    );
  }
}
