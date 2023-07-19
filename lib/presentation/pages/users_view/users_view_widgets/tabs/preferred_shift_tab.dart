import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UserPreferredShiftsTab extends StatelessWidget {
  final ValueChanged<PlutoGridOnLoadedEvent> onLoaded;
  final List<PlutoRow> rows;
  final void Function(UserPreferredShiftMd?) onEdit;
  final void Function(UserPreferredShiftMd?) onDelete;

  const UserPreferredShiftsTab(
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
                      onPressed: () => onDelete(null),
                      child: const Text("Delete Selected")),
                  ElevatedButton(
                      onPressed: () => onEdit(null),
                      child: const Text("New Shift")),
                ],
              ),
              onLoaded: onLoaded,
              columns: [
                PlutoColumn(
                  title: "Week",
                  width: 20,
                  field: "weekId",
                  type: PlutoColumnType.number(),
                ),
                PlutoColumn(
                  title: "Day",
                  width: 120,
                  field: "dayId",
                  type: PlutoColumnType.number(),
                  formatter: (value) {
                    return WeekDaysMd()
                        .asMapIntString[value]
                        .toString()
                        .toUpperCase();
                  },
                ),
                PlutoColumn(
                  textAlign: PlutoColumnTextAlign.center,
                  title: "Location",
                  field: "location",
                  type: PlutoColumnType.text(),
                  renderer: (rendererContext) {
                    return rendererContext.defaultText();
                  },
                ),
                PlutoColumn(
                    textAlign: PlutoColumnTextAlign.center,
                    title: "Shift",
                    field: "shift",
                    type: PlutoColumnType.text()),
                PlutoColumn(
                  width: 120,
                  textAlign: PlutoColumnTextAlign.center,
                  title: "Timing",
                  field: "timing",
                  type: PlutoColumnType.text(),
                  renderer: (rendererContext) {
                    return rendererContext.defaultText();
                  },
                ),
                PlutoColumn(
                  width: 10,
                  textAlign: PlutoColumnTextAlign.center,
                  title: "Delete",
                  field: "delete",
                  type: PlutoColumnType.text(),
                  renderer: (rendererContext) {
                    if (rendererContext.row.type.isGroup) {
                      return const SizedBox();
                    }
                    return IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        onDelete(rendererContext.cell.value);
                      },
                    );
                  },
                ),
              ],
              rows: rows);
        });
  }
}
