import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/presentation/pages/clients_view/dialogs/client_details_dialog.dart';
import 'package:mca_dashboard/presentation/pages/clients_view/dialogs/clients_edit_dialog.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'dialogs/clients_edit_2_dialog.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView>
    with TableFocusNodeMixin<ClientsView, ClientMd, ClientMd> {
  final List<PlutoColumnGroup> columnGroups = [
    // PlutoColumnGroup(title: "Contact Details", fields: ['email', 'phone'])
  ];

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            title: "Name (Company)",
            field: "name",
            enableRowChecked: true,
            width: 200,
            minWidth: 200,
            type: PlutoColumnType.text(),
            renderer: (rendererContext) =>
                rendererContext.defaultText(isSelectable: true)),
        PlutoColumn(
            width: 170,
            minWidth: 170,
            title: "Email",
            field: "email",
            type: PlutoColumnType.text(),
            renderer: (rendererContext) => rendererContext.defaultText()),
        PlutoColumn(
            width: 80,
            minWidth: 80,
            title: "Phone",
            field: "phone",
            type: PlutoColumnType.text()),
        //Outstanding invoices #.##
        PlutoColumn(
            title: "Outstanding Invoices",
            field: "invoices",
            titleTextAlign: PlutoColumnTextAlign.center,
            titleSpan: const WidgetSpan(
                child: Column(
              children: [
                Text("Outstanding",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text("Invoices", style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            )),
            width: 80,
            minWidth: 80,
            type: PlutoColumnType.number(format: "#,###.##")),
        //Active Jobs
        PlutoColumn(
            title: "Active Jobs",
            field: "activeJobs",
            width: 80,
            minWidth: 80,
            type: PlutoColumnType.number()),
        //Quotes
        PlutoColumn(
            title: "Quotes",
            field: "quotes",
            width: 80,
            minWidth: 80,
            type: PlutoColumnType.number()),
        //Days since last job
        PlutoColumn(
            title: "Days since last job",
            field: "daysSinceLastJob",
            width: 80,
            minWidth: 80,
            titleTextAlign: PlutoColumnTextAlign.center,
            titleSpan: const WidgetSpan(
                child: Column(
              children: [
                Text("Days since",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text("last job", style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            )),
            type: PlutoColumnType.number()),
        //Messages
        PlutoColumn(
            title: "Messages",
            field: "messages",
            width: 80,
            minWidth: 80,
            type: PlutoColumnType.number()),
        PlutoColumn(
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          width: 60,
          enableFilterMenuItem: false,
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onDelete: () {
                onDelete(() async {
                  return await deleteSelected(rendererContext.row);
                }, showError: false);
              },
              onEdit: () => onEdit((p0) => ClientsEdit2Dialog(client: p0),
                  rendererContext.cell.value),
            );
          },
        ),
      ];

  @override
  Future<List<ClientMd>?> fetch() async {
    final res = await dispatch<List<ClientMd>>(const GetClientsAction());
    if (res.isLeft) {
      //success
      return res.left;
    }
    return null;
  }

  @override
  PlutoRow buildRow(ClientMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(
          value:
              "${model.name}${model.company != null ? " (${model.company})" : ""}"),
      "email": PlutoCell(value: model.email ?? ""),
      "phone": PlutoCell(value: model.phone ?? ""),
      "invoices": PlutoCell(value: model.invoices),
      "activeJobs": PlutoCell(value: model.checklists),
      "quotes": PlutoCell(value: model.quotes),
      "daysSinceLastJob": PlutoCell(value: model.daysSinceLastJob),
      "messages": PlutoCell(value: model.quotemessages),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      columnFilter: const PlutoGridColumnFilterConfig(filters: [
        ...FilterHelper.defaultFilters,
      ]),
      onLoaded: (p0) {
        p0.stateManager.setShowColumnFilter(true);
        onLoaded(p0);
      },
      headerEnd: Row(
        children: [
          ElevatedButton(
              onPressed: () =>
                  onDelete(() => deleteSelected(null), showError: false),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete Selected")),
          const SizedBox(width: 10),
          ElevatedButton(
              onPressed: () => onEdit(
                  (p0) => const ClientsEdit2Dialog(client: null), null,
                  showSuccess: false),
              child: const Text("Add Client")),
        ],
      ),
      columns: columns,
      rows: rows,
      columnsGroups: columnGroups,
      onSelected: (p0) {
        final colName = p0.cell?.column.field;
        final model = p0.row!.cells['action']!.value as ClientMd;
        switch (colName) {
          case "name":
            //show client details
            context.showDialog(ClientDetailsDialog(client: model));
            break;

          default:
            break;
        }
      },
    );
  }

  Future<bool> deleteSelected(PlutoRow? singleRow) async {
    final selected = [...stateManager!.checkedRows];
    if (singleRow != null) {
      selected.clear();
      selected.add(singleRow);
    }
    if (selected.isEmpty) {
      return false;
    }
    final List<String> delFailed = [];
    for (final row in selected) {
      final id = row.cells['action']!.value.id;
      final res = await dispatch<bool>(DeleteClientAction(id));
      if (res.isRight) {
        delFailed.add(row.cells['name']!.value + " (${res.right.message})");
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete\n${delFailed.join("\n")}");
    }
    return delFailed.isEmpty;
  }
}
