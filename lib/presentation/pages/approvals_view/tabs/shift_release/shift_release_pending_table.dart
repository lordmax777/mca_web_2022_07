import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_text_field.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ShiftReleasePendingTable extends StatelessWidget {
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final FocusNode? focusNode;
  final List<PlutoRow> rows;
  final void Function(PlutoRow? singleRow, String action) onApprove;

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
                value: "publish",
                child: Text("Publish Selected"),
              ),
              const PopupMenuItem(
                value: "unpublish",
                child: Text("Unpublish"),
              ),
              const PopupMenuItem(
                value: "approve",
                child: Text("Approve Selected"),
              ),
              const PopupMenuItem(
                value: "deny",
                child: Text("Deny Selected"),
              ),
            ],
            onSelected: (value) => onApprove(null, value),
          ),
        ],
      ),
      onLoaded: onLoaded,
      columns: [
        PlutoColumn(
            enableRowChecked: true,
            title: "Requested By",
            field: "requestedBy",
            enableEditingMode: false,
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Requested On",
            field: "requestedOn",
            enableEditingMode: false,
            type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm")),
        PlutoColumn(
            enableEditingMode: false,
            title: "Shift",
            field: "name",
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Date/Time",
          field: "dateTime",
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Comment",
          field: "comment",
          width: 200,
          enableEditingMode: true,
          enableAutoEditing: true,
          renderer: (rendererContext) {
            //container with rounded corners and border inside text from cell
            return rendererContext.defaultEditableCellWidget();
          },
          type: PlutoColumnType.text(),
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
                  value: "publish",
                  child: Text("Publish"),
                ),
                const PopupMenuItem(
                  value: "unpublish",
                  child: Text("Unpublish"),
                ),
                const PopupMenuItem(
                  value: "approve",
                  child: Text("Approve"),
                ),
                const PopupMenuItem(
                  value: "deny",
                  child: Text("Deny"),
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
