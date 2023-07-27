import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/stocks_action.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class ChangeMinLevelPopup extends StatefulWidget {
  final WarehouseMd warehouse;
  final StockMd stock;
  const ChangeMinLevelPopup({
    super.key,
    required this.warehouse,
    required this.stock,
  });

  @override
  State<ChangeMinLevelPopup> createState() => _ChangeMinLevelPopupState();
}

class _ChangeMinLevelPopupState extends State<ChangeMinLevelPopup>
    with FormsMixin<ChangeMinLevelPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Minimum stock level'),
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
              simpleText: widget.stock.current.toString(),
            ),
            if (widget.stock.minimum != null)
              UserCardItem(
                title: "Current Minimum Level",
                simpleText: widget.stock.minimum.toString(),
              ),
            UserCardItem(
              title: "Minimum Level",
              controller: controller1,
              isRequired: true,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  void onSave() {
    if (!formKey.currentState!.validate()) return;
    if (widget.stock.itemId == null || widget.stock.storageId == null) {
      context.showError("Something went wrong");
      return;
    }
    context.futureLoading(() async {
      final res = await dispatch<bool>(ChangeStockMinLevelAction(
          warehouseId: widget.stock.storageId!,
          itemId: widget.stock.itemId!,
          minLevel: int.parse(controller1.text)));
      if (res.isLeft) {
        context.pop(true);
      } else if (res.isRight) {
        context.showError(res.right.message);
      } else {
        context.showError("Something went wrong");
      }
    });
  }
}
