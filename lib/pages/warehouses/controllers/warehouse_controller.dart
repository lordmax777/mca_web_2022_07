import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';
import '../../home_page.dart';

class WarehouseController extends GetxController {
  static WarehouseController get to => Get.find();

  //UI Variables
  final RxDouble _deleteBtnOpacity = 0.5.obs;

  final RxInt _pageSize = 10.obs;
  final RxInt _page = 1.obs;
  int get page => _page.value;
  int get pageSize => _pageSize.value;
  set setPage(int value) => _page.value = value;
  set setPageSize(int value) => _pageSize.value = value;
  final RxBool _isSmLoaded = false.obs;
  bool get isSmLoaded => _isSmLoaded.value;
  set setIsSmLoaded(bool value) => _isSmLoaded.value = value;

  final TextEditingController searchController = TextEditingController();

  late PlutoGridStateManager gridStateManager;
  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
        width: 300.0,
        title: "Location Name",
        field: "warehouse_name",
        enableRowChecked: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 360.0,
        title: "Contact Name",
        field: "contact_name",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          width: 300.0,
          title: "Contact Email",
          field: "contact_email",
          type: PlutoColumnType.text()),
      PlutoColumn(
        width: 250.0,
        title: "Linked Properties",
        field: "linked_properties",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return KText(
            text: rendererContext.cell.value.toString(),
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            onTap: () => _onColumnItemNavigate(rendererContext),
            isSelectable: false,
          );
        },
      ),
      PlutoColumn(
          title: "Action",
          field: "action",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "Edit",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onEditClick(context, ctx),
              icon: const HeroIcon(
                HeroIcons.edit,
                color: ThemeColors.blue3,
                size: 12,
              ),
            );
          }),
    ];
  }

  double get deleteBtnOpacity => _deleteBtnOpacity.value;
  set setDeleteBtnOpacity(double value) {
    _deleteBtnOpacity.value = value;
  }

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    gridStateManager.setOnRowChecked((event) {
      if (gridStateManager.checkedRows.isNotEmpty) {
        setDeleteBtnOpacity = 1.0;
      } else {
        setDeleteBtnOpacity = 0.5;
      }
    });
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
            bool searched = element.cells['warehouse_name']?.value
                .toLowerCase()
                .contains(search);
            if (!searched) {
              searched = element.cells['contact_name']?.value
                  .toLowerCase()
                  .contains(search);
              if (!searched) {
                searched = element.cells['contact_email']?.value
                    .toLowerCase()
                    .contains(search);
                if (!searched) {
                  searched = (element.cells['linked_properties']?.value
                          .toString()
                          .toLowerCase()
                          .contains(search)) ??
                      false;
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
        endDrawer: WarehouseDrawer(
      warehouse: ctx.row.cells['action']?.value,
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

  Future<void> deleteSelectedRows() async {
    final ids = gridStateManager.checkedRows
        .map<int>((e) => e.cells['action']?.value.id)
        .toList();
    if (ids.isEmpty) return;
    showLoading();
    bool allSuccess = true;
    ApiResponse? resp;
    for (int i = 0; i < ids.length; i++) {
      final id = ids[i];
      final ApiResponse res =
          await restClient().deleteWarehouse(id).nocodeErrorHandler();
      if (!res.success) {
        allSuccess = false;
        resp = res;
        break;
      } else {
        _deps.removeWhere((element) => element.id == id);
      }
    }

    if (allSuccess) {
      gridStateManager.removeRows(gridStateManager.checkedRows);
      gridStateManager.toggleAllRowChecked(false);
      setDeleteBtnOpacity = 0.5;
      // await appStore.dispatch(GetWarehousesAction());
      closeLoading();
    } else {
      await closeLoading();
      if (resp != null) {
        if (resp.resCode == 401) {
          showError("Can delete only what was created today!");
        } else {
          showError(resp.rawError?.data.toString() ?? "Error");
        }
      }
    }
    update();
  }

  //Departments
  final RxList<WarehouseMd> _deps = <WarehouseMd>[].obs;
  void removeDepsWhere(WarehouseMd w) => _deps.removeWhere((e) => e.id == w.id);
  List<WarehouseMd> get departments => _deps;
  setList(List<WarehouseMd> d) {
    final dd = [...d];
    dd.sort((a, b) => a.name.compareTo(b.name));
    _deps.value = dd;
    return _deps;
  }

  //Functions
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
