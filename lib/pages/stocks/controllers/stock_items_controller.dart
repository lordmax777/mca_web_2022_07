import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/pages/stocks/controllers/stock_items_new_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';

class StockItemsController extends GetxController {
  static StockItemsController get to => Get.find();
  //UI Variables
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
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Our Price",
        field: "our_price",
        enableEditingMode: true,
        enableAutoEditing: true,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: GridTableHelpers.getCurrencyColumnType(),
        renderer: GridTableHelpers.getCurrencyTypeRenderer,
      ),
      PlutoColumn(
        title: "Customer Price",
        field: "customer_price",
        enableEditingMode: true,
        enableAutoEditing: true,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: GridTableHelpers.getCurrencyColumnType(),
        renderer: GridTableHelpers.getCurrencyTypeRenderer,
      ),
      PlutoColumn(
        title: "Tax",
        field: "tax",
        enableEditingMode: true,
        enableAutoEditing: true,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.select(appStore
            .state.generalState.paramList.data!.taxes
            .map((e) => e.rate)
            .toList()),
        renderer: (rendererContext) {
          int? taxId = ListTaxes.byRate(rendererContext.cell.value)?.id;
          taxId ??= ListTaxes.byId(rendererContext.cell.value)?.id;
          return UsersListTable.defaultTextWidget(
              "${ListTaxes.byId(taxId ?? 1)?.rate}%",
              textAlign: TextAlign.right);
        },
      ),
    ];
  }

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    gridStateManager.setPage(0);
    gridStateManager.setPageSize(10);
    gridStateManager.setPage(page);
    _setFilter();
    setIsSmLoaded = true;
  }

  void onEdit(PlutoGridOnChangedEvent event) async {
    final oldRow = event.row;
    final StorageItemMd item = event.row.cells['item']!.value;
    final int id = item.id!.toInt();
    final String name = event.row.cells['item_name']!.value;
    final num ourPrice = event.row.cells['our_price']!.value;
    final num customerPrice = event.row.cells['customer_price']!.value;
    int? taxId = ListTaxes.byId(event.row.cells['tax']!.value)?.id;
    taxId ??= ListTaxes.byRate(event.row.cells['tax']!.value)?.id;

    Future<void> update() async {
      // showLoading();
      gridStateManager.setShowLoading(true);
      final ApiResponse res = await restClient()
          .postStorageItems(
            id: id,
            name: name,
            active: item.active ?? false,
            service: item.service ?? false,
            incomingPrice: ourPrice.toString(),
            outgoingPrice: customerPrice.toString(),
            taxId: taxId ?? 1,
          )
          .nocodeErrorHandler();

      // await closeLoading();
      gridStateManager.setShowLoading(false);

      if (!res.success) {
        gridStateManager.removeRows([oldRow]);
        final String field = event.column.field;
        oldRow.cells[field]!.value = event.oldValue;
        gridStateManager.insertRows(event.rowIdx, [oldRow]);
        showError(ApiHelpers.getRawDataErrorMessages(res));
      }
    }

    await update();
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
            bool searched = element.cells['item_name']?.value
                .toLowerCase()
                .contains(search);
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
  }

  void onPageChange(int page) {
    setPage = page;
    gridStateManager.setPage(page);
  }

  //Departments
  final RxList<StorageItemMd> _deps = <StorageItemMd>[].obs;
  void removeDepsWhere(StorageItemMd w) =>
      _deps.removeWhere((e) => e.id == w.id);
  List<StorageItemMd> get departments => _deps;
  setList(List<StorageItemMd> d) {
    _deps.value = d;
    return _deps;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
