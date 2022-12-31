// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../theme/theme.dart';
import '../../home_page.dart';
import '../property_drawer.dart';

class PropertiesController extends GetxController {
  static PropertiesController get to => Get.find();

  final RxInt _pageSize = 10.obs;
  final RxInt _page = 1.obs;
  int get page => _page.value;
  int get pageSize => _pageSize.value;
  set setPage(int value) => _page.value = value;
  set setPageSize(int value) => _pageSize.value = value;
  final RxBool _isSmLoaded = false.obs;
  bool get isSmLoaded => _isSmLoaded.value;
  set setIsSmLoaded(bool value) => _isSmLoaded.value = value;

  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
          title: "Property Name",
          field: "name",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) =>
              GridTableHelpers.getMainColoredRenderer(rendererContext,
                  title: rendererContext.cell.value.toString(),
                  onTap: (PlutoColumnRendererContext ctx) =>
                      _onColumnItemNavigate(ctx))),
      PlutoColumn(
        title: "Location",
        field: "location",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          title: "Client", field: "client", type: PlutoColumnType.text()),
      PlutoColumn(
          title: "Warehouse", field: "warehouse", type: PlutoColumnType.text()),
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

  final RxList<PropertiesMd> _deps = <PropertiesMd>[].obs;
  void removeDepsWhere(PropertiesMd w) =>
      _deps.removeWhere((e) => e.id == w.id);
  List<PropertiesMd> get departments => _deps;

  setList(List<PropertiesMd> d) {
    final dd = [...d];
    dd.sort((a, b) => a.title!.compareTo(b.title!));
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
    update();
  }

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    inactiveRows.addAll(gridStateManager.refRows.where((element) =>
        !(element.cells["action"]!.value as PropertiesMd).active!));
    if (!isShowInactive) {
      gridStateManager.removeRows(inactiveRows);
    }
    gridStateManager.setPage(0);
    gridStateManager.setPageSize(10);
    gridStateManager.setPage(page);
    _setFilter();
    setIsSmLoaded = true;
  }

  void _setFilter() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        if (gridStateManager.page > 1) {
          gridStateManager.setPage(1);
        }
        gridStateManager.setFilter(
          (element) {
            final String search = searchController.text.toLowerCase();
            bool searched =
                element.cells['name']?.value.toLowerCase().contains(search);
            if (!searched) {
              searched = element.cells['location']?.value
                  .toLowerCase()
                  .contains(search);
              if (!searched) {
                searched = element.cells['client']?.value
                    .toLowerCase()
                    .contains(search);
                if (!searched) {
                  searched = (element.cells['warehouse']?.value
                          .toString()
                          .toLowerCase()
                          .contains(search)) ??
                      false;
                  if (!searched) {
                    searched = element.cells['status']?.value
                        .toLowerCase()
                        .contains(search);
                  }
                }
              }
            }
            return searched;
          },
        );
        onPageChange(gridStateManager.page);
        onPageSizeChange(gridStateManager.pageSize.toString());
        return;
      }

      gridStateManager.setFilter((element) => true);
      onPageChange(gridStateManager.page);
      onPageSizeChange(gridStateManager.pageSize.toString());
    });
  }

  void onPageSizeChange(pageS) {
    setPageSize = int.parse(pageS);
    gridStateManager.setPageSize(pageSize);
    gridStateManager.setPage(1);
    setPage = 1;
    update();
  }

  void onPageChange(int page) {
    setPage = page;
    gridStateManager.setPage(page);
    update();
  }

  Future<void> _onColumnItemNavigate(PlutoColumnRendererContext ctx) async {
    appStore.dispatch(UpdateGeneralStateAction(
        endDrawer: PropertyDrawer(
      property: ctx.row.cells['action']?.value,
    )));
    await Future.delayed(const Duration(milliseconds: 100));
    if (scaffoldKey.currentState != null) {
      if (!scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }

  void _onEditClick(BuildContext context, PlutoColumnRendererContext ctx) {
    showOverlayPopup(
        body: WaresNewWarePopupWidget(qualif: ctx.cell.value),
        context: context);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
