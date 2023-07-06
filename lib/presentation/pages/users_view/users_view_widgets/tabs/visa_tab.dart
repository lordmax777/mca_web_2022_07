import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UserVisaTab extends StatelessWidget {
  final ValueChanged<PlutoGridOnLoadedEvent> onLoaded;
  final List<PlutoRow> rows;
  final void Function(UserVisaMd?) onEdit;
  final void Function() onDelete;

  const UserVisaTab(
      {super.key,
      required this.onLoaded,
      required this.onDelete,
      required this.onEdit,
      required this.rows});
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ListMd>(
        converter: (store) => store.state.generalState.lists,
        builder: (context, vm) {
          return DefaultTable(
              hasFooter: false,
              headerEnd: SpacedRow(
                horizontalSpace: 12,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: onDelete,
                      child: const Text("Delete Selected")),
                  ElevatedButton(
                      onPressed: () => onEdit(null),
                      child: const Text("New Visa")),
                ],
              ),
              onLoaded: onLoaded,
              columns: [
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  title: "Document #",
                  enableRowChecked: true,
                  field: "document_number",
                  type: PlutoColumnType.text(),
                ),
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  title: "Type",
                  field: "type",
                  type: PlutoColumnType.text(),
                ),
                PlutoColumn(
                    textAlign: PlutoColumnTextAlign.center,
                    title: "Valid From",
                    field: "valid_from",
                    type: PlutoColumnType.date(format: "dd/MM/yyyy")),
                PlutoColumn(
                    textAlign: PlutoColumnTextAlign.center,
                    title: "Valid To",
                    field: "valid_to",
                    type: PlutoColumnType.date(format: "dd/MM/yyyy")),
                PlutoColumn(
                    title: "Comment",
                    field: "comment",
                    type: PlutoColumnType.text(),
                    renderer: (ctx) {
                      return ctx.defaultTooltipWidget();
                    }),
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  width: 60,
                  title: "Edit",
                  field: "edit",
                  type: PlutoColumnType.text(),
                  renderer: (rendererContext) {
                    return IconButton(
                        onPressed: () {
                          onEdit(rendererContext.cell.value);
                        },
                        icon: const Icon(Icons.edit));
                  },
                ),
              ],
              rows: rows);
        });
  }
}
