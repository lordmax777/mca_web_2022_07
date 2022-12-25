import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/models/preffered_shift_md_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/redux/states/users_state/users_state.dart';
import '../../../theme/theme.dart';

class PreferredShiftsController extends GetxController {
  static PreferredShiftsController get to => Get.find();
  final RxList<PreferredShiftMd> selectedShifts = <PreferredShiftMd>[].obs;

  void onDispose() {
    selectedShifts.clear();
    update();
  }

  void addShift(PreferredShiftMd? sm) {
    if (sm != null) {
      selectedShifts.add(sm);
      update();
    }
  }

  void removeShift(PreferredShiftMd? sm) {
    if (sm != null) {
      selectedShifts.removeWhere((element) => element.id == sm.id);
      update();
    }
  }
}

class PreferredShiftsWidget extends StatefulWidget {
  const PreferredShiftsWidget({Key? key}) : super(key: key);

  @override
  State<PreferredShiftsWidget> createState() => _PreferredShiftsWidgetState();
}

class _PreferredShiftsWidgetState extends State<PreferredShiftsWidget> {
  final List<Widget> _generalItems = [];
  bool onChangeItemsAdded = false;

  @override
  void initState() {
    super.initState();
    _addGeneralTabItems();
  }

  @override
  Widget build(BuildContext context) {
    logger(_generalItems.length);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => ErrorWrapper(
        errors: [state.usersState.userDetailPreferredShift.error],
        child: SpacedColumn(
          verticalSpace: 16.0,
          children: [
            const SizedBox(height: 1),
            _header(),
            if (_generalItems.isNotEmpty)
              ListView.separated(
                padding: const EdgeInsets.only(bottom: 32.0),
                separatorBuilder: (context, index) => const Divider(
                    color: ThemeColors.gray11, height: 1.0, thickness: 1.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _generalItems.length,
                itemBuilder: (context, index) {
                  return _generalItems[index];
                },
              )
            else
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: KText(
                  text: 'No shifts found',
                  fontWeight: FWeight.medium,
                  fontSize: 24,
                  isSelectable: false,
                  textColor: ThemeColors.fillColor,
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GetBuilder<PreferredShiftsController>(
            builder: (controller) => ButtonMedium(
              bgColor: ThemeColors.red3,
              icon: const HeroIcon(HeroIcons.bin,
                  color: ThemeColors.white, size: 20),
              text: "Delete Selected",
              onPressed: controller.selectedShifts.isEmpty
                  ? null
                  : () async {
                      final selectedItemIds = controller.selectedShifts
                          .map<int>((e) => e.id)
                          .toList();
                      if (selectedItemIds.isNotEmpty) {
                        await appStore.dispatch(
                            GetDeleteUserPreferredShiftAction(
                                ids: selectedItemIds));
                      }
                    },
            ),
          ),
          ButtonMedium(
            icon: const HeroIcon(HeroIcons.plusCircle, size: 20),
            text: "New Shift",
            onPressed: () {
              showOverlayPopup(
                  body: const UserDetailPreferredShiftsNewShiftPopupWidget(),
                  context: context);
            },
          ),
        ],
      ),
    );
  }

  void _addGeneralTabItems() {
    final List<PreferredShiftMd> list =
        appStore.state.usersState.userDetailPreferredShift.data ?? [];

    bool week1 = false;
    bool week2 = false;
    bool week3 = false;
    bool week4 = false;
    for (var element in list) {
      if (element.weekId == 1) {
        week1 = true;
      }
      if (element.weekId == 2) {
        week2 = true;
      }
      if (element.weekId == 3) {
        week3 = true;
      }
      if (element.weekId == 4) {
        week4 = true;
      }
    }
    if (week1) {
      _generalItems.add(_buildExpandableItem(1));
    }
    if (week2) {
      _generalItems.add(_buildExpandableItem(2));
    }
    if (week3) {
      _generalItems.add(_buildExpandableItem(3));
    }
    if (week4) {
      _generalItems.add(_buildExpandableItem(4));
    }
  }

  Widget _buildExpandableItem(int weekNumber) {
    bool a = true;
    return StatefulBuilder(
      builder: (context, ss) {
        return ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
          trailing: const SizedBox(),
          onExpansionChanged: (value) {
            ss(() {
              a = !value;
            });
          },
          // childrenPadding: EdgeInsets.symmetric(vertical: 16.0),
          leading: HeroIcon(!a ? HeroIcons.up : HeroIcons.down, size: 18.0),
          title: KText(
            text: "Week $weekNumber",
            isSelectable: false,
            fontWeight: FWeight.bold,
            fontSize: 16.0,
            textColor: !a ? ThemeColors.blue6 : ThemeColors.gray2,
          ),
          expandedAlignment: Alignment.topLeft,
          children: [_WeekTableWidget(weekNumber: weekNumber)],
        );
      },
    );
  }
}

class _WeekTableWidget extends StatefulWidget {
  final int weekNumber;
  const _WeekTableWidget({Key? key, required this.weekNumber})
      : super(key: key);

