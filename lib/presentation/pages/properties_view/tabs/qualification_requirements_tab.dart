import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class QualificationRequirementsTab extends StatelessWidget {
  final ValueChanged<PlutoGridOnLoadedEvent> onLoaded;
  final List<PlutoRow> rows;
  final void Function(PropertyQualificationMd?) onEdit;
  final void Function(PlutoRow?) onDelete;
  final FocusNode focusNode;

  const QualificationRequirementsTab(
      {super.key,
      required this.onLoaded,
      required this.onDelete,
      required this.onEdit,
      required this.rows,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      columns: [
        PlutoColumn(
            title: "Qualification Name",
            field: "name",
            enableRowChecked: true,
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Min Level",
            field: "min_level",
            width: 80,
            renderer: (rendererContext) {
              return rendererContext.defaultText();
            },
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Number Of Staff",
            field: "number_of_staff",
            width: 80,
            type: PlutoColumnType.number()),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 40,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onDelete: () => onDelete(rendererContext.row),
            );
          },
        ),
      ],
      onLoaded: onLoaded,
      rows: rows,
      hasFooter: false,
      focusNode: focusNode,
      headerEnd: SpacedRow(
        horizontalSpace: 10,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => onDelete(null),
              child: const Text("Delete Selected")),
          ElevatedButton(
              onPressed: () => onEdit(null),
              child: const Text("New Qualification Requirement")),
        ],
      ),
    );
  }
}
