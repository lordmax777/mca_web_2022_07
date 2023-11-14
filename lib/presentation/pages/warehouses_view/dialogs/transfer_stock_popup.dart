import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/actions/stocks_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class TransferStockPopup extends StatefulWidget {
  final WarehouseMd warehouse;
  final StockMd stock;

  const TransferStockPopup(
      {super.key, required this.warehouse, required this.stock});

  @override
  State<TransferStockPopup> createState() => _TransferStockPopupState();
}

class _TransferStockPopupState extends State<TransferStockPopup>
    with FormsMixin<TransferStockPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Transfer stock'),
          const Spacer(),
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onSave,
          child: const Text("Submit"),
        ),
      ],
      content: StoreConnector<AppState, List<WarehouseShortMd>>(
        converter: (store) => store.state.generalState.lists.warehouses,
        builder: (context, vm) => Form(
          key: formKey,
          child: UserCard(
            title: "",
            items: [
              UserCardItem(
                title: "Warehouse",
                simpleText: widget.warehouse.name,
              ),
              UserCardItem(
                title: "Item name",
                simpleText: widget.stock.itemName,
              ),
              UserCardItem(
                title: "Current Stock",
                simpleText: widget.stock.current?.toString(),
              ),
              UserCardItem(
                title: "Transfer to",
                isRequired: true,
                dropdown: UserCardDropdown(
                  valueId: selected1?.id,
                  items: [
                    for (final item in vm)
                      DefaultMenuItem(
                          id: item.id,
                          title: item.name,
                          subtitle: item.contactName),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selected1 = value;
                    });
                  },
                ),
              ),
              UserCardItem(
                title: "Amount to transfer",
                controller: controller1,
                isRequired: true,
                keyboardType: TextInputType.number,
              ),
              UserCardItem(
                title: "Document Number",
                controller: controller2,
              ),
              UserCardItem(
                title: "Comment",
                controller: controller3,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSave() {
    if (!formKey.currentState!.validate()) return;
    if (selected1 == null) {
      context.showError("Please select a warehouse");
      return;
    }
    context.futureLoading(() async {
      /// Map<itemId, quantity>
      final Map<String, String> items = {
        "${widget.stock.itemId}": controller1.text
      };
      final success = await dispatch<bool>(StockTransferAction(
        fromWarehouseId: widget.stock.storageId!,
        toWarehouseId: selected1!.id,
        items: items,
        comment: controller3.text,
        documentNumber: controller2.text,
      ));
      if (success.isLeft && success.left) {
        //success
        context.pop(true);
      } else if (success.isRight) {
        context.showError(success.right.message);
      } else {
        context.showError("Something went wrong");
      }
    });
  }
}
