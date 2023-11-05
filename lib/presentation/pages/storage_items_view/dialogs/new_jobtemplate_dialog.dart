import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/jobtemplate_action.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/form/models/dp_item.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:pluto_grid/pluto_grid.dart';

class NewJobTemplatePopup extends StatefulWidget {
  final JobTemplateMd? model;
  const NewJobTemplatePopup({super.key, this.model});

  @override
  State<NewJobTemplatePopup> createState() => _NewJobTemplatePopupState();
}

class _NewJobTemplatePopupState extends State<NewJobTemplatePopup> {
  JobTemplateMd? get model => widget.model;
  bool get isNew => model == null;

  final mainFormKey = FormModel();

  final List<PlutoColumn> columns = [
    PlutoColumn(
      enableAutoEditing: false,
      title: "Item name",
      field: 'itemName',
      type: PlutoColumnType.text(),
      cellPadding: EdgeInsets.zero,
      renderer: (rendererContext) {
        return FormDropdown(
            vm: DropdownModel(
                name: "itemName",
                hasSearchBox: true,
                initialValue:
                    rendererContext.row.cells["itemId"]?.value?.toString(),
                onChanged: (id) {
                  //update name
                  rendererContext.stateManager
                      .changeCellValue(rendererContext.cell, id);
                  //update id
                  rendererContext.row.cells["itemId"]?.value = id;
                },
                items: appStore.state.generalState.storageItems
                    .map((e) => DpItem(id: e.id.toString(), title: e.name))
                    .toList()));
      },
    ),
    PlutoColumn(
        enableAutoEditing: true,
        enableEditingMode: true,
        title: "Price",
        field: 'price',
        type: PlutoColumnType.number()),
    PlutoColumn(
        enableAutoEditing: true,
        enableEditingMode: true,
        title: "Quantity",
        field: "qty",
        type: PlutoColumnType.number()),
    PlutoColumn(
        enableAutoEditing: true,
        enableEditingMode: true,
        title: "Comment",
        field: "comment",
        type: PlutoColumnType.text()),
    PlutoColumn(
      enableEditingMode: false,
      title: "Save",
      width: 80,
      minWidth: 80,
      field: "save",
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        final status =
            rendererContext.row.cells["status"]!.value as TableRowStatus;
        return IconButton(
            color: Colors.green,
            onPressed: status == TableRowStatus.saved
                ? null
                : () {
                    print(rendererContext.row.cells['itemId']?.value);
                  },
            icon: const Icon(Icons.save));
      },
    ),
    PlutoColumn(
      enableEditingMode: false,
      title: "Delete",
      field: "delete",
      width: 80,
      minWidth: 80,
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        final status =
            rendererContext.row.cells["status"]!.value as TableRowStatus;
        return IconButton(
            color: Colors.red,
            onPressed: status == TableRowStatus.saved ? null : () {},
            icon: const Icon(Icons.delete));
      },
    ),
    PlutoColumn(
        title: "Status",
        field: "status",
        width: 0,
        minWidth: 0,
        type: PlutoColumnType.text()),
  ];
  final ValueNotifier<PlutoGridStateManager?> _sm = ValueNotifier(null);
  PlutoGridStateManager? get sm => _sm.value;

  void onSave() async {
    mainFormKey.saveAndValidate();
    if (!mainFormKey.isValid) return;
    final rows = sm?.rows ?? [];
    final data = mainFormKey.formKey.currentState!.value;
    final name = data["name"] as String;
    final active = data["active"] as bool;
    final clientId = int.tryParse(data["client_id"] ?? '');
    final comment = data["comment"] as String?;
    final items = rows.map<JobTemplateItemMd>((e) {
      final itemId = e.cells["itemId"]!.value as String;
      final price = e.cells["price"]!.value as num;
      final qty = e.cells["qty"]!.value as num;
      final comment = e.cells["comment"]?.value as String?;
      // final combine = e.cells["combine"]!.value as bool;
      return JobTemplateItemMd(
          id: 0,
          itemId: int.parse(itemId),
          price: price,
          quantity: qty,
          comment: comment,
          combine: false);
    }).toList();
    try {
      final res = await context.futureLoading(() async {
        return await dispatch<int?>(SaveJobTemplateAction(
            id: model?.id,
            name: name,
            active: active,
            clientId: clientId,
            comment: comment,
            items: items));
      });
      if (res.isRight) {
        context.showError(res.right.message);
      } else {
        //success
      }
      logger(res, hint: "SaveJobTemplateAction success");
    } catch (e) {
      logger(e.toString(), hint: "SaveJobTemplateAction fail");
    }
  }

  void onAddItem(
      [JobTemplateItemMd? item, TableRowStatus status = TableRowStatus.idle]) {
    sm?.insertRows(0, [
      buildItemRow(
          item ??
              const JobTemplateItemMd(
                  id: -1,
                  itemId: 0,
                  quantity: 0,
                  price: 0,
                  comment: "",
                  combine: false),
          status: status)
    ]);
  }

  PlutoRow buildItemRow(JobTemplateItemMd item,
      {TableRowStatus status = TableRowStatus.idle}) {
    return PlutoRow(cells: {
      "itemId": PlutoCell(value: item.itemId),
      "itemName": PlutoCell(
          value:
              item.item(appStore.state.generalState.storageItems)?.name ?? ""),
      "price": PlutoCell(value: item.price),
      "qty": PlutoCell(value: item.quantity),
      "comment": PlutoCell(value: item.comment),
      "save": PlutoCell(value: ""),
      "delete": PlutoCell(value: ""),
      "status": PlutoCell(value: status),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(onPressed: context.pop, child: const Text("Cancel")),
        ElevatedButton(onPressed: onSave, child: const Text("Save")),
      ],
      contentPadding: EdgeInsets.zero,
      title: Text("${isNew ? "Add" : "Update"} Job Template"),
      content: StoreConnector<AppState, ListMd>(
        converter: (store) => store.state.generalState.lists,
        builder: (context, vm) {
          final clients = vm.clients;

          return DefaultForm(
              vm: mainFormKey,
              child: SizedBox(
                width: context.width * 0.7,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FormContainer(
                        left: [
                          FormWithLabel(
                            labelVm: const LabelModel(
                                text: "Template Name", isRequired: true),
                            formBuilderField: FormInput(
                                vm: InputModel(
                                    name: "name",
                                    hintText: "Default",
                                    validators: [
                                  FormBuilderValidators.required()
                                ])),
                          ),
                          FormWithLabel(
                            labelVm: const LabelModel(text: "Client"),
                            formBuilderField: FormDropdown(
                                vm: DropdownModel(
                                    name: "client_id",
                                    items: clients
                                        .map((e) => DpItem(
                                            id: e.id.toString(),
                                            title: e.name,
                                            subtitle: e.company))
                                        .toList(),
                                    hasSearchBox: true)),
                          ),
                        ],
                        right: const [
                          FormWithLabel(
                              labelVm: LabelModel(text: "Comment"),
                              formBuilderField: FormInput(
                                  vm: InputModel(
                                name: "comment",
                                helperText: "Press ENTER to add new line",
                              ))),
                          FormSwitch(
                              vm: SwitchModel(
                            name: "active",
                            title: "Active",
                            initialValue: true,
                          )),
                        ],
                      ),

                      const SizedBox(height: 8),
                      SizedBox(
                        height: context.height * 0.6,
                        child: DefaultTable(
                            headerEnd: ValueListenableBuilder(
                              valueListenable: _sm,
                              builder: (context, value, child) => Row(
                                children: [
                                  ElevatedButton.icon(
                                      onPressed: onAddItem,
                                      icon: const Icon(Icons.add),
                                      label: const Text("Add new item")),
                                ],
                              ),
                            ),
                            hasFooter: false,
                            mode: PlutoGridMode.normal,
                            onLoaded: (e) {
                              e.stateManager.setPageSize(999);
                              _sm.value = e.stateManager;
                              if (!isNew) {
                                mainFormKey.formKey.currentState
                                    ?.patchValue(model!.toJson());
                                for (var item in model!.items) {
                                  onAddItem(item, TableRowStatus.saved);
                                }
                              }
                            },
                            columns: columns,
                            rows: []),
                      )
                      // DefaultForm(
                      //     clearValueOnUnregister: true,
                      //     vm: itemsFormKey,
                      //     child:
                      //         SpacedColumn(verticalSpace: 8, children: items)),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
