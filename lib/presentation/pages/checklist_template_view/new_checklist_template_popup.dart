import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/checklist_templates_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/checklist_template_view/data/checklist_template_datasource.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class NewChecklistTemplatePopup extends StatefulWidget {
  final ChecklistTemplateMd? model;

  const NewChecklistTemplatePopup({super.key, this.model});

  @override
  State<NewChecklistTemplatePopup> createState() =>
      _NewChecklistTemplatePopupState();
}

class _NewChecklistTemplatePopupState extends State<NewChecklistTemplatePopup>
    with FormsMixin<NewChecklistTemplatePopup> {
  late ChecklistTemplateDataSource data;

  bool get isCreate => data.isCreate;

  @override
  void initState() {
    data = ChecklistTemplateDataSource.fromModel(widget.model);
    super.initState();
  }

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: isCreate ? "Create Checklist Template" : "Edit Checklist Template",
      builder: (context) {
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: SpacedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalSpace: 24,
                children: [
                  //Details
                  UserCard(width: context.width / 2, title: "Details", items: [
                    UserCardItem(
                      title: "Template Name",
                      isRequired: true,
                      controller: data.name,
                    ),
                    UserCardItem(
                      title: "Title for PDF report",
                      isRequired: true,
                      controller: data.title,
                    ),
                    UserCardItem(
                      title: "Active",
                      checked: data.active,
                      onChecked: (value) {
                        data = data.copyWith(active: value);
                        updateUI();
                      },
                    ),
                  ]),

                  const Divider(color: Colors.black),

                  //Rooms
                  RepaintBoundary(
                      child: SpacedColumn(children: [
                    //expandable tile inside with text fields and a delete button for each text field
                    for (int i = 0; i < data.contents.length; i++)
                      ExpansionTile(
                        leading: const Icon(Icons.keyboard_arrow_down_rounded),
                        trailing: SpacedRow(
                          horizontalSpace: 16,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DefaultSwitch(
                              value: data.contents[i].isDamaged,
                              label: "Damage",
                              onChanged: (value) {
                                data.contents[i] =
                                    data.contents[i].copyWith(isDamaged: value);
                                updateUI();
                              },
                            ),
                            IconButton(
                              color: Colors.red,
                              onPressed: () {
                                if (isCreate) {
                                  data.contents.removeAt(i);
                                  updateUI();
                                  return;
                                }
                                context.futureLoading(() async {
                                  final res = await dispatch<bool>(
                                      DeleteChecklistTemplateRoomAction(
                                          data.id!,
                                          data.contents[i].name.text));
                                  if (res.isLeft && res.left) {
                                    data.contents.removeAt(i);
                                    updateUI();
                                  } else if (res.isRight) {
                                    context.showError(res.right.message);
                                  } else {
                                    context.showError("Something went wrong");
                                  }
                                });
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        title: Text(data.contents[i].name.text,
                            style: context.textTheme.headlineSmall),
                        children: [
                          const SizedBox(height: 14),
                          for (int j = 0;
                              j < data.contents[i].items.length;
                              j++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SpacedRow(
                                  horizontalSpace: 16,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    DefaultTextField(
                                      label: "Item",
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      controller: data.contents[i].items[j],
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () async {
                                          data.contents[i].items.removeAt(j);
                                          updateUI();
                                        },
                                        child: const Text("Delete Item"))
                                  ],
                                ),
                                //if i is not last index, insert a space
                                if (j != data.contents[i].items.length - 1)
                                  const SizedBox(height: 14),
                              ],
                            ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                              onPressed: () {
                                data.contents[i].items
                                    .add(TextEditingController());
                                updateUI();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Add Item")),
                          const SizedBox(height: 14),
                        ],
                      ),
                  ])),

//Add Room
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    onPressed: () async {
                      //popup to ask for name
                      String? newName;
                      newName = await context.showDialog<String>(AlertDialog(
                        title: const Text("New Section"),
                        content: DefaultTextField(
                          label: "Section Name",
                          onChanged: (value) {
                            newName = value;
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                context.pop(null);
                              },
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                if (newName == null || newName!.isEmpty) {
                                  context.pop(null);
                                  return;
                                }
                                context.pop(newName);
                              },
                              child: const Text("Add")),
                        ],
                      ));
                      if (newName == null) return;
                      data.contents.add(ChecklistTemplateRoomDataSource(
                        name: TextEditingController(text: newName),
                        items: [],
                        isDamaged: false,
                      ));
                      updateUI();
                    },
                    height: 60,
                    child: SpacedRow(
                      mainAxisAlignment: MainAxisAlignment.center,
                      horizontalSpace: 16,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_outline),
                        Text("Add Section", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  //Buttons
                  SpacedRow(
                    mainAxisAlignment: MainAxisAlignment.end,
                    horizontalSpace: 24,
                    children: [
                      ElevatedButton(
                        onPressed: context.pop,
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (!isFormValid) return;
                          //first create the template
                          context.futureLoading(() async {
                            final successTemplateId = await dispatch<int?>(
                                PostChecklistTemplateAction(
                                    id: data.id,
                                    title: data.title.text,
                                    name: data.name.text,
                                    active: data.active));
                            if (successTemplateId.isLeft &&
                                successTemplateId.left != null) {
                              //then create the rooms
                              final List<String> failed = [];
                              for (int i = 0; i < data.contents.length; i++) {
                                final item = data.contents[i];
                                if (item.items.isEmpty) continue;
                                final successRoom = await dispatch(
                                    PostChecklistTemplateRoomAction(
                                  checklistTemplateId: successTemplateId.left!,
                                  name: item.name.text,
                                  damage: item.isDamaged,
                                  items: item.items.map((e) => e.text).toList()
                                    ..removeWhere((element) => element.isEmpty),
                                ));
                                if (successRoom.isRight) {
                                  failed.add(item.name.text);
                                }
                              }
                              if (failed.isNotEmpty) {
                                context.showError(
                                    "Failed to create the following rooms: ${failed.join(", ")}",
                                    onClose: () => context.pop(true));
                              } else {
                                await appStore.dispatch(
                                    const GetChecklistTemplatesAction());
                                context.pop(true);
                              }
                            } else if (successTemplateId.isRight) {
                              context
                                  .showError(successTemplateId.right.message);
                            } else {
                              context.showError("Something went wrong");
                            }
                          });
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  )
                ]),
          ),
        );
      },
    );
  }
}
