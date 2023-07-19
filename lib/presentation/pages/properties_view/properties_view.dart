import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/new_property_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PropertiesView extends StatefulWidget {
  const PropertiesView({super.key});

  @override
  State<PropertiesView> createState() => _PropertiesViewState();
}

class _PropertiesViewState extends State<PropertiesView>
    with TableFocusNodeMixin<PropertiesView, PropertyMd, PropertyMd> {
  final _dependencies = DependencyManager.instance;

  @override
  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {}
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      onLoaded: onLoaded,
      columns: columns,
      rows: stateManager == null ? [] : stateManager!.rows,
      focusNode: focusNode,
      onSelected: (p0) {
        switch (p0.cell?.column.field) {
          case "name":
            final model = p0.row!.cells["action"]!.value as PropertyMd;
            onEdit((p0) => NewPropertyPopup(model: p0), model);
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
            onPressed: () => onEdit((p0) => NewPropertyPopup(model: p0), null),
            child: const Text("Create Property"),
          ),
        ],
      ),
    );
  }

  @override
  Future<List<PropertyMd>?> fetch() async {
    final res = await dispatch<List<PropertyMd>>(const GetPropertiesAction());
    if (res.isLeft) {
      return res.left;
    }
    return null;
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Property Name",
          field: "name",
          enableRowChecked: true,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(isSelectable: true);
          },
        ),
        PlutoColumn(
          title: "Location",
          field: "location",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Client",
          field: "client",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Warehouse",
          field: "warehouse",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText();
          },
        ),
        PlutoColumn(
          title: "Status",
          field: "status",
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
              onEdit: () => onEdit((p0) => NewPropertyPopup(model: p0),
                  rendererContext.cell.value),
            );
          },
        ),
      ];

  @override
  PlutoRow buildRow(PropertyMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: model.title),
      "location": PlutoCell(value: model.locationName),
      "client": PlutoCell(value: model.clientName),
      "warehouse": PlutoCell(value: model.warehouseName),
      "status": PlutoCell(value: model.active ? "Active" : "Inactive"),
      "action": PlutoCell(value: model),
    });
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
      final res = await dispatch<bool>(DeletePropertyAction(id));
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
