import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UserPayrollTab extends StatelessWidget {
  final ValueChanged<PlutoGridOnLoadedEvent> onLoaded;
  final List<PlutoRow> rows;
  final void Function(UserContractMd?) onEdit;
  final void Function() onDelete;

  const UserPayrollTab(
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
                      child: const Text("New Contract")),
                ],
              ),
              onLoaded: onLoaded,
              columns: [
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  title: "CSD",
                  enableRowChecked: true,
                  field: "csd",
                  type: PlutoColumnType.date(format: "dd/MM/yyyy"),
                ),
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  title: "CED",
                  field: "ced",
                  type: PlutoColumnType.date(format: "dd/MM/yyyy"),
                ),
                PlutoColumn(
                    textAlign: PlutoColumnTextAlign.center,
                    title: "Contract Type",
                    field: "contract_type",
                    type: PlutoColumnType.text()),
                PlutoColumn(
                    textAlign: PlutoColumnTextAlign.center,
                    title: "HCT",
                    field: "hct",
                    type: PlutoColumnType.text()),
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  title: "AWH",
                  field: "awh",
                  type: PlutoColumnType.number(),
                  formatter: (value) {
                    return "${value.toStringAsFixed(0)} hour(s)";
                  },
                ),
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  title: "WD",
                  field: "wd",
                  type: PlutoColumnType.number(),
                  formatter: (value) {
                    return "${value.toStringAsFixed(0)} day(s)";
                  },
                ),
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  title: "AHE",
                  field: "ahe",
                  type: PlutoColumnType.number(),
                  formatter: (value) {
                    return "${value.toStringAsFixed(0)} week(s)";
                  },
                ),
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
