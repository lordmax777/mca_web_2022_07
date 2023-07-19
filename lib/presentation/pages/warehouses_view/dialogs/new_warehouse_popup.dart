import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';


class NewWarehousePopup extends StatefulWidget {
  const NewWarehousePopup({super.key, this.model});
  final WarehouseMd? model;

  @override
  State<NewWarehousePopup> createState() => _NewWarehousePopupState();
}

class _NewWarehousePopupState extends State<NewWarehousePopup>
    with FormsMixin<NewWarehousePopup> {
  @override
  void initState() {
    if (widget.model != null) {
      controller1.text = widget.model!.name;
      controller2.text = widget.model!.contactName;
      controller3.text = widget.model!.contactEmail;
      checked1 = widget.model!.sendReport;
      checked2 = widget.model!.active;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: AlertDialog(
        content: SizedBox(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserCard(
                    width: 700,
                    title: "${widget.model != null ? "Edit" : "Add"} Warehouse",
                    items: [
                      UserCardItem(
                        title: "Warehouse Name",
                        isRequired: true,
                        controller: controller1,
                      ),
                      UserCardItem(
                        title: "Contact Name",
                        isRequired: true,
                        controller: controller2,
                      ),
                      UserCardItem(
                        title: "Contact Email",
                        isRequired: true,
                        controller: controller3,
                      ),
                      UserCardItem(
                        title: "Send Report",
                        checked: checked1,
                        onChecked: (v) => setState(() => checked1 = v),
                      ),
                      UserCardItem(
                        title: "Active",
                        checked: checked2,
                        onChecked: (v) => setState(() => checked2 = v),
                      ),
                    ])
              ],
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
              context.futureLoading(() async {
                final success = await dispatch<bool>(PostWarehouseAction(
                    contactName: controller2.text,
                    name: controller1.text,
                    contactEmail: controller3.text,
                    sendReport: checked1,
                    id: widget.model?.id,
                    active: checked2));
                if (success.isRight) {
                  context.showError(success.right.message);
                  return;
                }
                context.pop(success.isLeft && success.left);
              });
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
