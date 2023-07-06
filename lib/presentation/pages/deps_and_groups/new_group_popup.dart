import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/group_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/job_title_action.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

class NewGroupPopup extends StatefulWidget {
  const NewGroupPopup({super.key, this.model});
  final GroupMd? model;

  @override
  State<NewGroupPopup> createState() => _NewGroupPopupState();
}

class _NewGroupPopupState extends State<NewGroupPopup>
    with FormsMixin<NewGroupPopup> {
  @override
  void initState() {
    if (widget.model != null) {
      controller1.text = widget.model!.name;
      checked1 = widget.model!.active;
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
                    title: "${widget.model != null ? "Edit" : "Add"} Group",
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
                final success = await dispatch<bool>(PostGroupAction(
                    id: widget.model?.id,
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
      ),
    );
  }
}
