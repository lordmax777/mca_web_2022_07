import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class NewPropertyQualificationPopup extends StatefulWidget {
  final int shiftId;
  const NewPropertyQualificationPopup({super.key, required this.shiftId});

  @override
  State<NewPropertyQualificationPopup> createState() =>
      _NewPropertyQualificationPopupState();
}

class _NewPropertyQualificationPopupState
    extends State<NewPropertyQualificationPopup>
    with FormsMixin<NewPropertyQualificationPopup> {
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
                      title: "Qualification",
                      isRequired: true,
                      dropdown: UserCardDropdown(
                          valueId: selected1?.id,
                          onChanged: (value) {
                            setState(() {
                              selected1 = value;
                            });
                          },
                          items: [
                            for (final dep in appStore
                                .state.generalState.lists.qualifications)
                              DefaultMenuItem(id: dep.id, title: dep.title)
                          ])),
                  UserCardItem(
                      title: "Min Level",
                      dropdown: UserCardDropdown(
                          valueId: selected2?.id,
                          onChanged: (value) {
                            if (value.id == selected2?.id) {
                              setState(() {
                                selected2 = null;
                              });
                              return;
                            }
                            setState(() {
                              selected2 = value;
                            });
                          },
                          items: [
                            for (final dep in appStore
                                .state.generalState.lists.qualificationLevels)
                              DefaultMenuItem(id: dep.id, title: dep.name)
                          ])),
                  UserCardItem(
                    title: "Number Of Staff",
                    controller: controller1,
                    isRequired: true,
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
                context.showError("Please select a qualification");
                return;
              }
              final success =
                  await dispatch<bool>(PostPropertyQualificationAction(
                shiftId: widget.shiftId,
                numberOfStaff: int.parse(controller1.text),
                levelId: selected2?.id,
                qualificationId: selected1!.id,
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
