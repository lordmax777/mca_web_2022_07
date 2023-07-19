import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class NewPropertyStaffPopup extends StatefulWidget {
  final int shiftId;
  const NewPropertyStaffPopup({super.key, required this.shiftId});

  @override
  State<NewPropertyStaffPopup> createState() => _NewPropertyStaffPopupState();
}

class _NewPropertyStaffPopupState extends State<NewPropertyStaffPopup>
    with FormsMixin<NewPropertyStaffPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserCard(
                title: "Create New",
                items: [
                  UserCardItem(
                      title: "Department",
                      isRequired: true,
                      dropdown: UserCardDropdown(
                          valueId: selected1?.id,
                          onChanged: (value) {
                            setState(() {
                              selected1 = value;
                            });
                          },
                          items: [
                            for (final dep
                                in appStore.state.generalState.lists.groups)
                              DefaultMenuItem(id: dep.id, title: dep.name)
                          ])),
                  UserCardItem(
                    title: "Number Of Staff",
                    controller: controller1,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  UserCardItem(
                    title: "Maximum Staff",
                    controller: controller2,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
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
              if (!validateForm()) return;
              if (selected1 == null) {
                context.showError("Please select a department");
                return;
              }
              final success = await dispatch<bool>(PostPropertyStaffAction(
                shiftId: widget.shiftId,
                minOfStaff: int.parse(controller1.text),
                groupId: selected1!.id,
                maxOfStaff: int.tryParse(controller2.text),
              ));
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
    );
  }
}
