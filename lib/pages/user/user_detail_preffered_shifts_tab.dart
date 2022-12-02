import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../comps/show_overlay_popup.dart';
import '../../manager/models/preffered_shift_md_md.dart';
import '../../manager/models/visa_md.dart';
import '../../theme/theme.dart';

class PrefferedShiftsWidget extends StatefulWidget {
  const PrefferedShiftsWidget({Key? key}) : super(key: key);

  @override
  State<PrefferedShiftsWidget> createState() => _PrefferedShiftsWidgetState();
}

class _PrefferedShiftsWidgetState extends State<PrefferedShiftsWidget> {
  final List<Widget> _generalItems = [];
  // final List<int> selectedItemIds;

  @override
  void initState() {
    super.initState();
    _addGeneralTabItems();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => ErrorWrapper(
        errors: [state.usersState.userDetailPreferredShift.error],
        child: SpacedColumn(
          verticalSpace: 16.0,
          children: [
            const SizedBox(),
            _header(),
            ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                  color: ThemeColors.gray11, height: 1.0, thickness: 1.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _generalItems.length + 1,
              itemBuilder: (context, index) {
                if (index == _generalItems.length) {
                  return SaveAndCancelButtonsWidget(
                    formKeys: [],
                  );
                }
                return _generalItems[index];
              },
            ),
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
          ButtonMedium(
            bgColor: ThemeColors.red3,
            icon: const HeroIcon(HeroIcons.bin,
                color: ThemeColors.white, size: 20),
            text: "Delete Selected",
            onPressed: () {
              // final selectedItemIds = userDetailsPayrollSm.checkedRows
              //     .map<int>((e) => e.cells['item']?.value.uqId)
              //     .toList();
              // if (selectedItemIds.isNotEmpty) {
              //   await appStore.dispatch(
              //       GetDeleteUserDetailsQualifsAction(ids: selectedItemIds));
              // }
            },
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
    _generalItems.add(_buildExpandableItem(1));
    _generalItems.add(_buildExpandableItem(2));
    _generalItems.add(_buildExpandableItem(3));
    _generalItems.add(_buildExpandableItem(4));
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
  final GlobalKey _columnsMenuKey = GlobalKey();
  bool _isSmLoaded = false;
  late PlutoGridStateManager userDetailsPayrollSm;
  final List<VisaMd> _contracts = [];

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
  //

  @override
  void initState() {
    super.initState();
    _contracts.clear();
    _contracts.addAll(appStore.state.usersState.userDetailVisas.data!);
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

  void _setSm(PlutoGridStateManager sm) {
    setState(() {
      userDetailsPayrollSm = sm;

      _isSmLoaded = true;
    });
  }
}
