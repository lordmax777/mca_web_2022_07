import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/stocks/controllers/stock_items_new_controller.dart';

import '../../comps/dropdown_widget1.dart';
import '../../manager/models/list_all_md.dart';
import '../../theme/theme.dart';

class StocksNewItemPopupWidget extends StatelessWidget {
  const StocksNewItemPopupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => StockItemsNewItemController());
    final dpWidth = MediaQuery.of(context).size.width;

    return GBuilder<StockItemsNewItemController>(
      child: (controller) => TableWrapperWidget(
          child: Form(
        key: controller.formKey,
        child: SpacedColumn(children: [
          _header(context, controller),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          const SizedBox(),
          _body(dpWidth, controller),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          _footer(context, controller),
        ]),
      )),
    );
  }

  Widget _header(BuildContext context, StockItemsNewItemController controller) {
    controller.forObxValue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: 'New Item',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          IconButton(
              onPressed: () {
                context.popRoute();
              },
              icon: const HeroIcon(HeroIcons.x,
                  color: ThemeColors.gray2, size: 20.0)),
        ],
      ),
    );
  }

  Widget _body(double dpWidth, StockItemsNewItemController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(height: 1),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            labelText: "Item Name",
            controller: controller.nameController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Item name is required";
              }
              return null;
            },
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            labelText: "Our Price",
            rightIcon: HeroIcons.pound,
            keyboardType: TextInputType.number,
            controller: controller.ourPriceController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Price is required";
              }
              if (!p0.isNum) {
                return "Price must be a number";
              }
              return null;
            },
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            rightIcon: HeroIcons.pound,
            keyboardType: TextInputType.number,
            labelText: "Customer Price",
            controller: controller.customPriceController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Price is required";
              }
              if (!p0.isNum) {
                return "Price must be a number";
              }
              return null;
            },
          ),
          DropdownWidget1<ListTaxes>(
            hintText: "Tax",
            dropdownBtnWidth: dpWidth / 5,
            isRequired: true,
            value: controller.tax.name,
            leftIcon: HeroIcons.percent,
            dropdownOptionsWidth: dpWidth / 5,
            objItems: appStore.state.generalState.paramList.data!.taxes,
            onChangedWithObj: controller.onTaxChange,
            items: appStore.state.generalState.paramList.data!.taxes
                .map((e) => e.rate.toString())
                .toList(),
          ),
          // TextInputWidget(
          //   isRequired: true,
          //   width: dpWidth / 5,
          //   rightIcon: HeroIcons.percent,
          //   keyboardType: TextInputType.number,
          //   labelText: "Tax",
          //   controller: controller.taxController,
          //   validator: (p0) {
          //     if (p0 == null || p0.isEmpty) {
          //       return "Tax is required";
          //     }
          //     if (!p0.isNumericOnly) {
          //       return "Tax must be a number";
          //     }
          //     return null;
          //   },
          // ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context, StockItemsNewItemController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.end,
        horizontalSpace: 16.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonLargeSecondary(
            text: 'Cancel',
            paddingWithoutIcon: true,
            onPressed: context.popRoute,
          ),
          ButtonLarge(
            paddingWithoutIcon: true,
            icon: const HeroIcon(HeroIcons.check, size: 20.0),
            text: 'Add Item',
            onPressed: controller.create,
          ),
        ],
      ),
    );
  }
}
