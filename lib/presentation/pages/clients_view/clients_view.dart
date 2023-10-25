import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/presentation/pages/clients_view/dialogs/clients_edit_dialog.dart';
import 'package:pluto_grid/pluto_grid.dart';

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
            title: "Name",
            field: "name",
            width: 200,
            minWidth: 200,
            type: PlutoColumnType.text(),
            renderer: (rendererContext) => rendererContext.defaultText()),
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
            type: PlutoColumnType.text()),
        //Quotes
        PlutoColumn(
            title: "Quotes",
            field: "quotes",
            width: 80,
            minWidth: 80,
            type: PlutoColumnType.text()),
        //Days since last job
        PlutoColumn(
            title: "Days since last job",
            field: "daysSinceLastJob",
            width: 80,
            minWidth: 80,
            type: PlutoColumnType.text()),
        //Messages
        PlutoColumn(
            title: "Messages",
            field: "messages",
            width: 80,
            minWidth: 80,
            type: PlutoColumnType.text()),
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
                  return true;
                  // return await deleteSelected(rendererContext.row);
                }, showError: false);
              },
              onEdit: () => onEdit((p0) => ClientsEditDialog(client: p0),
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
      "invoices": PlutoCell(value: model.invoices ?? ""),
      "activeJobs": PlutoCell(value: ""), //todo:
      "quotes": PlutoCell(value: ""), //todo:
      "daysSinceLastJob": PlutoCell(value: ""), //todo:
      "messages": PlutoCell(value: ""), //todo:
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
        hasHeader: false,
        columns: columns,
        rows: rows,
        columnsGroups: columnGroups);
  }
}
