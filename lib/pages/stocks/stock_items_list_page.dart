import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/mca_loading.dart';
import '../../manager/redux/states/general_state.dart';
import '../../theme/theme.dart';
import 'controllers/stock_items_controller.dart';

class StockItemsListPage extends StatelessWidget {
  const StockItemsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: SpacedColumn(
        verticalSpace: 16.0,
        children: [
          const PagesTitleWidget(title: 'Stock Items'),
          _Body(),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GBuilder<StockItemsController>(
      child: (controller) => TableWrapperWidget(
          child: SizedBox(
        width: double.infinity,
        child: SpacedColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, controller),
            _body(context, controller),
            if (controller.isSmLoaded) _footer(controller),
          ],
        ),
      )),
    );
  }

  Widget _header(BuildContext context, StockItemsController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SpacedRow(
            horizontalSpace: 12.0,
            children: [
              TextInputWidget(
                  controller: controller.searchController,
                  hintText: 'Search stock items...',
                  defaultBorderColor: ThemeColors.gray11,
                  width: 360,
                  leftIcon: HeroIcons.search),

              // TODO: Add a button to show a tuttorial on how to use the table
            ],
          ),
          SpacedRow(horizontalSpace: 16.0, children: [
            ButtonMedium(
              text: "New Item",
              icon: const HeroIcon(HeroIcons.plusCircle, size: 20),
              onPressed: () async {
                final bool? res = await showOverlayPopup(
                    body: const StocksNewItemPopupWidget(), context: context);
                logger("res: $res", hint: 'StocksNewItemPopupWidget');
                if (res == true) {
                  await McaLoading.futureLoading(() async =>
                      await appStore.dispatch(GetAllStorageItemsAction()));
                } else if (res == false) {
                  McaLoading.showFail("Failed to add new item");
                }
                //
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, StockItemsController controller) {
    return StockItemsListTable(
      onSmReady: controller.setSm,
      onChanged: controller.onEdit,
      rows: controller.departments.reactive.value
              ?.map<PlutoRow>(_buildItem)
              .toList() ??
          [],
      cols: controller.columns(context),
    );
  }

  PlutoRow _buildItem(StorageItemMd e) {
    return PlutoRow(cells: {
      "item": PlutoCell(value: e),
      "item_name": PlutoCell(value: e.name),
      "our_price": PlutoCell(value: e.incomingPrice),
      "customer_price": PlutoCell(value: e.outgoingPrice),
      "tax": PlutoCell(value: ListTaxes.byId(e.taxId)?.rate ?? 0),
    });
  }

  Widget _footer(StockItemsController controller) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 32.0, top: 4.0, bottom: 16.0),
      child: SpacedRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpacedRow(
                horizontalSpace: 8.0,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KText(
                      text: "Showing",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                  DropdownWidget(
                    hintText: "Entries",
                    items: Constants.tablePageSizes
                        .map<String>((e) => e.toString())
                        .toList(),
                    dropdownBtnWidth: 120,
                    onChanged: controller.onPageSizeChange,
                    value: controller.pageSize.toString(),
                  ),
                  // MyWidget(),
                  KText(
                      text: "of ${controller.departments.length} entries",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                ]),
            TablePaginationWidget(
                currentPage: controller.page,
                totalPages: controller.gridStateManager.totalPage,
                onPageChanged: controller.onPageChange),
          ]),
    );
  }
}
