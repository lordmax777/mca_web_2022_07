import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';
import 'controllers/new_template_controller.dart';

class RoomWidget extends StatefulWidget {
  final ValueChanged<LabeledGlobalKey<RoomWidgetState>> onAddItem;
  final void Function(LabeledGlobalKey<RoomWidgetState> key, int index)
      onDeleteItem;
  final void Function(LabeledGlobalKey<RoomWidgetState> key, bool isDamaged)
      onDamageChecked;
  final bool acceptDamagedItems;
  final List<String> items;

  const RoomWidget(
      {Key? key,
      required this.onAddItem,
      required this.acceptDamagedItems,
      required this.onDeleteItem,
      required this.onDamageChecked,
      required this.items})
      : super(key: key);

  @override
  State<RoomWidget> createState() => RoomWidgetState();
}

class RoomWidgetState extends State<RoomWidget> {
  final List<TextEditingController> controllers = [];
  bool acceptDamagedItems = false;
  @override
  void dispose() {
    for (var element in controllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (var item in widget.items) {
      controllers.add(TextEditingController(text: item));
    }
    acceptDamagedItems = widget.acceptDamagedItems;
  }

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
        verticalSpace: 32,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacedRow(
            horizontalSpace: 8.0,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCheckboxWidget(
                  onChanged: (value) {
                    setState(() {
                      acceptDamagedItems = value;
                    });
                    widget.onDamageChecked(
                        widget.key as LabeledGlobalKey<RoomWidgetState>, value);
                  },
                  isChecked: acceptDamagedItems),
              KText(
                isSelectable: false,
                onTap: () {
                  setState(() {
                    acceptDamagedItems = !acceptDamagedItems;
                  });
                  widget.onDamageChecked(
                      widget.key as LabeledGlobalKey<RoomWidgetState>,
                      acceptDamagedItems);
                },
                text:
                    'Check if the checklist template room will accept damage images and descriptions.',
                textColor: ThemeColors.gray2,
                fontSize: 14.0,
                fontWeight: FWeight.bold,
              ),
            ],
          ),
          if (controllers.isNotEmpty)
            _buildItems()
          else
            KText(
                text: "Please Add Rooms",
                textColor: ThemeColors.gray5,
                fontSize: 14.0,
                fontWeight: FWeight.bold),
          ButtonLarge(
              icon: const HeroIcon(HeroIcons.plusCircle, size: 20),
              text: "Add Item",
              onPressed: () async {
                widget
                    .onAddItem(widget.key as LabeledGlobalKey<RoomWidgetState>);
              }),
        ]);
  }

  Widget _buildItems() {
    List<Widget> w = [];

    for (var i = 0; i < widget.items.length; i++) {
      w.add(_buildItem(i));
    }

    return SpacedColumn(
        verticalSpace: 24.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: w);
  }

  SpacedRow _buildItem(int i) {
    return SpacedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      horizontalSpace: 32.0,
      children: [
        Expanded(
            flex: 8,
            child: TextInputWidget(
                controller: controllers[i],
                onChanged: (value) {
                  widget.items[i] = value.trim();
                })),
        Expanded(
            flex: 1,
            child: ButtonLarge(
                paddingWithoutIcon: true,
                text: "Delete Item",
                bgColor: ThemeColors.red3,
                onPressed: () {
                  controllers.removeAt(i);
                  widget.onDeleteItem(
                      widget.key as LabeledGlobalKey<RoomWidgetState>, i);
                })),
      ],
    );
  }
}

class NewChecklistTemplatePage extends StatelessWidget {
  final ChecklistTemplateMd? checklist;
  const NewChecklistTemplatePage({super.key, this.checklist});

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;
    Get.lazyPut(() => NewTemplateController(checklist: checklist));
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return GetBuilder<NewTemplateController>(
            dispose: (state) => state.controller?.onPop(),
            builder: (controller) => PageWrapper(
                child: SpacedColumn(verticalSpace: 16.0, children: [
              PageGobackWidget(
                  text: controller.isNew
                      ? "New Template"
                      : controller.checklist!.name),
              TableWrapperWidget(
                padding: const EdgeInsets.only(
                    left: 48.0, right: 48.0, top: 0.0, bottom: 16.0),
                child: Form(
                  key: controller.formKey,
                  child: SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalSpace: 16.0,
                    children: [
                      _buildBody(dpWidth, controller),
                      ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                            color: ThemeColors.gray11,
                            height: 1.0,
                            thickness: 1.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.generalItems.length + 1,
                        itemBuilder: (context, index) {
                          if (index == controller.generalItems.length) {
                            return GetBuilder<NewTemplateController>(
                              id: "name_title_fields",
                              builder: (ctr) => SaveAndCancelButtonsWidget(
                                saveText: controller.isNew
                                    ? "Add Template"
                                    : "Save Template",
                                formKeys: const [],
                                isDisabled: controller.isNew &&
                                    (ctr.titleExists || ctr.nameExists),
                                onSave: () => controller.onSave(ctx: context),
                              ),
                            );
                          }
                          return controller.generalItems[index];
                        },
                      ),
                      // const Divider(color: ThemeColors.gray11, thickness: 1.0),
                      // _buildExpandable(),
                      // _buildAdder(),
                      // const Divider(color: ThemeColors.gray11, thickness: 1.0),
                      // _SaveAndCancelButtonsWidget(isNewContract: controller.isNew),
                    ],
                  ),
                ),
              ),
            ])),
          );
        });
  }

  Widget _buildBody(double dpWidth, NewTemplateController controller) {
    return GetBuilder<NewTemplateController>(
      id: "name_title_fields",
      builder: (controller) {
        return SpacedColumn(
          verticalSpace: 32.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),
            SpacedRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              horizontalSpace: 16.0,
              children: [
                TextInputWidget(
                  isRequired: true,
                  width: dpWidth / 2.5,
                  labelText: "Template Name",
                  controller: controller.nameController,
                  onChanged: (value) {
                    controller.update(['name_title_fields']);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                if (controller.nameExists && controller.isNew)
                  KText(
                      text: "Title already exists",
                      textColor: ThemeColors.red3,
                      fontWeight: FWeight.bold,
                      fontSize: 16.0,
                      isSelectable: false),
              ],
            ),
            SpacedRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              horizontalSpace: 16.0,
              children: [
                TextInputWidget(
                  isRequired: true,
                  width: dpWidth / 2.5,
                  labelText: "Template Title",
                  controller: controller.titleController,
                  onChanged: (value) {
                    controller.update(['name_title_fields']);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                ),
                if (controller.titleExists && controller.isNew)
                  KText(
                      text: "Title already exists",
                      textColor: ThemeColors.red3,
                      fontWeight: FWeight.bold,
                      fontSize: 16.0,
                      isSelectable: false),
              ],
            ),
          ],
        );
      },
    );
  }
}
