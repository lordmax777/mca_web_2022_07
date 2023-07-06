import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UserQualificationTab extends StatelessWidget {
  final ValueChanged<PlutoGridOnLoadedEvent> onLoaded;
  final List<PlutoRow> rows;
  final void Function(UserQualificationMd?) onEdit;
  final void Function(UserQualificationMd?) onDelete;
  final void Function(UserQualificationMd) onCertificatePressed;

  const UserQualificationTab(
      {super.key,
      required this.onLoaded,
      required this.onDelete,
      required this.onEdit,
      required this.onCertificatePressed,
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
                // ElevatedButton(
                //     style:
                //         ElevatedButton.styleFrom(backgroundColor: Colors.red),
                //     onPressed: () => onDelete(null),
                //     child: const Text("Delete Selected")),
                ElevatedButton(
                    onPressed: () => onEdit(null),
                    child: const Text("New Qualification")),
              ],
            ),
            onLoaded: onLoaded,
            columns: [
              PlutoColumn(
                  title: "Qualification",
                  field: "qualification",
                  enableRowChecked: true,
                  type: PlutoColumnType.text()),
              PlutoColumn(
                title: "Level",
                field: "level",
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                title: "Certificate",
                field: "certificate",
                enableSorting: false,
                type: PlutoColumnType.text(),
                renderer: (rendererContext) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Image.memory(
                      rendererContext.cell.value.certificateBytes,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text("");
                      },
                    ),
                  );
                },
              ),
              PlutoColumn(
                  title: "Certification #",
                  field: "certification_number",
                  type: PlutoColumnType.text()),
              PlutoColumn(
                  title: "Achievement Date",
                  field: "achievement_date",
                  type: PlutoColumnType.date(format: "dd/MM/yyyy")),
              PlutoColumn(
                  title: "Expiry Date",
                  field: "expiry_date",
                  type: PlutoColumnType.date(format: "dd/MM/yyyy")),
              PlutoColumn(
                  title: "Comment",
                  field: "comment",
                  enableSorting: false,
                  type: PlutoColumnType.text(),
                  renderer: (ctx) {
                    return ctx.defaultTooltipWidget();
                  }),
              PlutoColumn(
                width: 40,
                title: "Action",
                enableSorting: false,
                field: "action",
                type: PlutoColumnType.text(),
                renderer: (rendererContext) {
                  return rendererContext.actionMenuWidget(
                      onDelete: () => onDelete(rendererContext.cell.value),
                      onEdit: () => onEdit(rendererContext.cell.value));
                },
              ),
            ],
            rows: rows,
            onSelected: (p0) {
              switch (p0.cell?.column.field) {
                case "certificate":
                  onCertificatePressed(p0.cell?.value);
                  break;
              }
            },
          );
        });
  }
}
