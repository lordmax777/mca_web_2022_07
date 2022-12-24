import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../comps/show_overlay_popup.dart';
import '../../../manager/redux/sets/state_value.dart';
import '../new_section_popup.dart';

class Checklist {
  String name = "";
  List<String> items = [];
  bool acceptDamagedItems = false;

  Checklist({
    required this.name,
    required this.items,
    required this.acceptDamagedItems,
  });

  void removeItem(int index) {
    items.removeAt(index);
  }

  void addItem(String item) {
    items.add(item);
  }
}

class NewTemplateController extends GetxController {
  static NewTemplateController get to {
    if (Get.isRegistered<NewTemplateController>()) {
      return Get.find<NewTemplateController>();
    } else {
      return Get.put<NewTemplateController>(NewTemplateController());
    }
  }

  ChecklistTemplateMd? checklist;
  NewTemplateController({this.checklist});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final RxBool _isNew = true.obs;
  bool get isNew => _isNew.value;

  final RxList<Checklist> checklists = <Checklist>[].obs;

  final RxList<Widget> _generalItems = <Widget>[].obs;
  List<Widget> get generalItems => _generalItems;

  void addItem(
      {required String title,
      bool isExpanded = false,
      List<String>? items,
      bool acceptDamagedItems = false}) {
    final key = GlobalKey<ExpandableItemWidgetState>();
    final keyRoomWidget = GlobalKey<RoomWidgetState>();
    checklists.add(Checklist(
        name: title,
        items: items ?? [],
        acceptDamagedItems: acceptDamagedItems));
    final indexOf = _generalItems.length - 1;
    _generalItems.insert(
        indexOf,
        ExpandableItemWidget(
          key: key,
          title: title,
          isExpanded: isExpanded,
          onDelete: (k) {
            showDialog(
                builder: (context) => AlertDialog(
                      icon: const Icon(Icons.warning_amber,
                          color: ThemeColors.red3),
                      title: const Text("Delete"),
                      content: Text(
                          "Are you sure you want to delete ${k.currentState?.title.text}?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              _generalItems
                                  .firstWhereIndexedOrNull((index, element) {
                                if (element.key == k) {
                                  checklists.removeAt(index);
                                }
                                return element.key == k;
                              });
                              _generalItems
                                  .removeWhere((element) => k == element.key);
                              update();
                              context.popRoute();
                            },
                            child: const Text("Yes")),
                        TextButton(
                            onPressed: () {
                              context.popRoute();
                            },
                            child: const Text("Cancel")),
                      ],
                    ),
                context: Get.key.currentContext!);
            update();
          },
          onEditName: (t) async {
            final String? res = await onAddNewSection(
                title: t.currentState?.title.text, addAsNew: false);
            if (res != null) {
              final currentWidget = _generalItems[indexOf];
              final currentWidgetState = (currentWidget.key
                      as LabeledGlobalKey<ExpandableItemWidgetState>)
                  .currentState;
              currentWidgetState?.setState(() {
                currentWidgetState.title.text = res;
              });
              checklists[indexOf].name = res;
            }
          },
          child: RoomWidget(
            key: keyRoomWidget,
            acceptDamagedItems: acceptDamagedItems,
            items: checklists[checklists.length - 1].items,
            onDamageChecked: (k, isDamaged) {
              checklists[indexOf].acceptDamagedItems = isDamaged;
              k.currentState?.setState(() {});
            },
            onAddItem: (k) {
              final ch = checklists[indexOf];
              k.currentState?.controllers.add(TextEditingController());
              k.currentState?.controllers.last.addListener(() {
                checklists[indexOf].items.last =
                    k.currentState?.controllers.last.text ?? "";

                k.currentState?.setState(() {});
              });
              ch.addItem("");
              k.currentState?.setState(() {});
            },
            onDeleteItem: (k, index) {
              final ch = checklists[indexOf];
              ch.removeItem(index);
              k.currentState?.setState(() {});
            },
          ),
        ));

    update();
  }

  void removeItem(ExpandableItemWidget item) {
    _generalItems.remove(item);
    update();
  }

  Future<String?> onAddNewSection({String? title, bool addAsNew = true}) async {
    final String? res = await showOverlayPopup(
        body: NewSectionPopup(title: title), context: Get.key.currentContext!);
    if (res != null) {
      if (addAsNew) {
        addItem(title: res);
      }
    }
    return res;
  }

  @override
  void onReady() {
    super.onReady();
    _isNew.value = checklist == null;
    _generalItems.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: onAddNewSection,
            child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [5, 5],
                color: ThemeColors.gray9,
                // padding: const EdgeInsets.all(6),
                child: SizedBox(
                  height: 64,
                  child: SpacedRow(
                    horizontalSpace: 16,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const HeroIcon(
                        HeroIcons.plusCircle,
                        color: ThemeColors.gray6,
                        size: 22,
                      ),
                      KText(
                        text: "Add Section",
                        isSelectable: false,
                        fontWeight: FWeight.medium,
                        fontSize: 16,
                        textColor: ThemeColors.gray6,
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
    if (!isNew) {
      _onLoadOldChecklist();
    }
    update();
    logger("NewTemplateController onInit");
  }

  void _onLoadOldChecklist() {
    nameController.text = checklist!.name;
    titleController.text = checklist!.title;
    List<CodeMap<List<String>>> rooms = [];
    List<String> damagedRooms = [];
    List<String> checklistI = [];
    for (var element in checklist!.damages) {
      damagedRooms.add(element);
    }
    for (var room in checklist!.getRooms) {
      rooms.add(room);
      logger(room.name);
      logger(room.code);
      for (var item in room.code!) {
        checklistI.add(item);
      }
    }
    for (var room in rooms) {
      addItem(
          title: room.name!,
          items: (room.code) ?? [],
          acceptDamagedItems: damagedRooms.contains(room.name!));
    }
  }

  void onPop() {
    nameController.dispose();
    titleController.dispose();
    _generalItems.clear();
    logger("NewTemplateController disposed");
  }

  void onSave() {
    if (formKey.currentState?.validate() ?? false) {}
  }
}