  @override
  State<_WeekTableWidget> createState() => _WeekTableWidgetState();
}

class _WeekTableWidgetState extends State<_WeekTableWidget> {
  late PlutoGridStateManager userDetailsPayrollSm;

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
          title: "item",
          field: "item",
          hide: true,
          type: PlutoColumnType.text()),
      PlutoColumn(
        width: 140.0,
        title: "Location",
        field: "location",
        enableRowChecked: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          width: 80.0,
          title: "Day",
          field: "day",
          type: PlutoColumnType.text()),
      PlutoColumn(
          width: 120.0,
          title: "Shift",
          field: "shift",
          type: PlutoColumnType.text()),
      PlutoColumn(
        title: "Timings",
        field: "timings",
        type: PlutoColumnType.text(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    final list = [...appStore.state.usersState.userDetailPreferredShift.data!];
    list.removeWhere((element) => element.weekId != widget.weekNumber);
    if (list.isEmpty) {
      return Center(
          child: KText(
        text: "No shift found",
        fontSize: 20.0,
        isSelectable: false,
        fontWeight: FWeight.bold,
        textColor: ThemeColors.gray2,
      ));
    }
    return UserDetailPayrollTabTable(
      onSmReady: _setSm,
      dynamicHeight: true,
      onSelected: _onChecked,
      rows: list
          .map<PlutoRow>(
            (e) => PlutoRow(cells: {
              "item": PlutoCell(value: e),
              "location": PlutoCell(value: e.location),
              "day": PlutoCell(value: e.day),
              "shift": PlutoCell(value: e.title),
              "timings": PlutoCell(
                  value:
                      "${formatDateTime(e.start.date, withDate: false, withSeconds: false)} - ${formatDateTime(e.finish.date, withDate: false, withSeconds: false)}")
            }),
          )
          .toList(),
      cols: _cols,
    );
  }

  void _onChecked(PlutoGridOnRowCheckedEvent event) {
    // logger('onChecked');
    // final List<PreferredShiftMd?> selectedItems = userDetailsPayrollSm
    //     .checkedRows
    //     .map<PreferredShiftMd?>((e) => e.cells['item']?.value)
    //     .toList();
    // selectedItems.removeWhere((element) => element == null);
    // PreferredShiftsController.to.selectedShifts.assignAll(selectedItems.cast());
    // logger(PreferredShiftsController.to.selectedShifts.length);
    //
    final bool isAll = event.isAll;
    final bool isChecked = event.isChecked ?? false;
    final List<PlutoRow> rows = userDetailsPayrollSm.rows;
    final PreferredShiftMd? item = event.row?.cells['item']?.value;
    //Handles when all rows are selected
    if (isAll) {
      if (isChecked) {
        for (var row in rows) {
          PreferredShiftsController.to.addShift(row.cells['item']?.value);
        }
      } else {
        for (var row in rows) {
          PreferredShiftsController.to.removeShift(row.cells['item']?.value);
        }
      }
      return;
    }
    if (isChecked) {
      PreferredShiftsController.to.addShift(item);
    } else {
      PreferredShiftsController.to.removeShift(item);
    }
  }

  void _setSm(PlutoGridStateManager sm) {
    setState(() {
      userDetailsPayrollSm = sm;
    });
  }
}
