import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../manager/dependencies/dependency_manager.dart';

class UserQualifTable extends StatelessWidget {
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final FocusNode? focusNode;
  final List<PlutoRow> rows;
  final void Function(PlutoRow? singleRow, bool isApprove) onApprove;

  const UserQualifTable({
    super.key,
    required this.onLoaded,
    this.focusNode,
    required this.rows,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      focusNode: focusNode,
      onLoaded: onLoaded,
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
            ],
            onSelected: (value) => onApprove(null, value),
          ),
        ],
      ),
      columns: [
        PlutoColumn(
            title: "User",
            enableRowChecked: true,
            field: "user",
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Qualification",
            field: "qualification",
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Certificate",
          field: "certificate",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            if (rendererContext.cell.value == null) return const SizedBox();
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Image.memory(
                rendererContext.cell.value,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("");
                },
              ),
            );
          },
        ),
        PlutoColumn(
            title: "Document #",
            field: "documentNumber",
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Date acquired",
          field: "dateAcquired",
          width: 100,
          type: PlutoColumnType.date(format: "dd/MM/yyyy"),
        ),
        PlutoColumn(
          title: "Expiry date",
          field: "expiryDate",
          width: 100,
          type: PlutoColumnType.date(format: "dd/MM/yyyy"),
        ),
        PlutoColumn(
          title: "Comments",
          field: "comments",
          type: PlutoColumnType.text(),
          width: 120,
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
                  value: true,
                  child: Text("Approve"),
                ),
              ],
              onSelected: (value) => onApprove(rendererContext.row, value),
            );
          },
        ),
      ],
      onSelected: (p0) {
        switch (p0.cell?.column.field) {
          case "certificate":
            final item = p0.row!.cells["action"]!.value;
            if (item.thumbnail == null) return;
            DependencyManager.instance.navigation.showCustomDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Row(
                      children: [
                        const Text("Certificate"),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    children: [
                      Image.memory(
                        item.thumbnailBytes,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text("Failed to load image");
                        },
                      )
                    ],
                  );
                });
        }
      },
      rows: rows,
    );
  }
}
