import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ShiftReleasePendingTable extends StatelessWidget {
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final FocusNode? focusNode;
  final List<PlutoRow> rows;
  final void Function(PlutoRow? singleRow, bool isApprove) onApprove;

  const ShiftReleasePendingTable(
      {super.key,
      required this.onLoaded,
      this.focusNode,
      required this.rows,
      required this.onApprove});

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      focusNode: focusNode,
      headerEnd: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Build PopupMenuButton which has a list of actions [Approve, Decline], and button itself is button with text "Actions", leave on tap empty with switch options
          PopupMenuButton(
            offset: const Offset(0, 40),
            padding: const EdgeInsets.all(0),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text("Actions",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: context.colorScheme.primary))),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: true,
                child: Text("Approve Selected"),
              ),
              const PopupMenuItem(
                value: false,
                child: Text("Decline Selected"),
              ),
            ],
            onSelected: (value) => onApprove(null, value),
          ),
        ],
      ),
      onLoaded: onLoaded,
      columns: [
        PlutoColumn(
            title: "Requested On",
            field: "requestedOn",
            enableRowChecked: true,
            width: 200,
            // hide: true,
            type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm")),
        PlutoColumn(
            title: "Name",
            width: 100,
            field: "name",
            hide: true,
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Type",
            width: 100,
            field: "type",
            hide: true,
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Date/Time",
          field: "dateTime",
          hide: true,
          width: 200,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Comment",
          field: "comment",
          hide: true,
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultTooltipWidget();
          },
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          hide: true,
          width: 40,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return PopupMenuButton(
              offset: const Offset(0, 40),
              padding: const EdgeInsets.all(0),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: true,
                  child: Text("Approve"),
                ),
                const PopupMenuItem(
                  value: false,
                  child: Text("Decline"),
                ),
              ],
              onSelected: (value) => onApprove(rendererContext.row, value),
            );
          },
        ),
      ],
      rows: rows,
    );
  }
}
