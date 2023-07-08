import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ReqPendingTable extends StatelessWidget {
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final FocusNode? focusNode;
  final List<PlutoRow> rows;
  final Widget? headerEnd;

  const ReqPendingTable(
      {super.key,
      required this.onLoaded,
      this.focusNode,
      required this.rows,
      this.headerEnd});

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      focusNode: focusNode,
      headerEnd: headerEnd,
      onLoaded: onLoaded,
      columns: [
        PlutoColumn(
            title: "Requested On",
            field: "requestedOn",
            width: 200,
            type: PlutoColumnType.date(format: "dd/MM/yyyy HH:mm")),
        PlutoColumn(
            title: "Name",
            width: 100,
            field: "name",
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Type",
            width: 100,
            field: "type",
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Date/Time",
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
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultTooltipWidget();
          },
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 40,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return PopupMenuButton(
              offset: const Offset(0, 40),
              padding: const EdgeInsets.all(0),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Approve"),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("Decline"),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 1:
                    //todo: approve
                    break;
                  case 2:
                    //todo: decline
                    break;
                }
              },
            );
          },
        ),
      ],
      rows: rows,
    );
  }
}
