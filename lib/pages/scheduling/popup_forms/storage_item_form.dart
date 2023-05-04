import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../manager/model_exporter.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../utils/global_functions.dart';
import '../create_shift_popup.dart';

class StorageItemForm extends StatefulWidget {
  final AppState state;
  const StorageItemForm({Key? key, required this.state}) : super(key: key);

  @override
  State<StorageItemForm> createState() => _StorageItemFormState();
}

class _StorageItemFormState extends State<StorageItemForm> {
  AppState get state => widget.state;
  List<WarehouseMd> get warehouses => state.generalState.storages;
  List<ListTaxes> get taxes => state.generalState.taxes;

  final ScrollController scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController title =
      TextEditingController(text: kDebugMode ? "Test" : "");
  final TextEditingController customerPrice =
      TextEditingController(text: kDebugMode ? "100" : "");

  int? taxIndex;
  int? warehouseIndex;

  @override
  void dispose() {
    title.dispose();
    customerPrice.dispose();
    scrollController.dispose();
    super.dispose();
  }

  final fieldWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:
          const EdgeInsets.only(left: 40, top: 20, bottom: 20, right: 30),
      title: Row(
        children: [
          const Text("Create new Service/Product"),
          const Spacer(),
          IconButton(
            onPressed: () {
              onWillPop(context).then((value) {
                if (value) {
                  context.popRoute();
                }
              });
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: RawScrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        trackColor: Colors.grey.withOpacity(0.6),
        thickness: 10,
        thumbColor: ThemeColors.MAIN_COLOR.withOpacity(0.7),
        controller: scrollController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 20),
          controller: scrollController,
          child: Form(
            key: _formKey,
            child: SpacedColumn(
              verticalSpace: 16,
              children: [
                labelWithField(
                  "Title",
                  TextInputWidget(
                    width: fieldWidth,
                    controller: title,
                    hintText: "Enter Title",
                    isRequired: true,
                  ),
                ),
                labelWithField(
                    "Warehouse",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      hintText: "Select Warehouse",
                      dropdownBtnWidth: fieldWidth,
                      dropdownOptionsWidth: fieldWidth,
                      items: warehouses
                          .map((e) => CustomDropdownValue(name: e.name))
                          .toList()
                        ..insert(0, CustomDropdownValue(name: "None")),
                      value: warehouseIndex != null
                          ? CustomDropdownValue(
                              name: warehouses[warehouseIndex!].name)
                          : CustomDropdownValue(name: "None"),
                      onChanged: (index) {
                        setState(() {
                          warehouseIndex = index;
                        });
                      },
                    )),
                labelWithField(
                  "Customer's Price",
                  TextInputWidget(
                    width: fieldWidth,
                    controller: customerPrice,
                    hintText: "Enter Price",
                    isRequired: true,
                  ),
                ),
                labelWithField(
                    "Tax %",
                    DropdownWidgetV2(
                      isRequired: true,
                      hintText: "Select Tax",
                      dropdownBtnWidth: fieldWidth,
                      dropdownOptionsWidth: fieldWidth,
                      items: taxes
                          .map((e) =>
                              CustomDropdownValue(name: e.rate.toString()))
                          .toList(),
                      value: taxIndex != null
                          ? CustomDropdownValue(
                              name: taxes[taxIndex!].rate.toString())
                          : null,
                      onChanged: (index) {
                        setState(() {
                          taxIndex = index;
                        });
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ButtonLarge(
            text: "Cancel",
            onPressed: () {
              onWillPop(context).then((value) {
                context.popRoute();
              });
            }),
        ButtonLarge(text: "Create", onPressed: _onSave),
      ],
    );
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      final int? res = await appStore.dispatch(OnCreateNewStorageItemAction(
        title: title.text,
        warehouseId:
            warehouseIndex != null ? warehouses[warehouseIndex!].id : null,
        customerPrice: double.tryParse(customerPrice.text),
        taxId: taxes[taxIndex!].id,
      ));

      if (res != null) {
        context.popRoute(res);
      }
    }
  }
}
