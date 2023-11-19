import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../manager/redux/actions/jobtemplate_action.dart';

class NewJobTemplatePopup extends StatefulWidget {
  final JobTemplateMd? model;
  final void Function() onRefresh;
  const NewJobTemplatePopup({super.key, this.model, required this.onRefresh});

  @override
  State<NewJobTemplatePopup> createState() => _NewJobTemplatePopupState();
}

class _NewJobTemplatePopupState extends State<NewJobTemplatePopup> {
  JobTemplateMd? get model => widget.model;
  bool get isNew => model == null;
  void Function() get onRefresh => widget.onRefresh;

  final mainFormKey = FormModel();

  late final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      enableEditingMode: false,
      title: "Item name",
      field: 'itemName',
      type: PlutoColumnType.text(),
      cellPadding: EdgeInsets.zero,
      renderer: (rendererContext) {
        final hash = rendererContext.row.hashCode;
        return FormDropdown(
            vm: DropdownModel(
                name: "itemName$hash",
                hasSearchBox: true,
                initialValue: rendererContext.row.cells["itemId"]?.value
                            ?.toString() ==
                        "-1"
                    ? null
                    : rendererContext.row.cells["itemId"]?.value?.toString(),
                onChanged: (id) {
                  //update id
                  rendererContext.row.cells["itemId"]?.value = id;
                  final item = appStore.state.generalState.storageItems
                      .firstWhereOrNull((e) => e.id == int.tryParse(id ?? ""));
                  if (item?.outgoingPrice != null) {
                    rendererContext.row.cells["price"]?.value =
                        item?.outgoingPrice;
                    setState(() {});
                  }
                  //update name
                  rendererContext.stateManager
                      .changeCellValue(rendererContext.cell, id);
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
        width: 100,
        minWidth: 100,
        cellPadding: EdgeInsets.zero,
        field: 'price',
        type: PlutoColumnType.number()),
    PlutoColumn(
        enableAutoEditing: true,
        enableEditingMode: true,
        title: "Quantity",
        cellPadding: EdgeInsets.zero,
        field: "qty",
        width: 100,
        minWidth: 100,
        type: PlutoColumnType.number()),
    PlutoColumn(
        title: "Combine",
        field: "combine",
        enableEditingMode: false,
        width: 120,
        minWidth: 120,
        cellPadding: EdgeInsets.zero,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          final hash = rendererContext.row.hashCode;
          return FormDropdown(
              vm: DropdownModel(
                  name: "combine$hash",
                  initialValue: rendererContext.cell.value?.toString(),
                  onChanged: (id) {
                    //update combine
                    rendererContext.stateManager
                        .changeCellValue(rendererContext.cell, id);
                    //update id
                    rendererContext.row.cells["combine"]?.value = id;
                  },
                  items: const [
                DpItem(id: "yes", title: "Yes"),
                DpItem(id: "no", title: "No")
              ]));
        }),
    PlutoColumn(
      enableEditingMode: true,
      enableAutoEditing: true,
      title: "Comment",
      field: "comment",
      cellPadding: EdgeInsets.zero,
      type: PlutoColumnType.text(),
      // renderer: (rendererContext) {
      //   final comment = rendererContext.cell.value?.toString();
      //   final hash = rendererContext.row.hashCode;
      //   return FormInput(
      //       vm: InputModel(
      //     name: "comment$hash",
      //     initialValue: comment,
      //     onChanged: (value) {
      //       rendererContext.stateManager
      //           .changeCellValue(rendererContext.cell, value);
      //       rendererContext.row.cells["comment"]?.value = value;
      //     },
      //   ));
      // },
    ),
    // PlutoColumn(
    //   enableEditingMode: false,
    //   title: "Save",
    //   width: 80,
    //   minWidth: 80,
    //   field: "save",
    //   type: PlutoColumnType.text(),
    //   renderer: (rendererContext) {
    //     return IconButton(
    //         color: Colors.green,
    //         onPressed: () {
    //           print(rendererContext.row.cells['itemId']?.value);
    //         },
    //         icon: const Icon(Icons.save));
    //   },
    // ),
    PlutoColumn(
      enableEditingMode: false,
      title: "Delete",
      field: "delete",
      width: 60,
      minWidth: 60,
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        return IconButton(
            color: Colors.red,
            onPressed: () => onDeleteItem(rendererContext.row),
            icon: const Icon(Icons.delete));
      },
    ),
  ];
  final ValueNotifier<PlutoGridStateManager?> _sm = ValueNotifier(null);
  PlutoGridStateManager? get sm => _sm.value;

  void onDeleteItem(PlutoRow row) async {
    final id = row.cells["id"]?.value;
    print(id);
    if (id == "-1") {
      print("delete from grid");
      sm?.removeRows([row]);
    } else {
      try {
        print("delete from db"); //delete from db
        final res = await context.futureLoading(() async {
          return await dispatch(
              DeleteJobTemplateItemAction(model!.id, int.parse(id)));
        });
        if (res.isRight) {
          context.showError(res.right.message);
        } else if (res.isLeft) {
          sm?.removeRows([row]);
          context.showSuccess("Item deleted");
          onRefresh();
        } else {
          context.showError("Something went wrong");
        }
      } catch (e) {
        context.showError("Something went wrong");
        logger(e.toString(), hint: "DeleteJobTemplateItemAction fail");
      }
    }
  }

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
      logger(comment, hint: 'comment');
      final combine = (e.cells["combine"]!.value as String?) == "yes";
      return JobTemplateItemMd(
          id: 0,
          itemId: int.parse(itemId),
          price: price,
          quantity: qty,
          comment: comment,
          combine: combine);
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
        context.showSuccess("Package saved");
        onRefresh();
      }
      logger(res, hint: "SaveJobTemplateAction success");
    } catch (e) {
      logger(e.toString(), hint: "SaveJobTemplateAction fail");
    }
  }

  void onAddItem([JobTemplateItemMd? item]) {
    final newItem = buildItemRow(item ??
        const JobTemplateItemMd(
            id: -1, itemId: -1, quantity: 0, price: 0, combine: false));
    sm?.insertRows(0, [newItem]);
  }

  PlutoRow buildItemRow(JobTemplateItemMd item) {
    return PlutoRow(cells: {
      "id": PlutoCell(value: item.id.toString()),
      "itemId": PlutoCell(value: item.itemId.toString()),
      "itemName": PlutoCell(
          value:
              item.item(appStore.state.generalState.storageItems)?.name ?? ""),
      "price": PlutoCell(value: item.price),
      "qty": PlutoCell(value: item.quantity),
      "combine": PlutoCell(value: item.combine ? "yes" : "no"),
      "comment": PlutoCell(value: item.comment ?? ""),
      "delete": PlutoCell(value: ""),
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
      title: Text("${isNew ? "Add" : "Update"} Package"),
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
                                text: "Package Name", isRequired: true),
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
                                  onAddItem(item);
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
