import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/actions/jobtemplate_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/presentation/pages/storage_items_view/dialogs/new_jobtemplate_dialog.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PackagesView extends StatefulWidget {
  const PackagesView({super.key});

  @override
  State<PackagesView> createState() => _PackagesViewState();
}

class _PackagesViewState extends State<PackagesView>
    with
        TableFocusNodeMixin<PackagesView, JobTemplateItemMd,
            JobTemplateItemMd> {
  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Package Name",
          field: 'packageName',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Client",
          field: "client",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            if (rendererContext.row.type.isGroup) {
              final templateName =
                  rendererContext.row.cells['packageName']!.value as String;
              final template = appStore.state.generalState.jobTemplates
                  .firstWhereOrNull((element) => element.name == templateName);
              String clientName =
                  template?.client(appStore.state.generalState.clients)?.name ??
                      "ALL";
              return Text(clientName);
            }
            return const SizedBox();
          },
        ),
        PlutoColumn(
          title: "Item Name",
          type: PlutoColumnType.text(),
          field: "itemName",
        ),
        PlutoColumn(
            title: "Price", field: 'price', type: PlutoColumnType.number()),
        PlutoColumn(
            title: 'Quantity',
            field: 'quantity',
            type: PlutoColumnType.number()),
        PlutoColumn(
          width: 80,
          minWidth: 80,
          title: "Action",
          field: 'action',
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            if (!rendererContext.row.type.isGroup) {
              final item = rendererContext.cell.value as JobTemplateItemMd;
              return Text(item.totalPrice.getPriceMap());
            }
            final templateName =
                (rendererContext.row.cells["packageName"]!.value as String);
            final template = appStore.state.generalState.jobTemplates
                .firstWhereOrNull((element) => element.name == templateName);
            return rendererContext.actionMenuWidget(
              onEdit: () => onAddNewPackage(template),
              onDelete: () {
                //todo:
              },
            );
          },
        )
      ];

  @override
  PlutoRow buildRow(JobTemplateItemMd model) {
    final item = model.item(appStore.state.generalState.storageItems);
    return PlutoRow(cells: {
      "packageName": PlutoCell(value: model.template?.name),
      "client": PlutoCell(
          value: model.template
                  ?.client(appStore.state.generalState.clients)
                  ?.name ??
              ''),
      "itemName": PlutoCell(value: item?.name),
      "price": PlutoCell(value: model.price),
      "quantity": PlutoCell(value: model.quantity),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Future<List<JobTemplateItemMd>?> fetch() async {
    final res =
        await dispatch<List<JobTemplateMd>>(const GetJobTemplatesAction());
    if (res.isLeft) {
      return res.left.expand((element) => element.items).toList();
    }
    return null;
  }

  void onAddNewPackage([JobTemplateMd? template]) {
    context.showDialog(NewJobTemplatePopup(
      model: template,
      onRefresh: fetch,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<JobTemplateItemMd>>(
        converter: (store) => store.state.generalState.jobTemplates
            .expand((element) => element.items)
            .toList(),
        onDidChange: onDidChange,
        builder: (context, vm) {
          return DefaultTable(
            rows: stateManager == null ? [] : stateManager!.rows,
            columns: columns,
            headerEnd: ElevatedButton(
              onPressed: onAddNewPackage,
              child: const Text("New package"),
            ),
            onLoaded: (e) {
              e.stateManager.setRowGroup(
                  PlutoRowGroupByColumnDelegate(showCount: false, columns: [
                e.stateManager.columns[0],
              ]));
              onLoaded(e);
            },
            focusNode: focusNode,
          );
        });
  }
}
