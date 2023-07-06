import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/checklist_templates_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/presentation/pages/checklist_template_view/new_checklist_template_popup.dart';
import 'package:mca_dashboard/utils/table_helpers.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ChecklistTemplateView extends StatefulWidget {
  const ChecklistTemplateView({super.key});

  @override
  State<ChecklistTemplateView> createState() => _ChecklistTemplateViewState();
}

class _ChecklistTemplateViewState extends State<ChecklistTemplateView>
    with
        TableFocusNodeMixin<ChecklistTemplateView, ChecklistTemplateMd,
            ChecklistTemplateMd> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<ChecklistTemplateMd>>(
        converter: (store) => store.state.generalState.checklistTemplates,
        onDidChange: onDidChange,
        builder: (context, vm) {
          return DefaultTable(
              headerEnd: ElevatedButton(
                onPressed: () {
                  onEdit((p0) => const NewChecklistTemplatePopup(), null);
                },
                child: const Text("Create Checklist Template"),
              ),
              onChanged: (p0) {
                switch (p0.column.field) {
                  case "sections":
                    final model =
                        p0.row.cells['action']!.value as ChecklistTemplateMd;

                    break;
                }
              },
              focusNode: focusNode,
              onLoaded: onLoaded,
              columns: columns,
              rows: stateManager == null ? [] : stateManager!.rows);
        });
  }

  @override
  Future<List<ChecklistTemplateMd>?> fetch() async {
    final res = await dispatch<List<ChecklistTemplateMd>>(
        const GetChecklistTemplatesAction());
    if (res.isLeft) {
      return res.left;
    }
    return null;
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Qualification Name",
          field: "name",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(
                isActive: rendererContext.row.cells['action']!.value.active);
          },
        ),
        PlutoColumn(
          title: "Title",
          field: "title",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.defaultText(
                isActive: rendererContext.row.cells['action']!.value.active);
          },
        ),
        PlutoColumn(
          title: "Sections",
          field: "sections",
          width: 40,
          type: PlutoColumnType.number(),
          // renderer: (rendererContext) {
          //   return rendererContext.defaultText(isSelectable: true);
          // },
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          width: 40,
          renderer: (rendererContext) {
            return IconButton(
                onPressed: () {
                  onEdit((p0) => NewChecklistTemplatePopup(model: p0),
                      rendererContext.row.cells['action']!.value);
                },
                icon: const Icon(Icons.edit));
          },
        ),
      ];

  @override
  PlutoRow buildRow(ChecklistTemplateMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: model.name),
      "title": PlutoCell(value: model.title),
      "sections": PlutoCell(value: model.contents.length),
      "action": PlutoCell(value: model),
    });
  }
}
