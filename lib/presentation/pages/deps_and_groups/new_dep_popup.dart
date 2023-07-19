import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class NewDepPopup extends StatefulWidget {
  const NewDepPopup({super.key, this.jobTitle});
  final JobTitleMd? jobTitle;

  @override
  State<NewDepPopup> createState() => _NewDepPopupState();
}

class _NewDepPopupState extends State<NewDepPopup>
    with FormsMixin<NewDepPopup> {
  @override
  void initState() {
    if (widget.jobTitle != null) {
      controller1.text = widget.jobTitle!.name;
      checked1 = widget.jobTitle!.active;
    }
    super.initState();
  }

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
                  title:
                      "${widget.jobTitle != null ? "Edit" : "Add"} Department",
                  items: [
                    UserCardItem(
                      title: "Title",
                      isRequired: true,
                      controller: controller1,
                    ),
                    UserCardItem(
                      title: "Is Active",
                      checked: checked1,
                      onChecked: (value) {
                        setState(() {
                          checked1 = value;
                        });
                      },
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
              final success = await dispatch<bool>(PostJobTitleAction(
                  id: widget.jobTitle?.id,
                  title: controller1.text,
                  isActive: checked1));
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
