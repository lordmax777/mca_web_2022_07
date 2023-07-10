import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';

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
          Text('Minimum stock level'),
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

    context.futureLoading(() async {
      //todo: save
    });
  }
}
