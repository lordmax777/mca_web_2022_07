import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/stocks_action.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

class AddToStockPopup extends StatefulWidget {
  final WarehouseMd warehouse;
  final StockMd stock;
  final bool isAdd;
  const AddToStockPopup(
      {super.key,
      required this.warehouse,
      required this.stock,
      this.isAdd = true});

  @override
  State<AddToStockPopup> createState() => _AddToStockPopupState();
}

class _AddToStockPopupState extends State<AddToStockPopup>
    with FormsMixin<AddToStockPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(
              '${widget.isAdd ? "Add" : "Remove"} ${widget.isAdd ? "to" : "from"} stock'),
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
      content: Form(
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
              title: "Amount to ${widget.isAdd ? "add" : "remove"}",
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
    );
  }

  void onSave() {
    if (!formKey.currentState!.validate()) return;

    context.futureLoading(() async {
      //todo: add/remove to stock
      final success = await dispatch<bool>(AddToStockAction(
        quantity: int.parse(controller1.text),
        warehouseId: widget.warehouse.id,
        itemId: widget.stock.itemId!,
        comment: controller3.text,
        documentNumber: controller2.text,
      ));
      if (success.isLeft && success.left) {
        context.pop(true);
      } else if (success.isRight) {
        context.showError(success.right.message);
      } else {
        context.showError("Something went wrong, please try again later.");
      }
    });
  }
}
