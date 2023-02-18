// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../theme/theme.dart';
import '../../home.dart';

class DepartmentsController extends GetxController {
  //Etc
  final List<Tab> tabs = const [Tab(text: 'Departments'), Tab(text: 'Groups')];
  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
          title: "Department Name",
          field: "department_name",
          width: PlutoGridSettings.columnWidth + 700,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) =>
              GridTableHelpers.getMainColoredRenderer(rendererContext,
                  onTap: (PlutoColumnRendererContext ctx) =>
                      _onColumnItemNavigate(ctx))),
      PlutoColumn(
        title: "Status",
        field: "status",
        enableSorting: false,
        type: PlutoColumnType.text(),
        renderer: GridTableHelpers.getStatusRenderer,
      ),
      PlutoColumn(
        title: "Action",
        field: "action",
        enableSorting: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) => GridTableHelpers.getActionRenderer(
          rendererContext,
          onTap: (PlutoColumnRendererContext ctx) => _onEditClick(context, ctx),
        ),
      ),
    ];
  }

  final RxList<ListGroup> _deps = <ListGroup>[].obs;
  List<ListGroup> get departments => _deps;
  setList(List<ListGroup> d) {
    final dd = [...d];
    dd.sort((a, b) => a.name.compareTo(b.name));
    _deps.value = dd;
    return _deps;
  }

  final TextEditingController searchController = TextEditingController();
  late PlutoGridStateManager gridStateManager;
  final List<PlutoRow> inactiveRows = [];
  final RxBool _isShowInactive = false.obs;
  bool get isShowInactive => _isShowInactive.value;
  void setShowInactive(bool val) {
    if (val) {
      gridStateManager.appendRows(inactiveRows);
    } else {
      gridStateManager.removeRows(inactiveRows);
    }
    // ignore: invalid_use_of_visible_for_testing_member
    searchController.notifyListeners();
    _isShowInactive.value = val;
  }

  //Functions
  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    inactiveRows.addAll(gridStateManager.refRows.where(
        (element) => !(element.cells["action"]!.value as ListGroup).active));
    if (!isShowInactive) {
      gridStateManager.removeRows(inactiveRows);
    }
    _setFilter();
  }

  void _setFilter() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        gridStateManager.setFilter(
          (element) {
            bool searched = element.cells['department_name']?.value
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['status']?.value
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase());
            }
            return searched;
          },
        );
        return;
      }

      gridStateManager.setFilter((element) => true);
    });
  }

  Future<void> _onColumnItemNavigate(PlutoColumnRendererContext ctx) async {
    final ListGroup group = ctx.row.cells['action']!.value;
    appStore.dispatch(
        UpdateGeneralStateAction(endDrawer: DepGroupDrawer(group: group)));
    await Future.delayed(const Duration(milliseconds: 100));
    if (Constants.scaffoldKey.currentState != null) {
      if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {
        Constants.scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }

  void _onEditClick(BuildContext context, PlutoColumnRendererContext ctx) {
    showOverlayPopup(
        body: DepartmentsNewDepPopupWidget(group: ctx.cell.value),
        context: context);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
