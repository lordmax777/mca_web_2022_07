import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ReqPendingTable extends StatelessWidget {
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final FocusNode? focusNode;
  final List<PlutoRow> rows;
  final void Function(PlutoRow? singleRow, bool isApprove) onApprove;

  const ReqPendingTable(
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
            enableEditingMode: false,
            width: 200,
            type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm")),
        PlutoColumn(
            title: "Name",
            enableEditingMode: false,
            width: 100,
            field: "name",
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Type",
            enableEditingMode: false,
            width: 100,
            field: "type",
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Date/Time",
          enableEditingMode: false,
          field: "dateTime",
          width: 200,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Comment",
          field: "comment",
          enableEditingMode: false,
          width: 100,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultTooltipWidget();
          },
        ),
        PlutoColumn(
          title: "Your Comment",
          field: "yourComment",
          enableAutoEditing: true,
          width: 200,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultEditableCellWidget();
          },
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          enableEditingMode: false,
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
      mode: PlutoGridMode.normal,
      rows: rows,
    );
  }
}
