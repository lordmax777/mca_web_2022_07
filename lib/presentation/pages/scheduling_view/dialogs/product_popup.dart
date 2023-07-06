import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/storage_item_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';

import 'create_schedule_popup.dart';

class ProductPopup extends StatefulWidget {
  const ProductPopup({super.key});

  @override
  State<ProductPopup> createState() => _ProductPopupState();
}

class _ProductPopupState extends State<ProductPopup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  // WarehouseShortMd? warehouseMd;
  final TextEditingController priceController = TextEditingController();
  TaxMd? taxMd;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ListMd>(
      converter: (store) => store.state.generalState.lists,
      builder: (context, vm) {
        return AlertDialog(
          title: const Text('Add Product'),
          scrollable: true,
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                label("Title", isRequired: true),
                DefaultTextField(
                    controller: titleController,
                    width: double.infinity,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    }),
                // const SizedBox(height: 8),
                // label("Warehouse", isRequired: true),
                // DefaultDropdown(
                //     hasSearchBox: true,
                //     valueId: warehouseMd?.id,
                //     width: double.infinity,
                //     items: [
                //       for (var item in vm.warehouses)
                //         DefaultMenuItem(
                //           id: item.id,
                //           title: item.name,
                //           subtitle: item.contactName,
                //         ),
                //     ],
                //     onChanged: (value) {
                //       warehouseMd = vm.warehouses.firstWhereOrNull(
                //           (element) => element.id == value.id);
                //       if (mounted) {
                //         setState(() {});
                //       }
                //     }),
                const SizedBox(height: 8),
                label("Price", isRequired: true),
                DefaultTextField(
                    controller: priceController,
                    width: double.infinity,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price';
                      }
                      return null;
                    }),
                const SizedBox(height: 8),
                label("Tax", isRequired: true),
                DefaultDropdown(
                    valueId: taxMd?.id,
                    width: double.infinity,
                    items: [
                      for (var item in vm.taxes)
                        DefaultMenuItem(
                          id: item.id,
                          title: item.rate.toStringAsFixed(0),
                        ),
                    ],
                    onChanged: (value) {
                      taxMd = vm.taxes.firstWhereOrNull(
                          (element) => element.id == value.id);
                      if (mounted) {
                        setState(() {});
                      }
                    }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: context.pop,
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: taxMd == null
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) return;

                      final id = await context.futureLoading(() async {
                        return await dispatch<int>(PostStorageItemAction(
                          title: titleController.text,
                          price: double.parse(priceController.text),
                          taxId: taxMd!.id,
                          // warehouseId: warehouseMd!.id,
                        ));
                      });
                      if (id.isLeft) {
                        final item = appStore.state.generalState.storageItems
                            .firstWhereOrNull(
                                (element) => element.id == id.left);
                        if (item != null) {
                          context.pop(item);
                        } else {
                          context.showError('Something went wrong');
                        }
                      } else {
                        context.showError('Cannot create a product!');
                      }
                    },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
