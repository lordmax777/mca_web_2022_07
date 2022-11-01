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

class StockItemsController extends GetxController {
  static StockItemsController get to => Get.find();
  //UI Variables
  final RxDouble _deleteBtnOpacity = 0.5.obs;
  final Rx<ErrorModel> error = ErrorModel().obs;
  set setError(ErrorModel val) => error.value = val;

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
        title: "item",
        field: "item",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        title: "Item Name",
        field: "item_name",
        enableEditingMode: true,
        enableAutoEditing: true,
        width: 1000,
        enableRowChecked: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Our Price",
        field: "our_price",
        enableEditingMode: true,
        enableAutoEditing: true,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          return UsersListTable.defaultTextWidget(
              "\$${rendererContext.cell.value}",
              textAlign: TextAlign.right);
        },
      ),
      PlutoColumn(
        title: "Customer Price",
        field: "customer_price",
        enableEditingMode: true,
        enableAutoEditing: true,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          return UsersListTable.defaultTextWidget(
              "\$${rendererContext.cell.value}",
              textAlign: TextAlign.right);
        },
      ),
      PlutoColumn(
        title: "Tax",
        field: "tax",
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          return UsersListTable.defaultTextWidget(
              "${rendererContext.cell.value}%",
              textAlign: TextAlign.right);
        },
      ),
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
    gridStateManager.setOnChanged(_onEdit);
  }

  void _onEdit(PlutoGridOnChangedEvent event) {}

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
              searched = element.cells['our_price']?.value
                      .toString()
                      .toLowerCase()
                      .contains(search) ??
                  false;
              if (!searched) {
                searched = element.cells['customer_price']?.value
                        .toString()
                        .toLowerCase()
                        .contains(search) ??
                    false;
                if (!searched) {
                  searched = (element.cells['tax']?.value
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
      showError(resp?.rawError?.data.toString() ?? "Error");
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
