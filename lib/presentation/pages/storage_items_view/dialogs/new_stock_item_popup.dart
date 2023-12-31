import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class NewStorageItemPopup extends StatefulWidget {
  const NewStorageItemPopup({super.key, this.model});
  final StorageItemMd? model;

  @override
  State<NewStorageItemPopup> createState() => _NewStorageItemPopupState();
}

class _NewStorageItemPopupState extends State<NewStorageItemPopup>
    with FormsMixin<NewStorageItemPopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.model != null) {
        controller1.text = widget.model!.name;
        controller2.text = widget.model!.incomingPrice.toString();
        controller3.text = widget.model!.outgoingPrice.toString();
        final tax = appStore.state.generalState.lists.taxes
            .firstWhereOrNull((element) => element.id == widget.model!.taxId);
        if (tax != null) {
          selected2 = DefaultMenuItem(id: tax.id, title: tax.rate.toString());
        }
        checked1 = widget.model!.service;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: AlertDialog(
        content: SizedBox(
          child: Form(
            key: formKey,
            child: StoreConnector<AppState, ListMd>(
              converter: (store) => store.state.generalState.lists,
              builder: (context, vm) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserCard(
                      width: 700,
                      title:
                          "${widget.model != null ? "Edit" : "Add"} Storage Item",
                      items: [
                        UserCardItem(
                          title: "Item Name",
                          isRequired: true,
                          controller: controller1,
                        ),
                        UserCardItem(
                          title: "Our Price",
                          isRequired: true,
                          controller: controller2,
                        ),
                        UserCardItem(
                          title: "Customer Price",
                          isRequired: true,
                          controller: controller3,
                        ),
                        UserCardItem(
                            title: "Tax",
                            isRequired: true,
                            dropdown: UserCardDropdown(
                              items: [
                                for (final tax in (vm.taxes))
                                  DefaultMenuItem(
                                    id: tax.id,
                                    title: tax.rate.toString(),
                                  )
                              ],
                              valueId: selected2?.id,
                              onChanged: (value) {
                                selected2 = value;
                                setState(() {});
                              },
                            )),
                        UserCardItem(
                          checked: checked1,
                          title: "Service",
                          onChecked: (value) {
                            checked1 = value;
                            setState(() {});
                          },
                        )
                      ])
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: context.pop,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (!validateForm()) return;
              if (selected2 == null) {
                context.showError("Please select tax");
                return;
              }
              final price = double.tryParse(controller2.text);
              final outgoingPrice = double.tryParse(controller3.text);
              if (price == null) {
                context.showError("Please enter valid price");
                return;
              }
              if (outgoingPrice == null) {
                context.showError("Please enter valid outgoing price");
                return;
              }
              context.futureLoading(() async {
                final success = await dispatch<int>(PostStorageItemAction(
                  id: widget.model?.id,
                  taxId: selected2!.id,
                  title: controller1.text,
                  price: price,
                  outgoingPrice: outgoingPrice,
                  isService: checked1,
                ));
                if (success.isRight) {
                  context.showError(success.right.message);
                  return;
                }
                context.pop(success.isLeft);
              });
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
