import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/group_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/job_title_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/qualification_action.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

class NewQualificationPopup extends StatefulWidget {
  const NewQualificationPopup({super.key, this.model});
  final QualificationMd? model;

  @override
  State<NewQualificationPopup> createState() => _NewQualificationPopupState();
}

class _NewQualificationPopupState extends State<NewQualificationPopup>
    with FormsMixin<NewQualificationPopup> {
  @override
  void initState() {
    if (widget.model != null) {
      controller1.text = widget.model!.title;
      checked1 = widget.model!.expire;
      checked2 = widget.model!.levels;
      controller2.text = widget.model!.comments;
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
                    title:
                        "${widget.model != null ? "Edit" : "Add"} Qualification",
                    items: [
                      UserCardItem(
                        title: "Qualification Name",
                        isRequired: true,
                        controller: controller1,
                      ),
                      UserCardItem(
                        title: "Qualification has expiry date",
                        checked: checked1,
                        onChecked: (value) {
                          setState(() {
                            checked1 = value;
                          });
                        },
                      ),
                      UserCardItem(
                        title: "Qualification has levels",
                        checked: checked2,
                        onChecked: (value) {
                          setState(() {
                            checked2 = value;
                          });
                        },
                      ),
                      UserCardItem(
                        title: "Comment",
                        controller: controller2,
                        maxLines: 4,
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
                final success = await dispatch<bool>(PostQualificationAction(
                  id: widget.model?.id,
                  title: controller1.text,
                  comments: controller2.text,
                  isExpire: checked1,
                  isLevel: checked2,
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
      ),
    );
  }
}
