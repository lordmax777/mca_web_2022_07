import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../comps/show_overlay_popup.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/sets/state_value.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../new_section_popup.dart';

class Checklist {
  String name = "";
  List<String> items = [];
  bool acceptDamagedItems = false;

  List<String> get getItems => items.map<String>((e) => e.trim()).toList();

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

  String get name => nameController.text.trim();
  String get title => titleController.text.trim();

  int get checklistId => checklist?.id ?? 0;

  final RxBool _isNew = true.obs;
  bool get isNew => _isNew.value;

  bool get nameExists => appStore.state.generalState.checklistTemplates.data!
      .any((element) => element.name.toLowerCase() == name.toLowerCase());
  bool get titleExists => appStore.state.generalState.checklistTemplates.data!
      .any((element) => element.title.toLowerCase() == title.toLowerCase());
  bool roomExists(String text) => checklists.any(
      (element) => element.name.toLowerCase() == text.toLowerCase().trim());

  final RxList<Checklist> checklists = <Checklist>[].obs;
  final RxList<Checklist> deletedChecklists = <Checklist>[].obs;

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
                                  deletedChecklists.add(checklists[index]);
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
          // onEditName: (t) async {
          //   final String? res = await onAddNewSection(
          //       title: t.currentState?.title.text, addAsNew: false);
          //   if (res != null) {
          //     final currentWidget = _generalItems[indexOf];
          //     final currentWidgetState = (currentWidget.key
          //             as LabeledGlobalKey<ExpandableItemWidgetState>)
          //         .currentState;
          //     currentWidgetState?.setState(() {
          //       currentWidgetState.title.text = res;
          //     });
          //     checklists[indexOf].name = res;
          //   }
          // },
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
              // k.currentState?.controllers.last.addListener(() {
              // checklists[indexOf].items.last =
              //     k.currentState?.controllers.last.text.trim() ?? "";

              //   k.currentState?.setState(() {});
              // });
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
      if (checklists.any((element) => element.name == res)) {
        showError("Section with the same name already exists");
        return null;
      }
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

  Future<ApiResponse> postTemplateDetail() async {
    final int id = checklistId;
    const bool status = true; //TODO: Need a active button or not not sure!
    final ApiResponse res = await restClient()
        .postChecklistTemplate(
          id: id,
          name: name,
          title: title,
          active: status,
        )
        .nocodeErrorHandler();
    return res;
  }

  Future<ApiResponse> postTemplateRoom(Checklist chk) async {
    final int id = checklistId;
    final String nm = chk.name;
    final String items = chk.getItems.join("|");
    final bool damage = chk.acceptDamagedItems;
    final ApiResponse res = await restClient()
        .postChecklistTemplateRoom(
          id: id,
          name: nm,
          items: items,
          damage: damage,
        )
        .nocodeErrorHandler();
    return res;
  }

  Future<ApiResponse> deleteTemplateRoom(Checklist chk) async {
    final int id = checklist!.id;
    final String nm = chk.name.trim();
    final ApiResponse res = await restClient()
        .deleteChecklistTemplateRoom(id, nm)
        .nocodeErrorHandler();
    return res;
  }

  void onSave({BuildContext? ctx}) async {
    if (formKey.currentState?.validate() ?? false) {
      if (isNew) {
        deletedChecklists.clear();
      }
      for (var ch in checklists) {
        if (ch.items.isEmpty) {
          showError("Please add item to ${ch.name}, or delete!");
          return;
        }
      }
      await _apiReq(ctx: ctx);
    }
  }

  Future<void> _apiReq({BuildContext? ctx}) async {
    showLoading();
    ApiResponse detailRes = await postTemplateDetail();
    //Details
    if (detailRes.success) {
      bool isAllSuccess = true;
      ApiResponse? roomRes;
      for (var chk in checklists) {
        ApiResponse res = await postTemplateRoom(chk);
        roomRes = res;
        if (!res.success) {
          isAllSuccess = false;
          break;
        }
      }
      //Room
      if (isAllSuccess) {
        bool deleteAllSuccess = true;
        ApiResponse? delRes;
        for (var chk in deletedChecklists) {
          ApiResponse res = await deleteTemplateRoom(chk);
          delRes = res;
          if (!res.success) {
            deleteAllSuccess = false;
            break;
          }
        }
        //Delete
        if (deleteAllSuccess) {
          await appStore.dispatch(GetChecklistTemplatesAction());
          await closeLoading();
          ctx?.popRoute();
        } else {
          _handleError(delRes!);
        }
      } else {
        _handleError(roomRes!);
      }
    } else {
      _handleError(detailRes);
    }
  }

  void _handleError(ApiResponse res) async {
    await appStore.dispatch(GetChecklistTemplatesAction());
    await closeLoading();
    showError(res.data);
  }
}
