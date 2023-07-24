import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

class ReviewPopup extends StatefulWidget {
  final UserReviewMd? review;
  final UserMd user;

  const ReviewPopup({super.key, this.review, required this.user});

  @override
  State<ReviewPopup> createState() => _ReviewPopupState();
}

class _ReviewPopupState extends State<ReviewPopup>
    with FormsMixin<ReviewPopup> {
  UserReviewMd? get review => widget.review;
  bool get isNew => review == null;
  UserMd get user => widget.user;

  @override
  void initState() {
    super.initState();
    if (!isNew) {
      selectedDate1 = review!.dateTime;
      controller1.text = review!.title;
      controller2.text = review!.notes;
      final user = appStore.state.generalState.users.firstWhereOrNull(
          (element) => element.fullname == review!.conducted_by);
      if (user != null) {
        selected1 = DefaultMenuItem(id: user.id, title: user.fullname);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("${isNew ? "Add" : "Update"} Review"),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, vm) {
          final users = [...vm.users]
              // .where((element) => element.isManager)
              ;
          return Form(
            key: formKey,
            child: SpacedColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalSpace: 32.0,
              children: [
                UserCard(
                  title: "",
                  items: [
                    UserCardItem(
                      title: "Title",
                      controller: controller1,
                      isRequired: true,
                    ),
                    UserCardItem(
                      title: "Conducted By",
                      isRequired: true,
                      dropdown: UserCardDropdown(
                          valueId: selected1?.id,
                          items: [
                            for (var user in users)
                              DefaultMenuItem(
                                id: user.id,
                                title: user.fulltitle,
                                subtitle: user.username,
                                additionalId: user.groupId,
                              )
                          ],
                          onChanged: (value) {
                            setState(() {
                              selected1 = value;
                            });
                          }),
                    ),
                    UserCardItem(
                      title: "Conducted On",
                      simpleText:
                          selectedDate1?.toApiDateWithDash ?? "Select Date",
                      onSimpleTextTapped: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              selectedDate1 = value;
                            });
                          }
                        });
                      },
                    ),
                    UserCardItem(
                      title: "Comment",
                      controller: controller2,
                      maxLines: 4,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        TextButton(
            child: const Text("Save"),
            onPressed: () async {
              if (selected1 == null) {
                context.showError("Please select a user");
                return;
              }
              if (selectedDate1 == null) {
                context.showError("Please select a date");
                return;
              }
              if (formKey.currentState!.validate()) {
                context.futureLoading(() async {
                  final created =
                      await dispatch<bool>(GetCreateUserReviewAction(
                    conductedBy: selected1!.id,
                    title: controller1.text,
                    date: selectedDate1!,
                    reviewid: review?.id,
                    notes: controller2.text.isEmpty ? null : controller2.text,
                    userId: user.id,
                  ));
                  if (created.isLeft) {
                    context.pop(true);
                  } else {
                    DependencyManager.instance.navigation
                        .showFail(created.right.message);
                  }
                });
              }
            }),
      ],
    );
  }
}
