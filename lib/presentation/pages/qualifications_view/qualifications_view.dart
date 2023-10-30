import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/qualifications_view/new_qualification_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

class QualificationsView extends StatefulWidget {
  const QualificationsView({super.key});

  @override
  State<QualificationsView> createState() => _QualificationsViewState();
}

class _QualificationsViewState extends State<QualificationsView>
    with
        TableFocusNodeMixin<QualificationsView, QualificationMd,
            QualificationMd> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<QualificationMd>>(
        converter: (store) => store.state.generalState.lists.qualifications,
        onDidChange: onDidChange,
        builder: (context, vm) {
          return DefaultTable(
            columns: columns,
            onLoaded: onLoaded,
            focusNode: focusNode,
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
                  onPressed: () =>
                      onEdit((p0) => NewQualificationPopup(model: p0), null),
                  child: const Text("Create Qualification"),
                ),
              ],
            ),
            rows: stateManager == null ? [] : stateManager!.rows,
          );
        });
  }

  @override
  PlutoRow buildRow(QualificationMd model) {
    return PlutoRow(
      cells: {
        "name": PlutoCell(value: model.title),
        "expire": PlutoCell(value: model.expire ? "Yes" : "No"),
        "levels": PlutoCell(value: model.levels ? "Yes" : "No"),
        "comment": PlutoCell(value: model.comments),
        "action": PlutoCell(value: model),
      },
    );
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Qualification Name",
          field: "name",
          enableRowChecked: true,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Expire",
          field: "expire",
          width: 100,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Levels",
          field: "levels",
          width: 100,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Comments",
          field: "comment",
          width: 120,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultTooltipWidget();
          },
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          width: 60,
          renderer: (rendererContext) {
            final deletable = rendererContext.cell.value.deleteable;
            return rendererContext.actionMenuWidget(
              onDelete: !deletable
                  ? null
                  : () {
                      onDelete(() async {
                        return await deleteSelected(rendererContext.row);
                      }, showError: false);
                    },
              onEdit: () => onEdit((p0) => NewQualificationPopup(model: p0),
                  rendererContext.cell.value),
            );
          },
        ),
      ];

  @override
  Future<List<QualificationMd>?> fetch() async {
    final res = await dispatch<ListMd>(const GetListsAction());
    if (res.isLeft) {
      return res.left.qualifications;
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
      final res = await dispatch<bool>(DeleteQualificationAction(id));
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
