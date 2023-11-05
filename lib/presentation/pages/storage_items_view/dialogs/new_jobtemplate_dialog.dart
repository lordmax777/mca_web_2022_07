import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mca_dashboard/manager/manager.dart';
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
        enableAutoEditing: true,
        enableEditingMode: true,
        title: "Item name",
        field: 'itemName',
        type: PlutoColumnType.select(appStore.state.generalState.storageItems
            .map((e) => e.name)
            .toList())),
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
      field: "save",
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        final status =
            rendererContext.row.cells["status"]!.value as TableRowStatus;
        return IconButton(
            onPressed: status == TableRowStatus.saved ? null : () {},
            icon: const Icon(Icons.save));
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

  void onSave() {
    mainFormKey.saveAndValidate();
    if (!mainFormKey.isValid) return;
  }

  void onAddItem(
      [JobTemplateItemMd? item, TableRowStatus status = TableRowStatus.idle]) {
    sm?.insertRows(0, [
      buildItemRow(
          item ??
              const JobTemplateItemMd(
                  id: 0, quantity: 0, price: 0, comment: "", combine: false),
          status: status)
    ]);
  }

  PlutoRow buildItemRow(JobTemplateItemMd item,
      {TableRowStatus status = TableRowStatus.idle}) {
    return PlutoRow(cells: {
      "itemName": PlutoCell(
          value:
              item.item(appStore.state.generalState.storageItems)?.name ?? ""),
      "price": PlutoCell(value: item.price),
      "qty": PlutoCell(value: item.quantity),
      "comment": PlutoCell(value: item.comment),
      "save": PlutoCell(value: item),
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
