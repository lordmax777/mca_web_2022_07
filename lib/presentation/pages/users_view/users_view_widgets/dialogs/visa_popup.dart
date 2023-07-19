import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

class VisaPopup extends StatefulWidget {
  final UserVisaMd? item;
  final UserMd user;

  const VisaPopup({super.key, this.item, required this.user});

  @override
  State<VisaPopup> createState() => _VisaPopupState();
}

class _VisaPopupState extends State<VisaPopup> with FormsMixin<VisaPopup> {
  UserVisaMd? get item => widget.item;
  bool get isNew => item == null;
  UserMd get user => widget.user;

  @override
  void initState() {
    super.initState();
    if (!isNew) {
      selected1 = DefaultMenuItem(
          id: item!.visaTypeMd(appStore.state.generalState.lists.visas)!.id,
          title: item!.title);
      controller1.text = item!.documentNumber;
      controller2.text = item!.notes;
      checked1 = item!.hasExpireDate;
      selectedDate1 = item!.startDateMd;
      selectedDate2 = item!.endDateMd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("${isNew ? "Add" : "Update"} Visa"),
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
          final types = [...vm.lists.visas];
          return Form(
            key: formKey,
            child: SpacedColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalSpace: 32.0,
              children: [
                UserCard(title: "", items: [
                  UserCardItem(
                    title: "Visa Type",
                    isRequired: true,
                    dropdown: UserCardDropdown(
                        valueId: selected1?.id,
                        items: [
                          for (var item in types)
                            DefaultMenuItem(
                              id: item.id,
                              title: item.name,
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            selected1 = value;
                          });
                        }),
                  ),
                  UserCardItem(
                    title: "Document Number",
                    controller: controller1,
                    isRequired: true,
                  ),
                  UserCardItem(
                    title: "Has Expire Date",
                    onChecked: (value) {
                      setState(() {
                        checked1 = value;
                      });
                    },
                    checked: checked1,
                  ),
                  UserCardItem(
                    title: "Start Date",
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
                    title: "End Date",
                    simpleText:
                        selectedDate2?.toApiDateWithDash ?? "Select Date",
                    onSimpleTextTapped: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: selectedDate1 ?? DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            selectedDate2 = value;
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
                ]),
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
              if (!formKey.currentState!.validate()) return;
              if (selected1 == null) {
                context.showError("Please select a user");
                return;
              }
              if (selectedDate1 == null) {
                context.showError("Please select a start date");
                return;
              }
              if (selectedDate2 == null) {
                context.showError("Please select an end date");
                return;
              }

              if (formKey.currentState!.validate()) {
                context.futureLoading(() async {
                  final created = await dispatch<bool>(PostUserVisaAction(
                    user.id,
                    startDate: selectedDate1!,
                    endDate: selectedDate2!,
                    hasExpireDate: checked1,
                    typeId: selected1!.id,
                    documentNumber: controller1.text,
                    visaId: item?.id,
                    notes: controller2.text.isEmpty ? null : controller2.text,
                  ));
                  if (created.isLeft) {
                    context.pop(true);
                  } else {
                    context.showError(created.right.message);
                  }
                });
              }
            }),
      ],
    );
  }
}
