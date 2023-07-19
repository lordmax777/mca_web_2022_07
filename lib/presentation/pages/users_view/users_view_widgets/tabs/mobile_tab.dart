import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

import '../../../../../manager/manager.dart';

class UserMobileTab extends StatefulWidget {
  final UserMd user;

  const UserMobileTab({super.key, required this.user});

  @override
  State<UserMobileTab> createState() => _UserMobileTabState();
}

class _UserMobileTabState extends State<UserMobileTab>
    with FormsMixin<UserMobileTab> {
  UserMd get user => widget.user;
  UserStatusMd? userStatus;
  bool mobileRegistered = false;
  DateTime? registeredDate;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          await Future.wait([
            fetchUserStatus(),
            fetchUserMobile(),
          ]);
        }
      },
    );
  }

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchUserStatus() async {
    await context.futureLoading(() async {
      final success =
          await dispatch<UserStatusMd>(GetUserStatusAction(userId: user.id));
      if (success.isLeft) {
        userStatus = success.left;
        updateUI();
      }
    });
  }

  Future<void> fetchUserMobile() async {
    await context.futureLoading(() async {
      final success = await dispatch<Map<String, dynamic>>(
          GetUserMobileAction(userId: user.id));
      if (success.isLeft) {
        mobileRegistered = success.left['registered'];
        checked1 = false;
        if (mobileRegistered) {
          registeredDate = DateTime.tryParse(success.left['date'] ?? "");
        } else {
          registeredDate = null;
        }
        updateUI();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: StoreConnector<AppState, ListMd>(
          converter: (store) => store.state.generalState.lists,
          builder: (context, vm) {
            final statuses = [...vm.statuses];
            final shifts = [...vm.shifts];
            final locations = [...vm.locations];
            return SpacedColumn(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 32,
                  runSpacing: 32,
                  children: [
                    //Current Status
                    UserCard(
                      width: 450,
                      title: "Current Status",
                      items: [
                        UserCardItem(
                          title: "Status",
                          dropdown: UserCardDropdown(
                            items: [
                              for (final st in statuses)
                                DefaultMenuItem(
                                    id: st.id,
                                    title: st.name,
                                    additionalId: st.name)
                            ],
                            additionalValueId: userStatus?.name,
                          ),
                        ),
                        UserCardItem(
                          title: "Location",
                          dropdown: UserCardDropdown(
                            items: [
                              for (final st in locations)
                                DefaultMenuItem(
                                  id: st.id,
                                  title: st.name,
                                  additionalId: st.name,
                                )
                            ],
                            additionalValueId: userStatus?.location,
                          ),
                        ),
                        UserCardItem(
                          title: "Shift",
                          dropdown: UserCardDropdown(
                            items: [
                              for (final st in shifts)
                                DefaultMenuItem(
                                    id: st.id,
                                    title: st.name,
                                    additionalId: st.name,
                                    subtitle: st
                                        .getClientMd(
                                            appStore.state.generalState.clients)
                                        ?.name)
                            ],
                            additionalValueId: userStatus?.shift,
                          ),
                        ),
                        UserCardItem(
                          title: "Comment",
                          disabled: true,
                          controller:
                              TextEditingController(text: userStatus?.comment),
                          maxLines: 3,
                        ),
                      ],
                    ),
                    //New Status
                    UserCard(
                      width: 450,
                      title: "New Status",
                      items: [
                        UserCardItem(
                          title: "Status",
                          isRequired: true,
                          dropdown: UserCardDropdown(
                            items: [
                              for (final st in statuses)
                                DefaultMenuItem(id: st.id, title: st.name)
                            ],
                            onChanged: (value) {
                              selected1 = value;
                              updateUI();
                            },
                            valueId: selected1?.id,
                          ),
                        ),
                        UserCardItem(
                          title: "Location",
                          isRequired: true,
                          dropdown: UserCardDropdown(
                            items: [
                              for (final st in locations)
                                DefaultMenuItem(id: st.id, title: st.name)
                            ],
                            onChanged: (value) {
                              selected2 = value;
                              updateUI();
                            },
                            valueId: selected2?.id,
                          ),
                        ),
                        UserCardItem(
                          title: "Shift",
                          isRequired: true,
                          dropdown: UserCardDropdown(
                            items: [
                              for (final st in shifts)
                                DefaultMenuItem(
                                    id: st.id,
                                    title: st.name,
                                    subtitle: st
                                        .getClientMd(
                                            appStore.state.generalState.clients)
                                        ?.name)
                            ],
                            onChanged: (value) {
                              selected3 = value;
                              updateUI();
                            },
                            valueId: selected3?.id,
                          ),
                        ),
                        UserCardItem(
                          title: "Comment",
                          controller: controller1,
                          maxLines: 3,
                        ),
                        UserCardItem(
                          customWidget: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!formKey.currentState!.validate()) return;
                                if (selected1 == null ||
                                    selected2 == null ||
                                    selected3 == null) {
                                  context.showError(
                                      "Please fill all required fields");
                                  return;
                                }
                                context.futureLoading(() async {
                                  final success = await dispatch<bool>(
                                    PostUserStatusAction(
                                        userId: user.id,
                                        statusId: selected1!.id,
                                        locationId: selected2!.id,
                                        shiftId: selected3!.id,
                                        comments: controller1.text),
                                  );
                                  if (success.isLeft) {
                                    await fetchUserStatus();
                                    context.showSuccess("Status updated");
                                  }
                                  if (success.isRight) {
                                    context.showError(success.right.message);
                                  }
                                });
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Mobile
                    UserCard(
                      title: "Mobile Authorization",
                      width: 450,
                      items: [
                        UserCardItem(
                          title: "Last Authorized Date",
                          simpleText: registeredDate?.toApiDateTime ??
                              "Mobile device is not registered!",
                        ),
                        if (mobileRegistered)
                          UserCardItem(
                            title: "Unregister",
                            onChecked: (value) {
                              checked1 = value;
                              updateUI();
                            },
                            checked: checked1,
                          ),
                        UserCardItem(
                            customWidget: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              onPressed: mobileRegistered && checked1
                                  ? () {
                                      context.futureLoading(() async {
                                        final success = await dispatch<bool>(
                                            DeleteUserMobileAction(
                                                userId: user.id));
                                        if (success.isLeft) {
                                          await fetchUserMobile();
                                          context.showSuccess(
                                              "Mobile device unregistered");
                                        }
                                        if (success.isRight) {
                                          context
                                              .showError(success.right.message);
                                        }
                                      });
                                    }
                                  : null,
                              child: const Text("Submit")),
                        ))
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
