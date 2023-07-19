
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class QualifPopup extends StatefulWidget {
  final UserQualificationMd? item;
  final UserMd user;

  const QualifPopup({super.key, this.item, required this.user});

  @override
  State<QualifPopup> createState() => _QualifPopupState();
}

class _QualifPopupState extends State<QualifPopup>
    with FormsMixin<QualifPopup> {
  UserQualificationMd? get item => widget.item;
  bool get isNew => item == null;
  UserMd get user => widget.user;

  @override
  void initState() {
    super.initState();
    if (!isNew) {
      selected1 = DefaultMenuItem(
          id: item!
              .qualificationMd(
                  appStore.state.generalState.lists.qualifications)!
              .id,
          title: item!.title,
          subtitle: item!.comments);
      selected2 =
          DefaultMenuItem(id: int.parse(item!.levelId), title: item!.level);
      controller1.text = item!.certificateNumber;
      controller2.text = item!.comments;
      selectedDate1 = item!.achievementDateDt;
      selectedDate2 = item!.expiryDateDt;
      file1 = PlatformFile(
          name: item!.certificateNumber,
          size: item!.certificateBytes.length,
          bytes: item!.certificateBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("${isNew ? "Add" : "Update"} Qualification"),
          const Spacer(),
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: StoreConnector<AppState, GeneralState>(
          converter: (store) => store.state.generalState,
          builder: (context, vm) {
            final qualifications = [...vm.lists.qualifications];
            final levels = [...vm.lists.qualificationLevels];

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
                        isRequired: true,
                        title: "Qualification",
                        dropdown: UserCardDropdown(
                          valueId: selected1?.id,
                          items: [
                            ...qualifications.map(
                              (e) => DefaultMenuItem(
                                id: e.id,
                                title: e.title,
                                subtitle: e.comments,
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selected1 = value;
                            });
                          },
                        ),
                      ),
                      UserCardItem(
                        isRequired: true,
                        title: "Certificate Number",
                        controller: controller1,
                      ),
                      UserCardItem(
                        isRequired: true,
                        title: "Level",
                        dropdown: UserCardDropdown(
                          valueId: selected2?.id,
                          items: [
                            ...levels.map(
                              (e) => DefaultMenuItem(
                                id: e.id,
                                title: e.name,
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selected2 = value;
                            });
                          },
                        ),
                      ),
                      UserCardItem(
                        isRequired: true,
                        title: "Start Date",
                        simpleText:
                            selectedDate1?.toApiDateWithDash ?? "Select Date",
                        onSimpleTextTapped: () {
                          showDatePicker(
                            context: context,
                            initialDate: selectedDate1 ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
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
                            initialDate: selectedDate2 ?? DateTime.now(),
                            firstDate: selectedDate1 ?? DateTime(1900),
                            lastDate: DateTime(2100),
                            cancelText: "Clear & Close",
                          ).then((value) {
                            setState(() {
                              selectedDate2 = value;
                            });
                          });
                        },
                      ),
                      UserCardItem(
                          title: "Certificate File",
                          customWidget: InkWell(
                            onTap: () async {
                              final file = await pickFile();
                              if (file == null) return;
                              file1 = file;
                              setState(() {});
                            },
                            child: file1?.bytes == null
                                ? const Text("Select File",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 24))
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("File: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      Image.memory(
                                        file1!.bytes!,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Text("Error");
                                        },
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          if (wasSynchronouslyLoaded) {
                                            return child;
                                          }
                                          return AnimatedOpacity(
                                            opacity: frame == null ? 0 : 1,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeOut,
                                            child: child,
                                          );
                                        },
                                        cacheWidth: 100,
                                        cacheHeight: 100,
                                      ),
                                    ],
                                  ),
                          )),
                      UserCardItem(
                        title: "Comment",
                        controller: controller2,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
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
                context.showError("Please select a qualification");
                return;
              }
              if (selected2 == null) {
                context.showError("Please select a level");
                return;
              }
              if (selectedDate1 == null) {
                context.showError("Please select a start date");
                return;
              }
              if (formKey.currentState!.validate()) {
                context.futureLoading(() async {
                  final created = await dispatch<bool>(PostUserQualifAction(
                    userId: user.id,
                    levelId: selected2!.id,
                    certificateNumber: controller1.text,
                    achievementDate: selectedDate1!,
                    expiryDate: selectedDate2,
                    qualifId: selected1!.id,
                    comment: controller2.text,
                    userQualifId: item?.uqId,
                    certificateBytes: file1?.bytes,
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
