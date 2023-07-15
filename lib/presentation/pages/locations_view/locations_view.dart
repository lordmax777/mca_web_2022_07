import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/locations_view/create_location_popup.dart';
import 'package:mca_dashboard/presentation/pages/warehouses_view/dialogs/new_warehouse_popup.dart';
import 'package:mca_dashboard/presentation/pages/warehouses_view/dialogs/warehouse_properties_popup.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class LocationsView extends StatefulWidget {
  const LocationsView({super.key});

  @override
  State<LocationsView> createState() => _LocationsViewState();
}

class _LocationsViewState extends State<LocationsView>
    with TableFocusNodeMixin<LocationsView, LocationMd, LocationMd> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<LocationMd>>(
        converter: (store) => store.state.generalState.locations,
        onDidChange: onDidChange,
        builder: (context, vm) {
          return DefaultTable(
            columns: columns,
            onLoaded: onLoaded,
            focusNode: focusNode,
            onSelected: (p0) {
              if (stateManager!.hasFocus) {
                stateManager?.gridFocusNode.removeListener(handleFocus);
              }
              switch (p0.cell?.column.field) {
                case "address":
                  final address = p0.row!.cells["action"]?.value;
                  if (address.anywhere) return;
                  if (address.address.line1.isEmpty) return;
                  showMapPopup(context, location: address);
                  break;
              }
            },
            headerEnd: SpacedRow(
              horizontalSpace: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onDelete(() async {
                      return await deleteSelected(null);
                    }, showError: false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Delete Selected"),
                ),
                ElevatedButton(
                  onPressed: () {
                    showMapPopup(context, location: null);
                  },
                  child: const Text("View All Locations"),
                ),
                ElevatedButton(
                  onPressed: () {
                    onEdit((p0) => const CreateLocationPopup(), null);
                  },
                  child: const Text("Create Location"),
                ),
              ],
            ),
            rows: stateManager == null ? [] : stateManager!.rows,
          );
        });
  }

  @override
  PlutoRow buildRow(LocationMd model) {
    String staff = "";
    staff = model.members.map((e) => "${e.name}: ${e.min}").join(" & ");
    String ipaddress = "";
    ipaddress = model.ipaddress.map((e) => e.ipAddress).join(" & ");
    return PlutoRow(
      cells: {
        "name": PlutoCell(value: model.name),
        "address":
            PlutoCell(value: model.anywhere ? "Anywhere" : model.address.line1),
        "email": PlutoCell(value: model.email),
        "staff": PlutoCell(value: staff),
        "ipAddress": PlutoCell(value: ipaddress),
        "status": PlutoCell(value: model.active ? "Active" : "Inactive"),
        "action": PlutoCell(value: model),
      },
    );
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Location Name",
          field: "name",
          enableRowChecked: true,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Address",
          field: "address",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(
                isSelectable: rendererContext.cell.value != "Anywhere");
          },
        ),
        PlutoColumn(
          title: "Contact",
          field: "email",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Required Staff",
          field: "staff",
          width: 120,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "IP Address",
          field: "ipAddress",
          width: 120,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Status",
          field: "status",
          width: 80,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          width: 60,
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onDelete: () {
                onDelete(() async {
                  return await deleteSelected(rendererContext.row);
                }, showError: false);
              },
              onEdit: () {
                final LocationMd loc =
                    rendererContext.row.cells['action']!.value;
                onEdit((p0) => CreateLocationPopup(model: p0), loc);
              },
            );
          },
        ),
      ];

  @override
  Future<List<LocationMd>?> fetch() async {
    final res = await dispatch<List<LocationMd>>(const GetLocationsAction());
    if (res.isLeft) {
      return res.left;
    }
    return null;
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
      final res = await dispatch<bool>(DeleteLocationAction(id));
      if (res.isRight) {
        delFailed.add(row.cells['name']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }
}
